module kanity.render;

import kanity.object;
import kanity.bg;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.opengl3.gl;
import derelict.opengl3.gl3;
import std.experimental.logger;
import std.string;

class Renderer{
  //フィールド
private:
  SDL_Window* window_;
  SDL_Renderer* renderer;
  SDL_GLContext context;
  BG[] bgList;
  bool drawFlag;
public:
  float renderScale = 1.0f;
  this(){
  }
  this(float scale){
    renderScale = scale;
  }
  ~this(){
    window_.SDL_DestroyWindow;
    context = SDL_GL_DeleteContext;
    renderer.SDL_DestroyRenderer;
  }

  void init(string title, int width, int height){
    SDL_GL_DEPTH_SIZE.SDL_GL_SetAttribute(16);
    SDL_GL_DOUBLEBUFFER.SDL_GL_SetAttribute(1);

    window_ = createWindow(title, width, height);
    if(window_ == null) logf(LogLevel.fatal, "Failed to create window.\n%s", SDL_GetError());
    info("Success to create window.");
    window_.SDL_SetWindowData("renderScale", &renderScale);

    renderer = window_.SDL_CreateRenderer(-1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE);

    SDL_Surface* mapchip = IMG_Load("BGTest.png");
    window_.SDL_ShowWindow;

    auto bg1 = new BG(0, 0, mapchip);

    bgList = new BG[1];
    bgList[0] = bg1;

    SDL_Delay(100);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-1, 1, -1, 1, 0, 4);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

    drawFlag = true;
  }
  void render(){
    if(drawFlag){
      glEnable(GL_DEPTH_TEST);
      glEnable(GL_TEXTURE_2D);

      //test.draw;

      foreach(b; bgList)
      {
        b.draw();
      }
      glFinish();
      renderer.SDL_RenderPresent;
      window_.SDL_GL_SwapWindow;
      //drawFlag = false;
    }
  }

  void draw(){
    drawFlag = true;
  }
  //Utils
private:
  SDL_Window* createWindow(string title, int width, int height){
    return SDL_CreateWindow(title.toStringz, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                              width, height, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN);
  }

  void glSetup(){

  }
}
