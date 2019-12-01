import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ForestGuardian extends PApplet {

Background background;
Background backgroundtwo;
Entity guardian;
Entity pet;

final int GUARDIAN_WIDTH = 20;
final int ATTACK_WIDTH = 40;
final int GUARDIAN_HEIGHT = 20;
final int ATTACK_DISTANCE = 40;
final float GROUND = height;
final int BAR_WIDTH = 20;
final int BAR_LEFT = 150;
final int BAR_HEIGHT = 100;
final int BAR_ABOVE = 80;
final int LINE_ONE = 30;
final int LINE_TWO = 100;
final int LINE_HEIGHT = 100;
final int LINE_SUCCESS = 200;
final int LOWER_SUCCESS = 75;
final int UPPER_SUCCESS = 85;
final int PET_MAX_LIFE = 10000;
final int SUMMON_INCREASE = 3;

final int CAMERA_SPEED = 50;

final int PARALLAX_RIGHT = 1;
final int PARALLAX_LEFT = 2;
final int PARALLAX_NONE = 0;

final int CAMERA_ANCHOR = 10;

final int BACKGROUND_ONE_LAYERS = 11;
final int BACKGROUND_TWO_LAYERS = 1;

final int PET_COOLDOWN_TIME = 3000;

final String GUARDIAN_PATH = "animations/guardian/";
final String WOLF_PATH = "animations/pet/1/";
final String ENEMY_ONE_PATH = "animations/enemy/1/";
final String BACKGROUND_ONE_PATH = "background/0/";
final String BACKGROUND_TWO_PATH = "background/1/";

final String TILE_ZERO =  "tileset/0.png";
final String TILE_ONE =  "tileset/1png";
final String TILE_TWO =  "tileset/2.png";
final String TILE_THREE =  "tileset/3.png";
final String TILE_FOUR =  "tileset/4.png";
final String TILE_FIVE =  "tileset/5.png";
final String TILE_SIX =  "tileset/6.png";
final String TILE_SEVEN =  "tileset/7.png";

float ground;
final float GROUND_PROP = 6.85f;

float tileGround;
final float GROUND_TILE = 12;

boolean w, a, s, d, j;
boolean petAlive;
boolean summon;
boolean petCooldown;
boolean attacking;


int parallax;
int summonCount;
int petTimer;
int petCooldownTimer;

Platform platform;


ArrayList<Attack> attacks;
ArrayList<Enemy> enemies;

Enemy enemy;

public void setup() {
  
  w = a = s = d = j = false;
  petAlive = false;
  petCooldown = false;
  summon = false;
  attacking = false;
  parallax = 0;
  summonCount = 0;
  petTimer = 0;
  petCooldownTimer = 0;

  ground = height - height/GROUND_PROP;
  tileGround = height - height/GROUND_TILE;


  background = new Background(BACKGROUND_ONE_PATH, BACKGROUND_ONE_LAYERS);
  guardian = new Guardian(GUARDIAN_PATH, width/4, ground);
  attacks = new ArrayList<Attack>();
  enemies = new ArrayList<Enemy>();

  enemy = new Enemy(ENEMY_ONE_PATH, width, ground);
  enemies.add(enemy);

  platform = new Platform(TILE_THREE, 0, tileGround);


}

public void draw() {
  imageMode(CORNER);
  background(255);
  checkAttacking();
  if(!attacking) {
    drawParallaxBackround();
  } else {
    background.draw(PARALLAX_NONE);
  }

  playerMove();
  if(petAlive) {
    pet.draw();
  }
  unsummonPet();
  guardian.draw();
  attack();
  drawEnemies();
  enemyAttack();
  bar();
  checkCooldowns();
  detectAttackCollision();
  //platform.draw();
}

public void checkAttacking() {
  for(Enemy enemy : enemies) {
    if(!enemy.idle) {
      attacking = true;
    }
  }

  if(enemies.size() == 0) {
    attacking = false;
  }
}

public void updatePet() {
  pet.position.x = guardian.position.x;
  pet.position.y = guardian.position.y;
}

/*
  Pet Summoning Bar
  When holding 1 to summon - stop the bar in the two lines
  if target missed wolf cool down activated
*/
public void bar() {
  if(!petAlive && summon) {
    fill(255,255,255, 100);
    rect(guardian.position.x - width/BAR_LEFT, guardian.position.y - width/BAR_ABOVE, width/BAR_WIDTH, width/BAR_HEIGHT);
    fill(255 -  2 * summonCount,2 * summonCount, 0);
    if(summonCount < width/BAR_WIDTH) {
      rect(guardian.position.x - width/BAR_LEFT, guardian.position.y - width/BAR_ABOVE, summonCount, width/BAR_HEIGHT);
    }
    fill(0,0,0,0);
    strokeWeight(3);
    rect(guardian.position.x + width/LINE_ONE, guardian.position.y - width/BAR_ABOVE, width/LINE_SUCCESS, width/BAR_HEIGHT);
  }
}

public void unsummonPet() {
  if(millis() > petTimer +  PET_MAX_LIFE) {
    petAlive = false;
    pet = null;
    petTimer = millis();
  }
}

public void checkCooldowns() {
  if(millis() > petCooldownTimer + PET_COOLDOWN_TIME) {
    petCooldown = true;
    petCooldownTimer = millis();
  }
}

public void summonPet() {
  petAlive = true;
  pet = new Pet(WOLF_PATH, guardian.position.x, guardian.position.y);
  petTimer = millis();
}

public void drawParallaxBackround() {
  if(guardian.anchorRight && guardian.idle) {
      background.cameraTransitionSpeed();
      parallax = PARALLAX_LEFT;
      guardian.velocity.x = CAMERA_SPEED;
      positionEnemies(CAMERA_SPEED);
  } else if (guardian.anchorLeft && guardian.idle) {
      background.cameraTransitionSpeed();
      parallax = PARALLAX_RIGHT;
      guardian.velocity.x = -CAMERA_SPEED;
      positionEnemies(-CAMERA_SPEED);
    } else if(guardian.right && guardian.anchorRight
      && !guardian.idle) {
        if(guardian.velocity.x == 0) {
          background.resetTransitionSpeed();
        } else {
          background.cameraTransitionSpeed();
        }
        positionEnemies(-20);
        parallax = PARALLAX_RIGHT;
  } else if (!guardian.right && guardian.anchorLeft
      && !guardian.idle){
        if(guardian.velocity.x == 0) {
          background.resetTransitionSpeed();
        } else {
          background.cameraTransitionSpeed();
        }
        positionEnemies(20);
      parallax = PARALLAX_LEFT;
  } else {
      parallax = PARALLAX_NONE;
  }
  background.draw(parallax);
}

public void positionEnemies(int velocity) {
  for(Enemy enemy : enemies) {
    enemy.velocity.x = velocity;
  }
}

// movement
public void keyPressed() {
    if(key == 'w') {
      w = true;
    } else if (key == 's') {
      s = true;
    } else if (key == 'd') {
      d = true;
    } else if (key == 'a') {
      a = true;
    } else if(key == ' ') {
      j = true;
    } else if (key == '1') {
      if(petCooldown)
        summon = true;
        summonCount += SUMMON_INCREASE;
    }
}

// movement
public void keyReleased() {
  if(key == 'w') {
    w = false;
  } else if (key == 's') {
    s = false;
  } else if (key == 'd') {
    d = false;
  } else if (key == 'a') {
    a = false;
  } else if (key == ' ') {
    j = false;
  } else if (key == '1') {

    if(summonCount > LOWER_SUCCESS && summonCount < UPPER_SUCCESS ) {
      summonPet();
    } else {
      petCooldown = false;
    }
    summonCount = 0;
    summon = false;
    petCooldownTimer = millis();
  }
}


// movement
public void playerMove() {
  if(w) {
    guardian.move(1, attacking);
    if(petAlive)
      pet.move(1, attacking);
  }
  if(s) {
    guardian.move(2, attacking);
    if(petAlive)
      pet.move(2, attacking);
  }
  if(d) {
    guardian.move(3, attacking);
    if(petAlive)
      pet.move(3, attacking);
  }
  if(a) {
    guardian.move(4, attacking);
    if(petAlive)
      pet.move(4, attacking);
  }
  if(!w && !s && !d && !a) {
    guardian.move(5, attacking);
    if(petAlive)
      pet.move(5, attacking);
  }
  if(j) {
    guardian.move(6, attacking);
    if(petAlive)
      pet.move(6, attacking);
  }
  if(petAlive) {
    updatePet();
  }
}

public void mousePressed() {
  if(mouseButton == LEFT) {
    guardian.attack = true;
    if(attacks.size() == 0)
      if(guardian.right) {
        if(mouseX < guardian.position.x) {
          attacks.add( new Attack(guardian.position.x - width/ATTACK_WIDTH, guardian.position.y, mouseX, mouseY, false));
        } else {
          attacks.add( new Attack(guardian.position.x + width/ATTACK_WIDTH, guardian.position.y, mouseX, mouseY, true));
        }
      } else {
        if(mouseX > guardian.position.x) {

          attacks.add( new Attack(guardian.position.x + width/ATTACK_WIDTH, guardian.position.y, mouseX, mouseY, true));
        } else {
          attacks.add( new Attack(guardian.position.x - width/ATTACK_WIDTH, guardian.position.y, mouseX, mouseY, false));
        }
      }
  }
}

public void attack() {
  drawAttack();
  removeAttack();
}

public void removeAttack() {
  for(Attack attack : new ArrayList<Attack>(attacks)) {
    if(attack.distance > attack.MAX_DISTANCE || attack.position.y > height - height/10 ) {
      attacks.remove(attack);
    }
  }
}

public void drawAttack() {
  for(Attack attack : attacks) {
    attack.draw();
  }
}

public void enemyAttack() {
  for(Enemy enemy : enemies) {
  if(!enemy.attack) {
    if(guardian.position.x < enemy.position.x) {
      enemy.right = false;
    } else {
      enemy.right = true;
    }
  }

    if(enemy.right && guardian.position.x < enemy.position.x + width/ATTACK_DISTANCE) {
      enemy.attack = true;
      enemy.velocity.x = 0;
    } else if(!enemy.right && guardian.position.x > enemy.position.x - width/ATTACK_DISTANCE) {
      enemy.attack = true;
      enemy.velocity.x = 0;
    } else if (dist(guardian.position.x, guardian.position.y, enemy.position.x, enemy.position.y) > width/2) {
      enemy.idle = true;
      enemy.attack = false;
    } else {
      enemy.idle = false;
    }


    if(!enemy.idle) {
    enemy.attack();

    }
  }
}

public void detectAttackCollision() {
  for(Attack attack : new ArrayList<Attack>(attacks)) {
    float attackX = attack.position.x + attack.attackRight.width/2;
    float attackY = attack.position.y - attack.attackRight.height/2;

    for(Enemy enemy : new ArrayList<Enemy>(enemies)) {

      float enemyX = enemy.position.x + width/GUARDIAN_WIDTH;
      float enemyY = enemy.position.y - width/GUARDIAN_HEIGHT;
      if( attackX < enemyX && attackX > enemy.position.x ) {
        if(attackY < enemy.position.y && attackY > enemyY) {
          enemies.remove(enemy);
        }
      }
    }
  }
}


public void drawEnemies() {
  for(Enemy enemy : enemies) {
    enemy.draw();
  }
}
public class Animation {

  final String EXTENSION = ".png";
  final int TOTAL_FRAMES = 5;

  ArrayList<PImage> animation;
  String filename;
  int currentFrame;
  int prevTime;
  int deltaTime;
  boolean animated;

  Animation(String filename) {
    this.animation = new ArrayList<PImage>();
    this.filename = filename;
    loadAnimation();
    this.currentFrame = 0;
    this.prevTime = 0;
    this.deltaTime = 100;
    this.animated = false;
  }

  public void loadAnimation() {
    for(int i = 0; i < TOTAL_FRAMES; i++) {
      String frameName = (filename + i + EXTENSION);
      animation.add(loadImage(frameName));
    }
  }


  public void draw(PVector position) {
    if(millis() > prevTime + deltaTime) {
      currentFrame++;
      if(currentFrame > TOTAL_FRAMES - 1) {
        animated = true;
        currentFrame = 0;
      }
      prevTime = millis();
    }
    image(animation.get(currentFrame), position.x, position.y );
  }

}
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
  public PVector calculateDirection() {
    return PVector.sub(destination, position);
  }

  //calculate acceleration
  public PVector calculateAcceleration() {
    PVector a = this.direction.normalize();
    a = this.direction.mult(5);
    return a;
  }

  public void scaleAttack() {
    attackRight.resize(ATTACK_SIZE, 0);
    attackLeft.resize(ATTACK_SIZE, 0);
  }

  public void update(){
    velocity.add(acceleration);
    velocity.limit(ATTACK_SPEED);
    position.add(velocity);
    distance = dist(startX, startY, position.x, position.y);
  }

  public void display() {
    if(right) {
      image(attackRight, position.x, position.y);
    } else if (!right) {
      image(attackLeft, position.x, position.y);
    }
  }

  public void draw(){
    update();
    display();
  }
}
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

  public void initialiseLayers() {
    for(int i = 0; i < layerTotal; i ++) {
      if(layerTotal == 1) {
        System.out.println("HELLO");
        layers.add(new Layer(path + i + PNG, startX, startY, 20));
      } else {
        layers.add(new Layer(path + i + PNG, startX, startY, i*2));
      }

    }
  }

  public void resetTransitionSpeed() {
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

  public void cameraTransitionSpeed() {
    if(reset) {
      for(int i = 0; i < layerTotal; i++) {
        layers.get(i).transition = CAMERA;
      }
      reset = false;
    }
  }

  public void resizeLayers() {

    for(Layer layer: layers) {
      layer.image.resize(0, height);
    }
  }

  public void draw(int direction) {

    for(Layer layer : layers) {
      layer.draw();
      if(direction > 0) {
        layer.parallaxShift(direction);
      }
    }
  }
}
public class Enemy extends Entity {

