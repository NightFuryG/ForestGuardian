public class Background {

  final String PNG = ".png";
  final String PATH = "background/";

  int startX = 0;
  int startY = 0;
  int resize = height + height/4;
  int layerTotal;


  ArrayList<Layer> layers;

  Background(int layerTotal) {
    this.layerTotal = layerTotal;
    this.layers = new ArrayList<Layer>();
    initialiseLayers();
    resizeLayers();
  }

  void initialiseLayers() {
    for(int i = 0; i < layerTotal; i ++) {
      layers.add(new Layer(PATH + i + PNG, startX, startY, i*2));
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
