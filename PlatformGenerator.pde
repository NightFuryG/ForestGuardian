class  PlatformGenerator {

  final int PLATFORM_NUM = 50;
  final int BASE_SPEED = 20;
  final int CAMERA_SPEED = width/38;
  final int ANCHOR_SPEED = width/85;

  ArrayList<Platform> platforms;

  int numberOfPlatforms;
  int newPlatformHeight;
  int newPlatformWidth;
  boolean reset;

  PlatformGenerator() {
   this.platforms  = new ArrayList<Platform>();
    this.numberOfPlatforms = PLATFORM_NUM;
    generatePlatforms();
    this.reset = true;
  }

  void generatePlatforms() {

    platforms.add(new Platform(width, height - height/7, BASE_SPEED));
    this.newPlatformWidth = platforms.get(0).platformWidth;
    this.newPlatformHeight = platforms.get(0).platformHeight*2;


    int last;
    float ground = height - height/6.85;

    for(int i = 0; i < PLATFORM_NUM; i++) {

      last = platforms.size() - 1;

      float randomPlatforms = random(0, 1);
      float randomPlatformHeight = random(platforms.get(last).position.y - newPlatformHeight, ground);
      float positionX = platforms.get(last).position.x + 2*newPlatformWidth;

      int numPlat = 0;

      if(randomPlatforms <= 0.4) {
          numPlat = 1;
      } else if (randomPlatforms > 0.4 && randomPlatforms <= 0.7) {
          numPlat = 2;
      } else if (randomPlatforms > 0.7 && randomPlatforms <= 0.95) {
          numPlat = 5;
      } else {
        numPlat = 15;
      }

      for(int j = 0; j < numPlat; j++)
        platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, BASE_SPEED));
    }
  }

  void differentSpeed() {
    if(reset) {
      for(Platform platform : platforms) {
        platform.transition = ANCHOR_SPEED;
        System.out.println(ANCHOR_SPEED);
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
