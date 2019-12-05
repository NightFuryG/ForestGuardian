//Platform class used for each individual tile
public class Platform {

  final String imgPath = "data/tileset/3.png";

  PVector position;
  PImage tile;
  int platformWidth;

  final int RESIZE = 10;

  Platform( float x, float y) {
    this.tile = loadImage(imgPath);
    this.position = new PVector(x, y);
    this.tile.resize(width/RESIZE, 0);
    this.platformWidth = tile.width;
  }

  void platformShift(int direction) {
    if (direction == 1) {
      platformRight();
    } else if (direction == 2) {
      platformLeft();
    }
  }

  void platformRight() {
    position.x -= 18;

  }

  void platformLeft() {
    position.x += 18;
  }

  void draw() {
    image(tile, position.x, position.y);
  }



}
