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


final int GUARDIAN_WIDTH = 20;
final int ATTACK_WIDTH = 40;
final int GUARDIAN_HEIGHT = 20;
final int ATTACK_DISTANCE = 40;
final int RANGED_ATTACK_DISTANCE = 3;

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

final int ENEMY_PARALLAX_POSITION = 20;

final int PET_MAX_LIFE = 10000;
final int SUMMON_INCREASE = 3;
final int PET_COOLDOWN_TIME = 3000;

final int CAMERA_SPEED = 50;
final int PARALLAX_RIGHT = 1;
final int PARALLAX_LEFT = 2;
final int PARALLAX_NONE = 0;
final int CAMERA_ANCHOR = 10;

final int BACKGROUND_ONE_LAYERS = 11;
final int BACKGROUND_TWO_LAYERS = 1;

final String GUARDIAN_PATH = "animations/guardian/";
final String WOLF_PATH = "animations/pet/1/";
final String ENEMY_ONE_PATH = "animations/enemy/1/";
final String ENEMY_TWO_PATH = "animations/enemy/2/";
final String ENEMY_THREE_PATH = "animations/enemy/3/";
final String ENEMY_FOUR_PATH = "animations/enemy/4/";
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

final float GROUND_PROP = 6.85f;
final float ENT_GROUND_PROP = 6;
final float GROUND_TILE = 12;

Background background;
Entity guardian;
Entity pet;


boolean w, a, s, d, j;
boolean petAlive;
boolean summon;
boolean petCooldown;
boolean attacking;
float ground;
float tileGround;
float entGround;
int parallax;
int summonCount;
int petTimer;
int petCooldownTimer;
int guardianAttacks;
Platform platform;
PlatformGenerator platGen;


ArrayList<Attack> attacks;
ArrayList<Enemy> enemies;



public void setup() {
  

  w = a = s = d = j = false;

  petAlive = false;

  petCooldown = false;

  summon = false;

  attacking = false;

  parallax = 0;

  summonCount = 0;

  guardianAttacks = 0;

  petTimer = 0;

  petCooldownTimer = 0;

  ground = height - height/GROUND_PROP;
  entGround = height - height/ENT_GROUND_PROP;

  tileGround = height - height/GROUND_TILE;

  background = new Background(BACKGROUND_ONE_PATH, BACKGROUND_ONE_LAYERS);

  guardian = new Guardian(GUARDIAN_PATH, width/4, ground);

  pet = new Pet(WOLF_PATH, guardian.position.x, guardian.position.y);
  attacks = new ArrayList<Attack>();

  enemies = new ArrayList<Enemy>();

  enemies.add(new Enemy(ENEMY_ONE_PATH , width, ground));
  enemies.add(new Enemy(ENEMY_TWO_PATH, width - 200, ground));
  enemies.add(new Enemy(ENEMY_THREE_PATH, width - 400, entGround));
  enemies.add(new Enemy(ENEMY_FOUR_PATH, width - 600, entGround));

  platGen = new PlatformGenerator();



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
  updateAnchor();
  //testJump();
}

//checks for whether an enemy is attacking to stop parallax mode for combat
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

public void updateAnchor() {
  if(attacking) {
    guardian.anchorLeft = false;
    guardian.anchorRight = false;
  }
}

//mirrors pet movement when travelling
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

//pet is unsummoned after the duration has finished
public void unsummonPet() {
  if(millis() > petTimer +  PET_MAX_LIFE) {
    petAlive = false;
    petTimer = millis();
  }
}

//check ability cooldowns to see if can be used again
public void checkCooldowns() {
  if(millis() > petCooldownTimer + PET_COOLDOWN_TIME) {
    petCooldown = true;
    petCooldownTimer = millis();
  }
}

//summon pet
public void summonPet() {
  petAlive = true;
  petTimer = millis();
}

