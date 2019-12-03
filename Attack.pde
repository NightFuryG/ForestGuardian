//Attack class for projectile
public class Attack {

  PImage attackRight = loadImage("animations/guardian/wolfAttack/0.png");
  PImage attackLeft = loadImage("animations/guardian/wolfAttack/1.png");

  PImage rock = loadImage("animations/enemy/attack/rock.png");



  final int ATTACK_SPEED = width/100;
  final int ATTACK_SIZE = width/20;
  final int MAX_DISTANCE = width/10;

  PVector position;
  PVector destination;
  PVector direction;
  PVector velocity;
  PVector acceleration;
  boolean right;
  boolean enemy;
  float distance;
  float startX;
  float startY;

  //attack act as a simple projectile towards a target
  Attack(float startX, float startY, float endX, float endY, boolean right, boolean enemy) {
    this.startX = startX;
    this.startY = startY;
    this.position = new PVector(startX, startY);
    this.destination = new PVector(endX, endY);
    this.velocity = new PVector(0,0);
    this.direction = calculateDirection();
    this.acceleration = calculateAcceleration();
    this.right = right;
    this.distance = 0;
    this.enemy = enemy;
    scaleAttack();
  }

  PVector addGravity() {
    return new PVector(0, 0.3);
  }

  //calculate direction of travel using sub
  PVector calculateDirection() {
    return PVector.sub(destination, position);
  }

  //calculate acceleration of attack
  PVector calculateAcceleration() {
    PVector a = this.direction.normalize();
    if(enemy) {
      a = this.direction.mult(5);
    } else {
      a = this.direction.mult(5);
    }

    return a;
  }

  //change size of attack
  void scaleAttack() {
    attackRight.resize(ATTACK_SIZE, 0);
    attackLeft.resize(ATTACK_SIZE, 0);
    rock.resize(ATTACK_SIZE/4, 0);
  }

  //update position by adding acceleration to velocity and velocity to position
  void update(){
    acceleration = calculateAcceleration();
    if(enemy) {
      acceleration.add(addGravity());
    }
    velocity.add(acceleration);
    velocity.limit(ATTACK_SPEED);
    this.distance = dist(startX, startY, position.x, position.y);
    position.add(velocity);
  }

  //display differently depending on orientation
  void display() {
    if(!enemy) {
      if(right) {
        image(attackRight, position.x, position.y);
      } else  {
        image(attackLeft, position.x, position.y);
      }
    } else {
        image(rock, this.position.x, this.position.y);
    }
  }

  void draw(){
    update();
    display();
  }
}
