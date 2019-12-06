class  PlatformGenerator {

  final int PLATFORM_NUM = 10;
  final int BASE_SPEED = 18;
  final int CAMERA_SPEED = 25;

  ArrayList<Platform> platforms;

  int numberOfPlatforms;
  boolean reset;

  PlatformGenerator() {
   this.platforms  = new ArrayList<Platform>();
    this.numberOfPlatforms = PLATFORM_NUM;
    generatePlatforms();
    this.reset = true;
  }

  void generatePlatforms() {

    platforms.add(new Platform(width, height - height/5, BASE_SPEED));

    for(int i = 0; i < PLATFORM_NUM; i++) {
      float position = platforms.get(i).position.x + platforms.get(i).platformWidth;
      float sky = random(0,height);

      platforms.add(new Platform(position, sky, BASE_SPEED));
    }
  }

  void resetTransitionSpeed() {
    if(!reset) {
      for(Platform platform : platforms) {
        platform.transition = BASE_SPEED;
      }
      reset = true;
    }
  }

  void cameraTransitionSpeed() {
    if(reset) {
      for(Platform platform : platforms) {
        platform.transition = CAMERA_SPEED;
      }
      reset = false;
    }
  }


  void draw(int direction) {
    for(Platform platform : platforms) {
      platform.draw();
      if(direction > 0) {
        platform.platformShift(direction);
      }
    }
  }
}
