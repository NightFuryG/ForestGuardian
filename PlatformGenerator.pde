class  PlatformGenerator {

  final int PLATFORM_NUM = 50;

  ArrayList<Platform> platforms;

  int numberOfPlatforms;

  PlatformGenerator() {
   this.platforms  = new ArrayList<Platform>();
    this.numberOfPlatforms = PLATFORM_NUM;
    generatePlatforms();
  }

  void generatePlatforms() {

    platforms.add(new Platform(width, height - height/5));

    for(int i = 0; i < PLATFORM_NUM; i) {
      float position = platforms.get(i).position.x + platforms.get(i).platformWidth;
      float sky = random(0,height);
      System.out.println(sky);

      platforms.add(new Platform(position, sky));
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