//parallax method for adjusting guardian, enemis and background
//uses a sliding window with in play area and uses hard and soft anchor points
public void drawParallaxBackround() {
  if(!attacking) {
    if(guardian.anchorRight && guardian.idle) {
        background.cameraTransitionSpeed();
        platGen.cameraTransitionSpeed();
        parallax = PARALLAX_LEFT;
        guardian.velocity.x = CAMERA_SPEED;
        positionEnemies(CAMERA_SPEED);
    } else if (guardian.anchorLeft && guardian.idle) {
        background.cameraTransitionSpeed();
        platGen.cameraTransitionSpeed();
        parallax = PARALLAX_RIGHT;
        guardian.velocity.x = -CAMERA_SPEED;
        positionEnemies(-CAMERA_SPEED);
      } else if(guardian.right && guardian.anchorRight
        && !guardian.idle) {
          if(guardian.velocity.x == 0) {
            background.resetTransitionSpeed();
            platGen.resetTransitionSpeed();
          } else {
            background.cameraTransitionSpeed();
            platGen.cameraTransitionSpeed();
          }
          positionEnemies(-ENEMY_PARALLAX_POSITION);
          parallax = PARALLAX_RIGHT;
    } else if (!guardian.right && guardian.anchorLeft
        && !guardian.idle){
          if(guardian.velocity.x == 0) {
            background.resetTransitionSpeed();
            platGen.resetTransitionSpeed();
          } else {
            background.cameraTransitionSpeed();
            platGen.cameraTransitionSpeed();
          }
          positionEnemies(ENEMY_PARALLAX_POSITION);
        parallax = PARALLAX_LEFT;
    } else {
        parallax = PARALLAX_NONE;
    }
    background.draw(parallax);
    platGen.draw(parallax);
  }
}



//adjust enemis for parallax
public void positionEnemies(int velocity) {
    for(Enemy enemy : enemies) {
      enemy.velocity.x = velocity;
    }
}

public void positionPlatforms(int velocity) {
    for(Platform platform : platGen.platforms) {

    }
}

// movement and abilites
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

// movement and abilities
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


// movement for player and pet
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

//guardian attack
// fires and orients the attack depending on mouse click and direction
public void mousePressed() {
  if(mouseButton == LEFT) {
    guardian.attack = true;
    if(guardianAttacks == 0)
      if(guardian.right) {
        if(mouseX < guardian.position.x) {
          attacks.add( new Attack(guardian.position.x - width/ATTACK_WIDTH, guardian.position.y, mouseX, mouseY, false, 0));
        } else {
          attacks.add( new Attack(guardian.position.x + width/ATTACK_WIDTH, guardian.position.y, mouseX, mouseY, true, 0));
        }
      } else {
        if(mouseX > guardian.position.x) {

          attacks.add( new Attack(guardian.position.x + width/ATTACK_WIDTH, guardian.position.y, mouseX, mouseY, true, 0));
        } else {
          attacks.add( new Attack(guardian.position.x - width/ATTACK_WIDTH, guardian.position.y, mouseX, mouseY, false, 0));
        }
      }
  }
}

//draw attacks();
public void attack() {
  drawAttack();
  removeGuardianAttack();
}

//remove missed attacks
public void removeGuardianAttack() {
  for(Attack attack : new ArrayList<Attack>(attacks)) {
    if(attack.attackType == 0) {
      if(attack.distance > attack.MAX_DISTANCE || attack.position.y > height - height/10 ) {
        attacks.remove(attack);
        guardianAttacks = 0;
      }
    }

  }
}



//draw attacks
public void drawAttack() {
  for(Attack attack : attacks) {
    attack.draw();
  }
}

