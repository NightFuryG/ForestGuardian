class  PlatformGenerator {

  final int PLATFORM_NUM = 100;

  final int BLOCK_ONE = 1;
  final int BLOCK_TWO = 2;
  final int BLOCK_FIVE = 5;
  final int BLOCK_MAX = 15;
  final float PERCENT_FORTY = 0.4;
  final float PERCENT_SEVENTY = 0.7;
  final float PERCENT_NINETY = 0.9;
  final float PERCENT_TEN = 0.1;

  final int CAMERA_SPEED = 34;
  final int ANCHOR_SPEED = 85;
  final int BASE_SPEED = 80;

  ArrayList<Platform> platforms;

  int numberOfPlatforms;
  int newPlatformHeight;
  int newPlatformWidth;

  int cameraType;

  PlatformGenerator() {
   this.platforms  = new ArrayList<Platform>();
    this.numberOfPlatforms = PLATFORM_NUM;
    generatePlatforms();
    this.cameraType = BASE_SPEED;
  }

  void generatePlatforms() {

    platforms.add(new Platform(width, height - height/5, width/BASE_SPEED, true));
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

      if(randomPlatforms <= PERCENT_FORTY) {
          numPlat = BLOCK_ONE;
      } else if (randomPlatforms > PERCENT_FORTY && randomPlatforms <= PERCENT_SEVENTY) {
          numPlat = BLOCK_TWO;
      } else if (randomPlatforms > PERCENT_SEVENTY  && randomPlatforms <= PERCENT_NINETY) {
          numPlat = BLOCK_FIVE;
      } else {
        numPlat = BLOCK_MAX;
      }

      for(int j = 0; j < numPlat; j++) {
        if (numPlat == BLOCK_MAX && j == numPlat - 1) {
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, true));
        } else {
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false));
        }
      }
    }
  }

  void anchorSpeed() {
    if(cameraType == BASE_SPEED || cameraType == CAMERA_SPEED) {
      for(Platform platform : platforms) {
        platform.transition = width/ANCHOR_SPEED;
      }
    cameraType = ANCHOR_SPEED;
    }
  }

  void resetTransitionSpeed() {
    if(cameraType == ANCHOR_SPEED || cameraType == CAMERA_SPEED) {
      for(Platform platform : platforms) {
        platform.transition = width/BASE_SPEED;
      }
    cameraType = BASE_SPEED;
    }
  }

  void cameraTransitionSpeed() {
    if(cameraType == ANCHOR_SPEED || cameraType == BASE_SPEED) {
      for(Platform platform : platforms) {
        platform.transition = width/CAMERA_SPEED;
      }
      cameraType = CAMERA_SPEED;
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
