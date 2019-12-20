class  PlatformGenerator {

  final int PLATFORM_NUM = 200;

  final int BLOCK_ONE = 1;
  final int BLOCK_TWO = 2;
  final int BLOCK_FIVE = 5;
  final int BLOCK_MAX = 10;
  final float PERCENT_FORTY = 0.4;
  final float PERCENT_SEVENTY = 0.7;
  final float PERCENT_NINETY = 0.9;
  final float PERCENT_TEN = 0.1;

  final int CAMERA_SPEED = 34;
  final int ANCHOR_SPEED = 85;
  final int BASE_SPEED = 80;

  final int START = 8;

  ArrayList<Platform> platforms;

  int numberOfPlatforms;
  int newPlatformHeight;
  int newPlatformWidth;

  int cameraType;

  PlatformGenerator(int level) {
   this.platforms  = new ArrayList<Platform>();
    this.numberOfPlatforms = level * PLATFORM_NUM;
    generatePlatforms();
    this.cameraType = BASE_SPEED;
    setLast();
  }

  void generatePlatforms() {


    for(int i = 0; i < START; i++) {
      if(i == 0) {
        platforms.add(new Platform(0, height - height/10, width/BASE_SPEED, false, true, false));
        this.newPlatformWidth = platforms.get(0).platformWidth;
        this.newPlatformHeight = platforms.get(0).platformHeight*2;
      }
      else if(i == START - 1) {
        platforms.add(new Platform(i*newPlatformWidth, height - height/10, width/BASE_SPEED, false, false, true));
      }
      else {
        platforms.add(new Platform(i*newPlatformWidth, height - height/10, width/BASE_SPEED, false, false, false));
      }
    }



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
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, true, false, true));
        } else if(j == 0 && numPlat == 1) {
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false, true, true));
        } else if (j == 0) {
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false, true, false));
        } else if(j == numPlat - 1 && numPlat == BLOCK_TWO) {
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false, false, true));
        } else if(j == numPlat - 1) {
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, true, false, true));
        } else if(numPlat > BLOCK_TWO){
          float random = random(0,1);
          if(random > 0.9) {
            platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, true, false, false));
          } else {
            platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false, false, false));
          }
        }
      }
    }
  }

  // void setMoving() {
  //   for(Platform platform : platforms) {
  //     if(platform.leftEdge && platform.rightEdge) {
  //
  //     }
  //   }
  //
  // }

  void setLast(){
    platforms.get(platforms.size()-1).last = true;
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