//enemy detection distance
//enemy will pursue guardian and attack if close enough
public void enemyAttack() {
  for(Enemy enemy : enemies) {
    if(!enemy.attack) {
      if(guardian.position.x < enemy.position.x) {
        enemy.right = false;
      } else {
        enemy.right = true;
      }
    }
  if(enemy.ranged == 0) {
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
  } else {
      if(enemy.right && guardian.position.x < enemy.position.x + width/RANGED_ATTACK_DISTANCE) {
        enemy.attack = true;
        enemy.velocity.x = 0;
      } else if(!enemy.right && guardian.position.x > enemy.position.x - width/RANGED_ATTACK_DISTANCE) {
        enemy.attack = true;
        enemy.velocity.x = 0;
      } else if (dist(guardian.position.x, guardian.position.y, enemy.position.x, enemy.position.y) > width/2) {
        enemy.idle = true;
        enemy.attack = false;
      } else {
        enemy.idle = false;
      }
    }

    //change magic numbers
    if(enemy.attack) {
      if(frameCount % 10 == 0) {
        if(enemy.ranged == 1) {
          if(enemy.right) {
            attacks.add(new Attack(enemy.position.x, enemy.position.y,
              guardian.position.x, guardian.position.y, true, 1));
          } else {
            attacks.add(new Attack(enemy.position.x, enemy.position.y,
              guardian.position.x, guardian.position.y, true, 1));
          }
        } else if(enemy.ranged == 2) {
          if(enemy.right) {
            attacks.add(new Attack(enemy.position.x, enemy.position.y,
              guardian.position.x, calculateAimHeight(enemy), true, 2));
          } else {
            attacks.add(new Attack(enemy.position.x, enemy.position.y,
              guardian.position.x, calculateAimHeight(enemy), true, 2));
          }
        }
      }
    }

    if(!enemy.idle) {
    enemy.attack();
    }
  }
}




public float calculateAimHeight(Enemy enemy) {
  float maxLaunchHeight = height - guardian.position.y;

  float enemyGuardianDistance = dist(guardian.position.x, guardian.position.y, enemy.position.x, enemy.position.y);

  float optimalHeight = height - 0.85f * enemyGuardianDistance;

  return optimalHeight;

}


//detect whether guardian attack hits enemy
//simplified to point rectangle collision
public void detectAttackCollision() {
  for(Attack attack : new ArrayList<Attack>(attacks)) {
    float attackX = attack.position.x + attack.attackRight.width/2;
    float attackY = attack.position.y + attack.attackRight.height/2;

    for(Enemy enemy : new ArrayList<Enemy>(enemies)) {

      float enemyX = enemy.position.x + width/GUARDIAN_WIDTH;
      float enemyY = enemy.position.y + width/GUARDIAN_HEIGHT;
      if( attackX < enemyX && attackX > enemy.position.x ) {
        if(attackY < enemyY && attackY > enemy.position.y) {
          if(attack.attackType == 0) {
            enemies.remove(enemy);
          }
        }
      }
    }
  }
}

//Draw enemies
public void drawEnemies() {
  for(Enemy enemy : enemies) {
    enemy.draw();
  }
}
//Animation class for loading in and setting animation speed
public class Animation {

  final String EXTENSION = ".png";
  final int TOTAL_FRAMES = 5;

  ArrayList<PImage> animation;
  String filename;
  int currentFrame;
  int prevTime;
  int deltaTime;
  boolean animated;

  //Animation contains a list of files and frame sequence time
  Animation(String filename) {
    this.animation = new ArrayList<PImage>();
    this.filename = filename;
    loadAnimation();
    this.currentFrame = 0;
    this.prevTime = 0;
    this.deltaTime = 100;
    this.animated = false;
  }

  //load all images for an animation
  //animation is in order and files named from 0-4.png
  public void loadAnimation() {
    for(int i = 0; i < TOTAL_FRAMES; i++) {
      String frameName = (filename + i + EXTENSION);
      animation.add(loadImage(frameName));
    }
  }


  //animate by playing frames in order using a stopwatch
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

  public PVector addGravity() {
    return new PVector(0, 0.3f);
  }

