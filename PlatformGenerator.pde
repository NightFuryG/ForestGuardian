class  PlatformGenerator {

  final int PLATFORM_NUM = 3;
  final int BASE_SPEED = 20;
  final int CAMERA_SPEED = width/38;
  final int ANCHOR_SPEED = width/72;

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

    platforms.add(new Platform(width, height - height/7, BASE_SPEED));

    for(int i = 0; i < PLATFORM_NUM; i++) {
      float positionX = platforms.get(i).position.x + platforms.get(i).platformWidth * 2;
      float positionY = platforms.get(i).position.y - platforms.get(i).platformHeight;

      platforms.add(new Platform(positionX, positionY, BASE_SPEED));

    }
  }

  void differentSpeed() {
    if(reset) {
      for(Platform platform : platforms) {
        platform.transition = ANCHOR_SPEED;
      }
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
