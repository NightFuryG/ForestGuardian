//Background class that loads in all layers for parallax
public class Background {

  final String PNG = ".png";
  final int CAMERA = displayWidth/38;
  final int ANCHOR = width/72;

  final int BASE_MULTIPLIER = 2;
  final int CAMERA_MULTIPLIER = 5;


  int startX = 0;
  int startY = 0;
  int resize = height + height/4;
  int layerTotal;
  String path;

  boolean reset;

  ArrayList<Layer> layers;

  //Pass in background path and number of layers
  Background(String path, int layerTotal) {
    this.path = path;
    this.layerTotal = layerTotal;
    this.layers = new ArrayList<Layer>();
    initialiseLayers();
    resizeLayers();
    this.reset = true;
  }

  //add all layers into the ArrayList of layers
  void initialiseLayers() {
    for(int i = 0; i < layerTotal; i ++) {
      layers.add(new Layer(path + i + PNG, startX, startY, i*2));
    }
  }

  //transition speed of layers set to default
  void resetTransitionSpeed() {
    if(!reset) {
      for(int i = 0; i < layerTotal; i++) {
          layers.get(i).transition = i*BASE_MULTIPLIER;
      }
      reset = true;
    }
  }

  //increase the transition speed for camera change
  void cameraTransitionSpeed() {
    int split = CAMERA/(layerTotal);
    if(reset) {
      for(int i = 0; i < layerTotal; i++) {
        layers.get(i).transition = i*split;
      }
      reset = false;
    }
  }

  void backgroundAnchorSpeed() {

  }

  //scale background so that they fit into the height of the display
  void resizeLayers() {
    for(Layer layer: layers) {
      layer.image.resize(0, height);
    }
  }

  //draw background with parallax if requested
  void draw(int direction) {
    for(Layer layer : layers) {
      layer.draw();
      if(direction > 0) {
        layer.parallaxShift(direction);
      }
    }
  }
}