  //calculate direction of travel using sub
  public PVector calculateDirection() {
    return PVector.sub(destination, position);
  }

  //calculate acceleration of attack
  public PVector calculateAcceleration() {
    PVector a = this.direction.normalize();
      a = this.direction.mult(5);


    return a;
  }

  //change size of attack
  public void scaleAttack() {
    attackRight.resize(ATTACK_SIZE, 0);
    attackLeft.resize(ATTACK_SIZE, 0);
    rock.resize(ATTACK_SIZE/4, 0);
    arrowLeft.resize(ATTACK_SIZE/2, 0);
    arrowLeft.resize(ATTACK_SIZE/2, 0);
  }

  //update position by adding acceleration to velocity and velocity to position
  public void update(){
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
  public void display() {

    switch(this.attackType) {
      case GUARDIAN_WOLF_ATTACK:
        if(right) {
          image(attackRight, this.position.x, this.position.y);
        } else  {
          image(attackLeft, this.position.x, this.position.y);
        }
        break;
      case ENEMY_ARROW_ATTACK:
        if(!right) {
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

  public void draw(){
    update();
    display();
  }
}
//Background class that loads in all layers for parallax
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
  public void initialiseLayers() {
    for(int i = 0; i < layerTotal; i ++) {
      layers.add(new Layer(path + i + PNG, startX, startY, i*2));
    }
  }

  //transition speed of layers set to default
  public void resetTransitionSpeed() {
    if(!reset) {
      for(int i = 0; i < layerTotal; i++) {
          layers.get(i).transition = i*2;
      }
      reset = true;
    }
  }

  //increase the transition speed for camera change
  public void cameraTransitionSpeed() {
    if(reset) {
      for(int i = 0; i < layerTotal; i++) {
        layers.get(i).transition = CAMERA;
      }
      reset = false;
    }
  }

  //scale background so that they fit into the height of the display
  public void resizeLayers() {
    for(Layer layer: layers) {
      layer.image.resize(0, height);
    }
  }

  //draw background with parallax if requested
  public void draw(int direction) {
    for(Layer layer : layers) {
      layer.draw();
      if(direction > 0) {
        layer.parallaxShift(direction);
      }
    }
  }
}
//Enemy class used for enemy entites
public class Enemy extends Entity {

  final String ENEMY_ONE_PATH = "animations/enemy/1/";
  final String ENEMY_TWO_PATH = "animations/enemy/2/";
  final String ENEMY_THREE_PATH = "animations/enemy/3/";
  final String ENEMY_FOUR_PATH = "animations/enemy/4/";

  final int IDLE_RESIZE_1 = width/27;
  final int ATTACK_RESIZE_1 = width/23;
  final int JUMP_RESIZE_1 = width/20;
  final int RUN_RESIZE_1 = width/25;

  final int IDLE_RESIZE_2 = width/25;
  final int ATTACK_RESIZE_2 = width/24;
  final int JUMP_RESIZE_2 = width/20;
  final int RUN_RESIZE_2 = width/25;

  final int IDLE_RESIZE_3 = width/20;
  final int ATTACK_RESIZE_3 = width/20;
  final int JUMP_RESIZE_3 = width/15;
  final int RUN_RESIZE_3 = width/18;

  final int IDLE_RESIZE_4 = width/20;
  final int ATTACK_RESIZE_4 = width/17;
  final int JUMP_RESIZE_4 = width/15;
  final int RUN_RESIZE_4 = width/19;

  final int ENEMY_SPEED = 7;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;
  final int ENEMY_WIDTH = 20;

  final int BOW = 1;
  final int ROCK = 2;
  final int MELEE = 0;

  int ranged;


  Enemy(String path, float x, float y) {
    super(path, x ,y);
    this.ranged = checkType(path);


    resize(path);
  }

  public int checkType(String path) {
    if(path.equals(ENEMY_TWO_PATH)  ) {
      return BOW;
    } else if (path.equals(ENEMY_THREE_PATH)) {
      return ROCK;
    }

    return MELEE;

  }

  //resize animations so all same size
  public void resize(String path) {
    resizeIdle(path);
    resizeRun(path);
    resizeJump(path);
    resizeAttack(path);
  }

  public void resizeAttack(String path) {

    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
        frame.resize(ATTACK_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(ATTACK_LEFT).animation) {
        frame.resize(ATTACK_RESIZE_1, 0);
      }
    } else if (path.equals(ENEMY_TWO_PATH)) {
        for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
          frame.resize(ATTACK_RESIZE_2, 0);
        }
        for(PImage frame : animations.get(ATTACK_LEFT).animation) {
          frame.resize(ATTACK_RESIZE_2, 0);
        }
    } else if (path.equals(ENEMY_THREE_PATH)) {
        for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
          frame.resize(ATTACK_RESIZE_3, 0);
        }
        for(PImage frame : animations.get(ATTACK_LEFT).animation) {
          frame.resize(ATTACK_RESIZE_3, 0);
        }
    } else if (path.equals(ENEMY_FOUR_PATH)) {
        for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
          frame.resize(ATTACK_RESIZE_4, 0);
        }
        for(PImage frame : animations.get(ATTACK_LEFT).animation) {
          frame.resize(ATTACK_RESIZE_4, 0);
        }
    }
  }

  public void resizeIdle(String path) {
    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(IDLE_LEFT).animation) {
        frame.resize(IDLE_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(IDLE_RIGHT).animation) {
        frame.resize(IDLE_RESIZE_1, 0);
      }
    } else if(path.equals(ENEMY_TWO_PATH)) {
        for(PImage frame : animations.get(IDLE_LEFT).animation) {
          frame.resize(IDLE_RESIZE_2, 0);
        }
        for(PImage frame : animations.get(IDLE_RIGHT).animation) {
          frame.resize(IDLE_RESIZE_2, 0);
        }
    } else if(path.equals(ENEMY_THREE_PATH)) {
        for(PImage frame : animations.get(IDLE_LEFT).animation) {
          frame.resize(IDLE_RESIZE_3, 0);
        }
        for(PImage frame : animations.get(IDLE_RIGHT).animation) {
          frame.resize(IDLE_RESIZE_3, 0);
        }
    } else if(path.equals(ENEMY_FOUR_PATH)) {
        for(PImage frame : animations.get(IDLE_LEFT).animation) {
          frame.resize(IDLE_RESIZE_4, 0);
        }
        for(PImage frame : animations.get(IDLE_RIGHT).animation) {
          frame.resize(IDLE_RESIZE_4, 0);
        }
    }
  }

  public void resizeRun(String path) {
    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(RUN_LEFT).animation) {
        frame.resize(RUN_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(RUN_RIGHT).animation) {
        frame.resize(RUN_RESIZE_1, 0);
      }
    } else if(path.equals(ENEMY_TWO_PATH)) {
      for(PImage frame : animations.get(RUN_LEFT).animation) {
        frame.resize(RUN_RESIZE_2, 0);
      }
      for(PImage frame : animations.get(RUN_RIGHT).animation) {
        frame.resize(RUN_RESIZE_2, 0);
      }
    } else if(path.equals(ENEMY_THREE_PATH)) {
      for(PImage frame : animations.get(RUN_LEFT).animation) {
        frame.resize(RUN_RESIZE_3, 0);
      }
      for(PImage frame : animations.get(RUN_RIGHT).animation) {
        frame.resize(RUN_RESIZE_3, 0);
      }
    } else if(path.equals(ENEMY_FOUR_PATH)) {
      for(PImage frame : animations.get(RUN_LEFT).animation) {
        frame.resize(RUN_RESIZE_4, 0);
      }
      for(PImage frame : animations.get(RUN_RIGHT).animation) {
        frame.resize(RUN_RESIZE_4, 0);
      }
    }

  }

  public void resizeJump(String path) {
    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(JUMP_LEFT).animation) {
        frame.resize(JUMP_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(JUMP_RIGHT).animation) {
        frame.resize(JUMP_RESIZE_1, 0);
      }
    } else if(path.equals(ENEMY_TWO_PATH)) {
        for(PImage frame : animations.get(JUMP_LEFT).animation) {
          frame.resize(JUMP_RESIZE_2, 0);
        }
        for(PImage frame : animations.get(JUMP_RIGHT).animation) {
          frame.resize(JUMP_RESIZE_2, 0);
        }
    } else if(path.equals(ENEMY_THREE_PATH)) {
        for(PImage frame : animations.get(JUMP_LEFT).animation) {
          frame.resize(JUMP_RESIZE_3, 0);
        }
        for(PImage frame : animations.get(JUMP_RIGHT).animation) {
          frame.resize(JUMP_RESIZE_3, 0);
        }
    } else if(path.equals(ENEMY_FOUR_PATH)) {
        for(PImage frame : animations.get(JUMP_LEFT).animation) {
          frame.resize(JUMP_RESIZE_4, 0);
        }
        for(PImage frame : animations.get(JUMP_RIGHT).animation) {
          frame.resize(JUMP_RESIZE_4, 0);
        }
    }

  }

  //attack and pursue guardian
  public void attack() {
    if(!attack) {
      if(right) {
        this.velocity.x = ENEMY_SPEED;
      } else {
        this.velocity.x = -ENEMY_SPEED;
      }
    }

  }

}
//General Entity class used for all animated entities
public class Entity {

