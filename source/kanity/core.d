module kanity.core;

import kanity.render;
import kanity.event;
import kanity.lua;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.opengl3.gl;
import derelict.opengl3.gl;
import std.experimental.logger;
import core.thread;

class Engine{
  //フィールド
private:
 public Renderer renderer;
public  Event event;

public:
  //コンストラクタとデコンストラクタ
  this(){
    info("Load a library \"SDL2\".");
    DerelictSDL2.load;
    info("Load a library \"SDL_Image\".");
    DerelictSDL2Image.load;

    DerelictGL.load;
    DerelictGL3.load;

    if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) != 0) logf(LogLevel.fatal,"Failed initalization of \"SDL2\".\n%s", SDL_GetError());
    info("Success initalization of \"SDL2\".");
    if(IMG_Init(IMG_INIT_PNG) != IMG_INIT_PNG) logf(LogLevel.fatal,"Failed initalization of \"SDL_Image\".\n%s", IMG_GetError());
    info("Success initalization of \"SDL_Image\"");

    SDL_HINT_RENDER_DRIVER.SDL_SetHint("opengl");
    return;
  }
  ~this(){
    SDL_Quit();
    IMG_Quit();
  }

  protected UnderLayer createUnderLayer(string title, int width, int height, Renderer renderer, Event event)
  {
      return new UnderLayer(title, width, height, renderer, event);
  }
  int run(string title, int width, int height){
    //初期化
    renderer = new Renderer(2.0f);
    event = new Event();

    auto TrenderAndEvent = createUnderLayer(title, width, height, renderer, event);
    TrenderAndEvent.start;
    auto script = new LuaLibrary(this);
    script.doFile("test.lua");
    TrenderAndEvent.join;
    return 0;
  }
}

class UnderLayer : Thread {
    private bool running;
    string title;
    int width;
    int height;
    Renderer renderer;
    Event event;
    this(string title, int width, int height, Renderer renderer, Event event){
        running = true;
        this.title = title;
        this.width = width;
        this.height = height;
        this.renderer = renderer;
        this.event = event;
        super(&run);
    }

    protected void init()
    {
        renderer.init(title, width, height);
        event.init();
    }

    void run(){
        init();
        auto frame1 = 1000 / 60;
        do
        {
            auto start = cast(long)SDL_GetTicks;
            renderer.render();
            event.process();
            auto end = cast(long)SDL_GetTicks;
            if (end - start < frame1)
            {
                SDL_Delay(cast(uint)(frame1 - end + start));
            }
        } while(event.isRunning);
    }

    void stop(){
        running = false;
    }
}
