public class Platform {

  PVector position;
  PImage tile;

  final int RESIZE = 6;

  Platform(String path, float x, float y) {
    this.tile = loadImage(path);
    this.position = new PVector(x, y);
    this.tile.resize(width/RESIZE, 0);

  }

  void draw() {
    image(tile, position.x, position.y);
  }



}