  //Both paths and keys
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
  final float GRAVITY = 3;

  boolean right;
  boolean idle;
  boolean jump;
  boolean attack;
  boolean anchorRight;
  boolean anchorLeft;

  PVector velocity;
  PVector position;

  HashMap<String, Animation> animations;

  //Entity stalls all animations with HashMap
  //Nifty path manipulation allows any entity to be created with a single path given
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

  //add animations to HashMap
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


  //add momentum to entites and friction
  //gravity also added to entity movement
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

  //Display method used to show the correct animation
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

  //play an animation
  public void animate(String animation) {
    animations.get(animation).draw(position);
  }

  //draw
  public void draw() {
    update();
    display();
  }

  public void move(int i, boolean b){
  }
}
//Class representing the playable Guardian
//contains the anchor positions for parallax;
public class Guardian extends Entity {

  final int IDLE_RESIZE = width/23;
  final int ATTACK_RESIZE = width/22;
  final int JUMP_RESIZE = width/20;
  final int RUN_RESIZE = width/20;

  final int VELOCITY_SWITCH = width/38;
  final int CAMERA_ANCHOR = 10;

  final float GROUND = height - height/6.85f;
  final float MIDDLE = width/2;
  final int GUARDIAN_SPEED = 7;
  final int JUMP_SPEED = 30;
  final int GUARDIAN_WIDTH = 20;