  final int IDLE_RESIZE = width/30;
  final int ATTACK_RESIZE = width/22;
  final int JUMP_RESIZE = width/20;
  final int RUN_RESIZE = width/25;

  final int ENEMY_SPEED = 7;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;
  final int ENEMY_WIDTH = 20;


  Enemy(String path, float x, float y) {
    super(path, x ,y);
    resize();
  }

  public void resize() {
    resizeIdle();
    resizeRun();
    resizeJump();
    resizeAttack();
  }

  public void resizeAttack() {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE, 0);
    }
  }

  public void resizeIdle() {
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE, 0);
    }
  }

  public void resizeRun() {
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE, 0);
    }
  }

  public void resizeJump() {
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE, 0);
    }
  }

  public void attack() {
    if(!attack) {
      if(right) {
        enemy.velocity.x = ENEMY_SPEED;
      } else {
        enemy.velocity.x = -ENEMY_SPEED;
      }
    }

  }

}
public class Entity {

  final String IDLE_RIGHT = "idleRight/";
  final String IDLE_LEFT = "idleLeft/";
  final String RUN_RIGHT = "runRight/";
  final String RUN_LEFT = "runLeft/";
  final String JUMP_RIGHT = "jumpRight/";
  final String JUMP_LEFT = "jumpLeft/";
  final String ATTACK_RIGHT = "attackRight/";
  final String ATTACK_LEFT = "attackLeft/";
  final String DIE_RIGHT = "dieRight/";
  final String DIE_LEFT = "dieLeft";

