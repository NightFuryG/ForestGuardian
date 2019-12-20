//Platform class used for each individual tile
public class Platform {

  final String imgPath = "data/tileset/3.png";
  final String treePath = "Forest/PNG/tree.png";

  final int PLAT_RIGHT = 1;
  final int PLAT_LEFT = 2;

  PVector position;
  PVector velocity;
  PImage tile;
  PImage tree;
  boolean enemy;
  float transition;
  int platformWidth;
  int platformHeight;
  float startX;
  float startY;
  boolean leftEdge;
  boolean rightEdge;
  boolean last;
  boolean moving;
//
  final int RESIZE = 10;
  final int TREE_RESIZE = 2;

  Platform(PImage tile, float x, float y, float transition, boolean enemy, boolean leftEdge, boolean rightEdge) {
    this.tile = tile;
    this.startX = x;
    this.startY = y;
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    //this.tile.resize(width/RESIZE, 0);
    this.platformWidth = tile.width;
    this.platformHeight = tile.height;
    this.transition = transition;
    this.enemy = enemy;
    this.leftEdge = leftEdge;
    this.rightEdge = rightEdge;
    this.moving = false;
    this.last = false;
  }

  void loadTree() {
    tree = loadImage(treePath);
    tree.resize(width, 0);

  }

  float getEnd() {
    return (this.position.x + tree.width/2);
  }

  void resetPosition() {
    this.position.x = startX;
    this.position.y = startY;
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
    if(position.x < width*2) {
      image(tile, position.x, position.y);
      if(last) {
        image(tree, position.x - width/6, 0);
      }
    }
  }
}