  int anchorRightPos;
  int anchorLeftPos;


  //path and position
  Guardian (String path, float x, float y) {
      super(path, x, y);
      this.anchorRight = false;
      this.anchorLeft = false;
      this.anchorRightPos = width/3;
      this.anchorLeftPos =  width/5 ;
      resize();
  }

  //get anchors
  public boolean getAnchorRight() {
    return anchorRight;
  }

  public boolean getAnchorLeft() {
    return anchorLeft;
  }

  //resize animations()
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

  //  parallax move right
  // logic for moving when moving right and anchoring
  // if anchored on right move to left anchor to create more visual space
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

  //basic move right
  public void moveRight() {
    if(position.x + width/GUARDIAN_WIDTH <= width) {
      velocity.x += GUARDIAN_SPEED;
    } else {
      velocity.x = -GUARDIAN_SPEED;
    }

    right = true;
    idle = false;
  }

  //basic move left
  public void moveLeft() {
      if(position.x >= 0) {
        velocity.x -= GUARDIAN_SPEED;
      } else {
        velocity.x = GUARDIAN_SPEED;
      }

      right = false;
      idle = false;
  }

  //parallax move left
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

  //jump - needs work
  public void jump() {
    if(position.y >= GROUND && !jump) {
      velocity.y = -JUMP_SPEED;
      jump = true;
    }
  }

