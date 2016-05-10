module kanity.bg;

public import kanity.object;
public import kanity.character;
import kanity.imports;

import derelict.sdl2.sdl;
import std.variant;

class BG : DrawableObject{
private:
  SDL_Rect bg;
  Character character;
  int[] mapData;

  SDL_Surface* bgScreen;
  import kanity.animation;
  //AnimationData!int xAnim;
  //AnimationData!int yAnim;
public:
  //情報
  uint chipSize;
  uint sizeWidth, sizeHeight;

public:
  this(Character chara){
    super();
    import kanity.render;
      chipSize = Renderer.getData("bgChipSize").get!uint;
      sizeWidth = Renderer.getData("bgSizeWidth").get!uint;
      sizeHeight = Renderer.getData("bgSizeHeight").get!uint;

    character = chara;
    mapData.length = sizeWidth * sizeHeight;
    bgScreen = SDL_CreateRGBSurface(0, chipSize * sizeWidth, chipSize * sizeHeight, 32, 0x00ff0000, 0x0000ff00, 0x000000ff, 0xff000000);
    setTexture();
    SDL_Rect rect;
    with(rect){
      x = 0; y =0;
      w = drawWidth; h = drawHeight;
    }
    this.drawRect = rect;
    this.texRect = rect;
  }
  this(int x, int y, Character chara){
    this(chara);
    scroll(x, y);
    return;
  }
  this(Character chara, int[] mapData_){
    this(chara);
    mapData/*[]*/ = mapData_;
    updateFlag = true;
  }
  ~this(){
    bgScreen.SDL_FreeSurface;
  }

  bool updateFlag;
  //functions
  override void draw(){
    //xAnim.animation;
    //yAnim.animation;
    /*if (xAnim.isStarted  || yAnim.isStarted){
        updateFlag = true;
    }*/
    //toriaezu
    if(updateFlag){
        setTexture();
        updateFlag = false;
    }
    super.draw();
    return;
  }

  alias scroll = move;
  override void move(int x, int y){
    bg.x += x; bg.y += y;
    posX = bg.x; posY = bg.y;
  }

  void scroll(int x, int y, int frame){
      //xAnim.setAnimation(x, frame);
      //yAnim.setAnimation(y, frame);
  }
  @property{
    override int posX(){ return bg.x; }
    override int posY(){ return bg.y; }
    override void posX(int n){
      bg.x = n;
      auto rectD = this.drawRect, rectT = this.texRect;
      if(n < 0){
        rectD.x = -n; rectD.w = drawWidth + n;
        rectT.x = 0;  rectT.w = drawWidth + n;
      }else if(chipSize * sizeWidth - n < drawWidth){
        rectD.x = 0; rectD.w = chipSize * sizeWidth - n;
        rectT.x = n; rectT.w = chipSize * sizeWidth - n;
      }else{
        rectD.x = 0; rectD.w = drawWidth;
        rectT.x = n; rectD.w = drawWidth;
      }
      drawRect = rectD; texRect = rectT;
    }
    override void posY(int n){
      bg.y = n;
      auto rectD = this.drawRect, rectT = this.texRect;
      if(n < 0){
        rectD.y = -n; rectD.h = drawHeight + n;
        rectT.y = 0;  rectT.h = drawHeight + n;
      }else if(chipSize * sizeHeight - n < drawHeight){
        rectD.y = 0; rectD.h = chipSize * sizeHeight - n;
        rectT.y = n; rectT.h = chipSize * sizeHeight - n;
      }else{
        rectD.y = 0; rectD.h = drawHeight;
        rectT.y = n; rectD.h = drawHeight;
      }
      drawRect = rectD; texRect = rectT;
    }
  }

  void set(int x, int y, int chip)
  {
      mapData[x * sizeHeight + y] = chip;
      //ha??????????
      //setTexture();
      updateFlag = true;
  }

  int get(int x, int y)
  {
      return mapData[x * sizeHeight + y];
  }

  auto rawMapData()
  {
      return mapData;
  }
  void rawMapData(int[] map)
  {
      mapData = map;
      updateFlag = true;
  }
private:
  void setTexture(){
      SDL_Rect aw;
      aw.w = sizeWidth * chipSize;
      aw.h = sizeHeight * chipSize;
     bgScreen.SDL_FillRect(&aw, bgScreen.format.SDL_MapRGBA(0, 0, 0, 0));
    //転送
    SDL_Rect rectS, rectD;//source, destnation
    with(rectD){
      x = 0; y = 0;
      w = chipSize; h = chipSize;
    }
    for(int x = 0; x < sizeWidth; x++){
      for(int y = 0; y < sizeHeight; y++){
        rectS = character.get(mapData[x * sizeHeight + y]);
        rectD.x = x * chipSize; rectD.y = y * chipSize;
        SDL_BlitSurface(character.surface, &rectS, bgScreen, &rectD);
      }
    }
    super.surface = bgScreen;
  }
}
