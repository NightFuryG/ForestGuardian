class  PlatformGenerator {

  final String imgPath = "data/tileset/3.png";
  final int RESIZE = 10;

  final int PLATFORM_NUM = 10;

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
  PImage platform;

  int numberOfPlatforms;
  int newPlatformHeight;
  int newPlatformWidth;
  float endX;
  int cameraType;

  PlatformGenerator(int level) {
   this.platforms  = new ArrayList<Platform>();
   initPlatform();
    this.numberOfPlatforms = level * PLATFORM_NUM;
    generatePlatforms();
    this.cameraType = BASE_SPEED;
    setLast();
  }

  void initPlatform() {
    this.platform = loadImage(imgPath);
    this.platform.resize(width/RESIZE, 0);
  }

  void generatePlatforms() {


    for(int i = 0; i < START; i++) {
      if(i == 0) {
        platforms.add(new Platform(platform, 0, height - height/10, width/BASE_SPEED, false, true, false));
        this.newPlatformWidth = platforms.get(0).platformWidth;
        this.newPlatformHeight = platforms.get(0).platformHeight*2;
      }
      else if(i == START - 1) {
        platforms.add(new Platform(platform, i*newPlatformWidth, height - height/10, width/BASE_SPEED, false, false, true));
      }
      else {
        platforms.add(new Platform(platform, i*newPlatformWidth, height - height/10, width/BASE_SPEED, false, false, false));
      }
    }



    int last;
    float ground = height - height/6.85;

    for(int i = 0; i < numberOfPlatforms; i++) {

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
          platforms.add(new Platform(platform,positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, true, false, true));
        } else if(j == 0 && numPlat == 1) {
          platforms.add(new Platform(platform,positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false, true, true));
        } else if (j == 0) {
          platforms.add(new Platform(platform,positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false, true, false));
        } else if(j == numPlat - 1 && numPlat == BLOCK_TWO) {
          platforms.add(new Platform(platform,positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false, false, true));
        } else if(j == numPlat - 1) {
          platforms.add(new Platform(platform,positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, true, false, true));
        } else if(numPlat > BLOCK_TWO){
          float random = random(0,1);
          if(random > 0.75) {
            platforms.add(new Platform(platform,positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, true, false, false));
          } else {
            platforms.add(new Platform(platform,positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false, false, false));
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
    Platform endPlatform = platforms.get(platforms.size()-1);
    endPlatform.last = true;
    endPlatform.loadTree();
    this.endX = endPlatform.getEnd();
  }

  float getEnd() {
    Platform endPlatform = platforms.get(platforms.size()-1);
    return endPlatform.getEnd();
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

  void resetPlatformGenerator() {
    for(Platform platform : platforms) {
      platform.resetPosition();
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
