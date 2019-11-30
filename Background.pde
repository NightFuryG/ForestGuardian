public class Background {

  int startX = 0;
  int startY = 0;
  int resize = height + height/4;

  Layer img0 = new Layer ("background/Layer_0000_9.png", startX, startY, 20);
  Layer img1 = new Layer ("background/Layer_0001_8.png", startX, startY, 18);
  Layer img2 = new Layer ("background/Layer_0002_7.png", startX, startY, 16);
  Layer img3 = new Layer ("background/Layer_0003_6.png", startX, startY, 14);
  Layer img4 = new Layer ("background/Layer_0004_Lights.png", startX, startY, 12);
  Layer img5 = new Layer ("background/Layer_0005_5.png", startX, startY, 10);
  Layer img6 = new Layer ("background/Layer_0006_4.png", startX, startY, 8);
  Layer img7 = new Layer ("background/Layer_0007_Lights.png", startX, startY, 6);
  Layer img8 = new Layer ("background/Layer_0008_3.png", startX, startY, 4);
  Layer img9 = new Layer ("background/Layer_0009_2.png", startX, startY, 2);
  Layer img10 = new Layer ("background/Layer_0010_1.png", startX, startY, 0);

  ArrayList<Layer> layers;

  Background() {
    this.layers = new ArrayList<Layer>();
    addLayers();
    resizeLayers();
  }

  void addLayers() {
    layers.add(img10);
    layers.add(img9);
    layers.add(img8);
    layers.add(img7);
    layers.add(img6);
    layers.add(img5);
    layers.add(img4);
    layers.add(img3);
    layers.add(img2);
    layers.add(img1);
    layers.add(img0);
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
