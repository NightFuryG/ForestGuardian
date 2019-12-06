//Platform class used for each individual tile
public class Platform {

  final String imgPath = "data/tileset/3.png";

  final int PLAT_RIGHT = 1;
  final int PLAT_LEFT = 2;

  PVector position;
  PImage tile;
  float transition;
  int platformWidth;

  final int RESIZE = 10;

  Platform( float x, float y, float transition) {
    this.tile = loadImage(imgPath);
    this.position = new PVector(x, y);
    this.tile.resize(width/RESIZE, 0);
    this.platformWidth = tile.width;
    this.transition = transition;
  }

  void platformShift(int direction) {
    if (direction == PLAT_RIGHT) {
      platformRight();
    } else if (direction == PLAT_LEFT) {
      platformLeft();
    }
  }


  void platformRight() {
    position.x -= transition;

  }

  void platformLeft() {
    position.x += transition;
  }

  void draw() {
    image(tile, position.x, position.y);
  }



}