  String idleRightPath;
  String idleLeftPath;
  String runRightPath;
  String runLeftPath;
  String jumpRightPath;
  String jumpLeftPath;
  String attackRightPath;
  String attackLeftPath;


  float GROUND = height - height/6.85f;
  final int ENTITY_SPEED = 10;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;

  boolean right;
  boolean idle;
  boolean jump;
  boolean attack;
  boolean anchorRight;
  boolean anchorLeft;

  PVector velocity;
  PVector position;

  HashMap<String, Animation> animations;

  Entity (String path, float x, float y) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.animations = new HashMap<String, Animation>();

    this.idleRightPath = path + IDLE_RIGHT;
    this.idleLeftPath = path + IDLE_LEFT;
    this.runRightPath = path + RUN_RIGHT;
    this.runLeftPath = path + RUN_LEFT;
    this.jumpRightPath = path + JUMP_RIGHT;
    this.jumpLeftPath = path + JUMP_LEFT;
    this.attackRightPath = path + ATTACK_RIGHT;
    this.attackLeftPath = path + ATTACK_LEFT;

    initialiseAnimations();

    this.right = true;
    this.idle = true;
    this.jump = false;
    this.attack = false;

    this.anchorLeft = false;
    this.anchorRight = false;

  }

  public void initialiseAnimations() {

    Animation idleRight = new Animation(idleRightPath);
    Animation idleLeft = new Animation(idleLeftPath);
    Animation runRight = new Animation(runRightPath);
    Animation runLeft = new Animation(runLeftPath);
    Animation jumpRight = new Animation(jumpRightPath);
    Animation jumpLeft = new Animation(jumpLeftPath);
    Animation attackRight = new Animation(attackRightPath);
    Animation attackLeft = new Animation(attackLeftPath);

    animations.put(IDLE_RIGHT, idleRight);
    animations.put(IDLE_LEFT, idleLeft);
    animations.put(RUN_RIGHT, runRight);
    animations.put(RUN_LEFT, runLeft);
    animations.put(JUMP_RIGHT, jumpRight);
    animations.put(JUMP_LEFT, jumpLeft);
    animations.put(ATTACK_RIGHT, attackRight);
    animations.put(ATTACK_LEFT, attackLeft);

  }


  public void update() {
    if(velocity.x > 1 || velocity.x < -1) {
      velocity.x *= 0.7f;
    } else {
      velocity.x = 0;
    }

    if(position.y < GROUND && jump) {
      velocity.y += GRAVITY;
    }

    if(jump && position.y >= GROUND - velocity.y) {
      velocity.y = 0;
      position.y = GROUND;
      jump = false;
    }
    position.add(velocity);
  }

  public void display() {
    if(attack && right) {
      animate(ATTACK_RIGHT);
      if(animations.get(ATTACK_RIGHT).animated) {
          attack = false;
          animations.get(ATTACK_RIGHT).animated = false;
      }
    } else if (attack && !right) {
        animate(ATTACK_LEFT);
        if(animations.get(ATTACK_LEFT).animated) {
          attack = false;
          animations.get(ATTACK_LEFT).animated = false;
        }
    } else if(jump && right) {
      animate(JUMP_RIGHT);
    } else if (jump && !right) {
      animate(JUMP_LEFT);
    } else if (idle && right) {
      animate(IDLE_RIGHT);
    } else if(idle && !right) {
      animate(IDLE_LEFT);
    } else if(!idle && right) {
      animate(RUN_RIGHT);
    } else if(!idle && !right) {
      animate(RUN_LEFT);
    }
  }

  public void animate(String animation) {
    animations.get(animation).draw(position);
  }

  public void draw() {
    update();
    display();
  }

  public void move(int i, boolean b){  
  }
}
public class Guardian extends Entity {


