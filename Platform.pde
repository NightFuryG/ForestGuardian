//Platform class used for each individual tile
public class Platform {

  final String imgPath = "data/tileset/3.png";

  final int PLAT_RIGHT = 1;
  final int PLAT_LEFT = 2;

  PVector position;
  PVector velocity;
  PImage tile;
  boolean enemy;
  float transition;
  int platformWidth;
  int platformHeight;
  boolean leftEdge;
  boolean rightEdge;
  boolean last;
  boolean moving;
//
  final int RESIZE = 10;

  Platform( float x, float y, float transition, boolean enemy, boolean leftEdge, boolean rightEdge) {
    this.tile = loadImage(imgPath);
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.tile.resize(width/RESIZE, 0);
    this.platformWidth = tile.width;
    this.platformHeight = tile.height;
    this.transition = transition;
    this.enemy = enemy;
    this.leftEdge = leftEdge;
    this.rightEdge = rightEdge;
    this.moving = false;
    this.last = false;
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