  //move method needs more work done
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
        //NEED TO REFACTOR
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
//class to represent each individual layer in a background
//contains 3 images so that all screen filled
//images loop past eachother depending on direction moving
public class Layer {

  PImage image;
  float x1;
  float x2;
  float x3;
  float y;
  float transition;

  //takes filename, position and transition speed
  Layer(String filename, float x, float y, float transition) {
    this.image = loadImage(filename);
    this.y = y;
    this.x1 = x;
    this.x2 = x + image.width;
    this.x3 = x + (2 * image.width);
    this.transition = transition;
  }

  //shift left or right
  public void parallaxShift(int direction) {
    if(direction == 1) {
      shiftRight();
    } else if (direction == 2){
      shiftLeft();
    }
  }

  //moving right
  //image 1 loops after image 3
  //image 2 loops after image 1
  //image 3 loops after image 2
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

  //moving left
  //image 1 loops before image 2
  //image 2 loops before image 3
  //image 3 loops before image 1
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

  //draw images
  public void draw() {
    image(image, x1, y);
    image(image, x2, y);
    image(image, x3, y);

  }
}
//Pet class used for when successfully summoned
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

  //resize Animations
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
//Platform class used for each individual tile
public class Platform {

  final String imgPath = "data/tileset/3.png";

  final int PLAT_RIGHT = 1;
  final int PLAT_LEFT = 2;

  PVector position;
  PImage tile;
  float transition;
  int platformWidth;

  final int RESIZE = 10;

  Platform( float x, float y, float transition) {
    this.tile = loadImage(imgPath);
    this.position = new PVector(x, y);
    this.tile.resize(width/RESIZE, 0);
    this.platformWidth = tile.width;
    this.transition = transition;
  }

  public void platformShift(int direction) {
    if (direction == PLAT_RIGHT) {
      platformRight();
    } else if (direction == PLAT_LEFT) {
      platformLeft();
    }
  }


  public void platformRight() {
    position.x -= transition;

  }

  public void platformLeft() {
    position.x += transition;
  }

  public void draw() {
    image(tile, position.x, position.y);
  }



}
class  PlatformGenerator {

  final int PLATFORM_NUM = 10;
  final int BASE_SPEED = 18;
  final int CAMERA_SPEED = 25;

  ArrayList<Platform> platforms;

  int numberOfPlatforms;
  boolean reset;

  PlatformGenerator() {
   this.platforms  = new ArrayList<Platform>();
    this.numberOfPlatforms = PLATFORM_NUM;
    generatePlatforms();
    this.reset = true;
  }

  public void generatePlatforms() {

    platforms.add(new Platform(width, height - height/5, BASE_SPEED));

    for(int i = 0; i < PLATFORM_NUM; i++) {
      float position = platforms.get(i).position.x + platforms.get(i).platformWidth;
      float sky = random(0,height);

      platforms.add(new Platform(position, sky, BASE_SPEED));
    }
  }

  public void resetTransitionSpeed() {
    if(!reset) {
      for(Platform platform : platforms) {
        platform.transition = BASE_SPEED;
      }
      reset = true;
    }
  }

  public void cameraTransitionSpeed() {
    if(reset) {
      for(Platform platform : platforms) {
        platform.transition = CAMERA_SPEED;
      }
      reset = false;
    }
  }


  public void draw(int direction) {
    for(Platform platform : platforms) {
      platform.draw();
      if(direction > 0) {
        platform.platformShift(direction);
      }
    }
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