  final int IDLE_RESIZE = width/23;
  final int ATTACK_RESIZE = width/22;
  final int JUMP_RESIZE = width/20;
  final int RUN_RESIZE = width/20;

  final int VELOCITY_SWITCH = width/38;

  final int CAMERA_ANCHOR = 10;

  float GROUND = height - height/6.85f;
  float MIDDLE = width/2;
  final int GUARDIAN_SPEED = 7;
  final int JUMP_SPEED = 30;
  final float GRAVITY = 3;
  final int deltaTime = 100;
  int prevTime = 0;
  final int GUARDIAN_WIDTH = 20;
  int anchorRightPos;
  int anchorLeftPos;


  Guardian (String path, float x, float y) {
      super(path, x, y);
      this.anchorRight = false;
      this.anchorLeft = false;
      this.anchorRightPos = width/3;
      this.anchorLeftPos =  width/5 ;
      resize();
  }

  public boolean getAnchorRight() {
    return anchorRight;
  }

  public boolean getAnchorLeft() {
    return anchorLeft;
  }

  public void resize() {
    resizeIdle();
    resizeRun();
    resizeJump();
    resizeAttack();
  }

  public void resizeAttack() {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE, 0);
    }
  }

  public void resizeIdle() {
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE, 0);
    }
  }

  public void resizeRun() {
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE, 0);
    }
  }

  public void resizeJump() {
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE, 0);
    }
  }

  public void moveRightParallax() {
    if(position.x < anchorRightPos && !anchorRight) {
      velocity.x += GUARDIAN_SPEED;
      anchorLeft = false;
    } else {
      anchorRight = true;
      anchorLeft = false;
      velocity.x = -VELOCITY_SWITCH;
      if(position.x <= anchorLeftPos) {
        velocity.x = 0;
      }
    }
    right = true;
    idle = false;
  }

  public void moveRight() {
    if(position.x + width/GUARDIAN_WIDTH <= width) {
      velocity.x += GUARDIAN_SPEED;
    } else {
      velocity.x = -GUARDIAN_SPEED;
    }

    right = true;
    idle = false;
  }

  public void moveLeft() {
      if(position.x >= 0) {
        velocity.x -= GUARDIAN_SPEED;
      } else {
        velocity.x = GUARDIAN_SPEED;
      }

      right = false;
      idle = false;
  }

  public void moveLeftParallax() {
    if(position.x > anchorLeftPos && !anchorLeft) {
      velocity.x -= GUARDIAN_SPEED;
      anchorRight = false;
    } else {
      anchorLeft = true;
      anchorRight = false;
      velocity.x = VELOCITY_SWITCH;
      if(position.x >= anchorRightPos) {
          velocity.x = 0;
      }
    }
    right = false;
    idle = false;
  }

  public void jump() {
    if(position.y >= GROUND && !jump) {
      velocity.y = -JUMP_SPEED;
      jump = true;
    }
  }

  public @Override
  void move(int i, boolean b) {
    switch (i) {
      case 1:
        break;
      case 2:
        break;
      case 3:
      if(b) {
        moveRight();
      } else {
        moveRightParallax();
      }

        break;
      case 4:
      if(b) {
        moveLeft();
      } else {
        moveLeftParallax();
      }
        break;
      case 5:
        idle = true;

        if(!b) {
          if(anchorLeft) {
            if(guardian.position.x < 1.5f*width/5) {
              anchorLeft = false;
              anchorRight = false;
              velocity.x = 0;
            }
          } else if (anchorRight) {
            if(guardian.position.x >= 1.5f*width/5 - width/GUARDIAN_WIDTH) {
              anchorLeft = false;
              anchorRight = false;
              velocity.x = 0;
            }
          }
        }

        break;
      case 6:
        jump();
        break;
      default:
        break;
    }
  }
}
public class Layer {

