class Attack {

  PImage attackRight = loadImage("animations/guardian/wolfAttack/0.png");
  PImage attackLeft = loadImage("animations/guardian/wolfAttack/1.png");


  final int ATTACK_SPEED = width/100;
  final int ATTACK_SIZE = width/20;
  final int MAX_DISTANCE = width/10;

  PVector position;
  PVector destination;
  PVector direction;
  PVector velocity;
  PVector acceleration;
  boolean right;
  float distance;
  float startX;
  float startY;

  //Bullet act as a simple projectile towards a target
  Attack(float startX, float startY, float endX, float endY, boolean right) {
    this.startX = startX;
    this.startY = startY;
    this.position = new PVector(startX, startY);
    this.destination = new PVector(endX, endY);
    this.velocity = new PVector(0,0);
    this.direction = calculateDirection();
    this.acceleration = calculateAcceleration();
    this.right = right;
    this.distance = 0;
    scaleAttack();
  }

  //calculate direction of travel
  PVector calculateDirection() {
    return PVector.sub(destination, position);
  }

  //calculate acceleration
  PVector calculateAcceleration() {
    PVector a = this.direction.normalize();
    a = this.direction.mult(2);
    return a;
  }

  void scaleAttack() {
    attackRight.resize(ATTACK_SIZE, 0);
    attackLeft.resize(ATTACK_SIZE, 0);
  }

  void update(){
    velocity.add(acceleration);
    velocity.limit(ATTACK_SPEED);
    position.add(velocity);
    distance = dist(startX, startY, position.x, position.y);
  }

  void display() {
    if(right) {
      image(attackRight, position.x, position.y);
    } else if (!right) {
      image(attackLeft, position.x, position.y);
    }
  }

  void draw(){
    update();
    display();
  }
}
