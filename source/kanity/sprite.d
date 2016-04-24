module kanity.sprite;

import derelict.sdl2.sdl;
import kanity.object;
import kanity.character;
import kanity.animation;
import std.experimental.logger;

class Sprite : DrawableObject{
private:
    Character character_;
    uint charaNum_;
    string charaString_;
    AnimationData!int xAnim;
    AnimationData!int yAnim;
    AnimationData!float scaleAnim;

    //AnimationData!int characterAnim;
    int characterNumber;

  public:
    this(Character chara, int x, int y, uint charaNum){
      super();
      character_ = chara;
      this.surface = character_.surface;
      this.posX = x; this.posY = y;
      this.character = charaNum;

      xAnim.setter = &posX; xAnim.getter = &posX;
      yAnim.setter = &posY; yAnim.getter = &posY;
      scaleAnim.setter = &scale; scaleAnim.getter = &scale;
    }
    bool isXAnimationStarted()
    {
        return xAnim.isStarted;
    }
    bool isYAnimationStarted()
    {
        return yAnim.isStarted;
    }
    void move(int ax, int ay, int frame){
        xAnim.setAnimation(ax + posX, frame);
        yAnim.setAnimation(ay + posY, frame);
    }
    void scaleAnimation(float as, int frame){
      scaleAnim.setAnimation(as + scale, frame);
    }

    @property{
      void character(uint a){
        this.texRect = character_.get(a);
        auto rect = this.drawRect;
        rect.w = this.texRect.w; rect.h = this.texRect.h;
        this.drawRect = rect;
      }
      void character(string s){
        this.texRect = character_.get(s);
        auto rect = this.drawRect;
        rect.w = this.texRect.w; rect.h = this.texRect.h;
        this.drawRect = rect;
      }
    }

    public override void draw(){
        super.draw();
        animation();
    }

    private void animation()
    {
        xAnim.animation();
        yAnim.animation();
        scaleAnim.animation();
        //characterAnim.animation();
    }
}