  PImage image;
  float x1;
  float x2;
  float x3;
  float y;
  float transition;

  Layer(String filename, float x, float y, float transition) {
    this.image = loadImage(filename);
    this.y = y;
    this.x1 = x;
    this.x2 = x + image.width;
    this.x3 = x + (2 * image.width);
    this.transition = transition;
  }

  public void parallaxShift(int direction) {
    if(direction == 1) {
      shiftRight();
    } else if (direction == 2){
      shiftLeft();
    }
  }

  public void shiftRight() {
    this.x1 -= transition;
    this.x2 -= transition;
    this.x3 -= transition;

    if(x1 + image.width < 0) {
      x1 = x3 + image.width;
    }

    if(x2 + image.width < 0) {
      x2 = x1 + image.width;
    }

    if(x3 + image.width < 0) {
      x3 = x2 + image.width;
    }
  }

  public void shiftLeft() {
    this.x1 += transition;
    this.x2 += transition;
    this.x3 += transition;

    if(x1 > width) {
      x1 = x2 - image.width;
    }

    if(x2 > width) {
      x2 = x3 - image.width;
    }

    if(x3 > width) {
      x3 = x1 - image.width;
    }
  }

  public void draw() {
    image(image, x1, y);
    image(image, x2, y);
    image(image, x3, y);

  }
}
public class Pet extends Entity {

