//Attack class for projectile
public class Attack {

  PImage attackRight = loadImage("animations/guardian/wolfAttack/0.png");
  PImage attackLeft = loadImage("animations/guardian/wolfAttack/1.png");

  PImage rock = loadImage("animations/enemy/attack/rock.png");

  PImage arrowRight = loadImage("animations/enemy/attack/arrowRight.png");
  PImage arrowLeft = loadImage("animations/enemy/attack/arrowLeft.png");

  final int ATTACK_SPEED = width/100;
  final int ATTACK_SIZE = width/20;
  final int MAX_DISTANCE = width/10;
  final int GUARDIAN_WOLF_ATTACK = 0;
  final int ENEMY_ARROW_ATTACK = 1;
  final int ENEMY_ROCK_ATTACK = 2;

  PVector position;
  PVector destination;
  PVector direction;
  PVector velocity;
  PVector acceleration;
  boolean right;
  int attackType;
  float distance;
  float startX;
  float startY;

  //attack act as a simple projectile towards a target
  Attack(float startX, float startY, float endX, float endY, boolean right, int attackType) {
    this.startX = startX;
    this.startY = startY;
    this.position = new PVector(startX, startY);
    this.destination = new PVector(endX, endY);
    this.velocity = new PVector(0,0);
    this.direction = calculateDirection();
    this.acceleration = calculateAcceleration();
    this.right = right;
    this.distance = 0;
    this.attackType = attackType;
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
      a = this.direction.mult(5);


    return a;
  }

  //change size of attack
  void scaleAttack() {
    attackRight.resize(ATTACK_SIZE, 0);
    attackLeft.resize(ATTACK_SIZE, 0);
    rock.resize(ATTACK_SIZE/4, 0);
    arrowLeft.resize(ATTACK_SIZE/2, 0);
    arrowRight.resize(ATTACK_SIZE/2, 0);
  }

  //update position by adding acceleration to velocity and velocity to position
  void update(){
    acceleration = calculateAcceleration();
    if(attackType == ENEMY_ROCK_ATTACK) {
      acceleration.add(addGravity());
    }
    velocity.add(acceleration);
    velocity.limit(ATTACK_SPEED);
    this.distance = dist(startX, startY, position.x, position.y);
    position.add(velocity);
  }

  //display differently depending on orientation
  void display() {
    switch(this.attackType) {
      case GUARDIAN_WOLF_ATTACK:
        if(right) {
          image(attackRight, this.position.x, this.position.y);
        } else  {
          image(attackLeft, this.position.x, this.position.y);
        }
        break;
      case ENEMY_ARROW_ATTACK:
        if(right) {
          image(arrowRight, this.position.x, this.position.y);
        } else {
          image(arrowLeft, this.position.x, this.position.y);
        }
        break;
      case ENEMY_ROCK_ATTACK:
        image(rock, this.position.x, this.position.y);
        break;
      default:
          break;
    }
}

  void draw(){
    update();
    display();
  }
}
