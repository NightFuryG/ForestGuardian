public class Background {

  final String PNG = ".png";
  final String PATH = "background/";
  final int CAMERA = 25 ;

  int startX = 0;
  int startY = 0;
  int resize = height + height/4;
  int layerTotal;

  boolean reset;


  ArrayList<Layer> layers;

  Background(int layerTotal) {
    this.layerTotal = layerTotal;
    this.layers = new ArrayList<Layer>();
    initialiseLayers();
    resizeLayers();
    this.reset = true;
  }

  void initialiseLayers() {
    for(int i = 0; i < layerTotal; i ++) {
      layers.add(new Layer(PATH + i + PNG, startX, startY, i*2));
    }
  }

  void resetTransitionSpeed() {
    if(!reset) {
      for(int i = 0; i < layerTotal; i++) {
        layers.get(i).transition = i*2;
      }
      System.out.println("Normal");
      reset = true;
    }

  }

  void cameraTransitionSpeed() {
    if(reset) {
      for(int i = 0; i < layerTotal; i++) {
        layers.get(i).transition = CAMERA;
      }
      System.out.println("Fast");
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
