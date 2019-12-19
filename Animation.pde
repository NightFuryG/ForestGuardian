//Animation class for loading in and setting animation speed
public class Animation {

  final String EXTENSION = ".png";
  final int TOTAL_FRAMES = 5;
  final int ANIM_TIME = 100;

  ArrayList<PImage> animation;
  String filename;
  int currentFrame;
  int prevTime;
  int deltaTime;
  boolean animated;

  //Animation contains a list of files and frame sequence time
  Animation(String filename) {
    this.animation = new ArrayList<PImage>();
    this.filename = filename;
    loadAnimation();
    this.currentFrame = 0;
    this.prevTime = 0;
    this.deltaTime = ANIM_TIME;
    this.animated = false;
  }

  //load all images for an animation
  //animation is in order and files named from 0-4.png
  void loadAnimation() {
    for(int i = 0; i < TOTAL_FRAMES; i++) {
      String frameName = (filename + i + EXTENSION);
      animation.add(loadImage(frameName));
    }
  }


  //animate by playing frames in order using a stopwatch
  void draw(PVector position, int health) {
    if(millis() > prevTime + deltaTime) {
      currentFrame++;
      if(currentFrame > TOTAL_FRAMES - 1) {
        animated = true;
        currentFrame = 0;
      }
      prevTime = millis();
    }

    pushMatrix();

    image(animation.get(currentFrame), position.x, position.y );

    if(health < 50) {
    tint(255, 0, 0, 100);
    image(animation.get(currentFrame), position.x, position.y );
    tint(255,255);
    }

    popMatrix();
  }

  void drawOnce(PVector position, int health) {
    if(millis() > prevTime + deltaTime) {
      if(!animated) {
        currentFrame++;
      }
      if(currentFrame > TOTAL_FRAMES - 1) {
        animated = true;
        currentFrame--;
      }
      prevTime = millis();
    }
    pushMatrix();

    image(animation.get(currentFrame), position.x, position.y );
    tint(255,0,0,100);
    image(animation.get(currentFrame), position.x, position.y );
    tint(255,255);
    popMatrix();
  }

}