  final int IDLE_RESIZE = width/15;
  final int ATTACK_RESIZE = width/14;
  final int JUMP_RESIZE = width/13;
  final int RUN_RESIZE = width/14;

  final int PET_SPEED = 5;
  float GROUND = height - height/6.85f;
  float MIDDLE = width/2;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;

  Pet(String path, float x, float y) {
    super(path, x, y);
    resize();
    this.attack = true;
  }

  public void resize() {
    resizeIdle();
    resizeRun();
    resizeJump();
    resizeAttack();
  }

  public void resizeAttack() {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE, 0);
    }
  }

  public void resizeIdle() {
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE, 0);
    }
  }

  public void resizeRun() {
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE, 0);
    }
  }

  public void resizeJump() {
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE, 0);
    }
  }

  public void moveRight() {
    right = true;
    idle = false;
  }

  public void moveLeft() {
    right = false;
    idle = false;
  }

  public void jump() {
    if(position.y >= GROUND && !jump) {
      velocity.y = -JUMP_SPEED;
      jump = true;
    }
  }

  public @Override
  void move(int i, boolean b) {
    switch (i) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        moveRight();
        break;
      case 4:
        moveLeft();
        break;
      case 5:
        idle = true;
        break;
      case 6:
        jump();
        break;
      default:
        break;
    }
  }


}
public class Platform {

  PVector position;
  PImage tile;

  final int RESIZE = 6;

  Platform(String path, float x, float y) {
    this.tile = loadImage(path);
    this.position = new PVector(x, y);
    this.tile.resize(width/RESIZE, 0);

  }

  public void draw() {
    image(tile, position.x, position.y);
  }



}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ForestGuardian" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
