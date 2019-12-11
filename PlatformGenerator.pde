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

    System.out.println("hello1");

    int count = 0;

    System.out.println("hello2");
    platforms.add(new Platform(width, height - height/7, BASE_SPEED));

    System.out.println("hello3");
    this.newPlatformWidth = platforms.get(0).platformWidth;

    System.out.println("hello4");
    this.newPlatformHeight = platforms.get(0).platformHeight*2;

    System.out.println("hello5");
    float ground = height - height/6.85;

    System.out.println("hello6");
    for(int i = 0; i < PLATFORM_NUM; i++) {

    System.out.println("hello7");
      float randomPlatforms = random(1, 20);
    System.out.println("hello8");
      float randomPlatformHeight = random(platforms.get(i).position.y - newPlatformHeight, ground);
    System.out.println("hello9");
      float positionX = platforms.get(i).position.x + newPlatformWidth;
    System.out.println("hello10");

      for(int j = 0; j < randomPlatforms; j++)
        platforms.add(new Platform(positionX, randomPlatformHeight, BASE_SPEED));

    System.out.println("hello11");
        count++;
        System.out.println(count);
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
