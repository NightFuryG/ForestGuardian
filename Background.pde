public class Background {

  final String PNG = ".png";
  final int CAMERA = 25 ;
  final int ONE_LAYER = 20;

  int startX = 0;
  int startY = 0;
  int resize = height + height/4;
  int layerTotal;
  String path;

  boolean reset;


  ArrayList<Layer> layers;

  Background(String path, int layerTotal) {
    this.path = path;
    this.layerTotal = layerTotal;
    this.layers = new ArrayList<Layer>();
    initialiseLayers();
    resizeLayers();
    this.reset = true;
  }

  void initialiseLayers() {
    for(int i = 0; i < layerTotal; i ++) {
      if(layerTotal == 1) {
        System.out.println("HELLO");
        layers.add(new Layer(path + i + PNG, startX, startY, 20));
      } else {
        layers.add(new Layer(path + i + PNG, startX, startY, i*2));
      }

    }
  }

  void resetTransitionSpeed() {
    if(!reset) {
      for(int i = 0; i < layerTotal; i++) {
        if(layerTotal == 1) {
          layers.get(i).transition = 20;
        } else {
          layers.get(i).transition = i*2;
        }

      }
      reset = true;
    }

  }

  void cameraTransitionSpeed() {
    if(reset) {
      for(int i = 0; i < layerTotal; i++) {
        layers.get(i).transition = CAMERA;
      }
      reset = false;
    }
  }

  void resizeLayers() {

    for(Layer layer: layers) {
      layer.image.resize(0, height);
    }
  }

  void draw(int direction) {

    for(Layer layer : layers) {
      layer.draw();
      if(direction > 0) {
        layer.parallaxShift(direction);
      }
    }
  }
}
