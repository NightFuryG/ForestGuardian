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


final int GUARDIAN_WIDTH = 24;
final int ATTACK_WIDTH = 40;
final int GUARDIAN_HEIGHT = 20;
final int GUARDIAN_FEET = 22;
final int ATTACK_DISTANCE = 40;
final float RANGED_ATTACK_DISTANCE = 1.6f;

final int BAR_WIDTH = 20;
final int BAR_LEFT = 150;
final int BAR_HEIGHT = 100;
final int BAR_ABOVE = 80;

final int LINE_ONE = 30;
final int LINE_TWO = 100;
final int LINE_HEIGHT = 100;
final int LINE_SUCCESS = 200;
final int LOWER_SUCCESS = 70;
final int UPPER_SUCCESS = 90;

final int ENEMY_PARALLAX_POSITION = 20;

final int START_GUARDIAN_ATTACK = 50;
final int START_ENEMY_ATTACK = 10;
final int START_ENEMY_MELEE = 1;

final int PET_MAX_LIFE = 10000;
final int SUMMON_INCREASE = 3;
final int PET_COOLDOWN_TIME = 100;

final int CAMERA_SPEED = 50;
final int PARALLAX_RIGHT = 1;
final int PARALLAX_LEFT = 2;
final int PARALLAX_NONE = 0;
final int CAMERA_ANCHOR = 10;

final float HEALTH_COLOUR_SCALE = 2.55f;
final float HEALTH_HEIGHT_SCALE = 0.925f;
final int HEALTH_DECREASE_SCALE = 4;
final int HEALTH_HEIGHT = 41;
final float HEALTH_WIDTH = 4.2f;

final int ARROW_HEIGHT_ADJUST = 60;

final int BACKGROUND_ONE_LAYERS = 11;

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

public final float GROUND_PROP = 6.85f;
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
int camera;
int petTimer;
int petCooldownTimer;
int guardianAttacks;
int guardianAttackDamage;
int enemyAttackDamage;
int enemyMeleeDamage;
Platform platform;
PlatformGenerator platGen;


ArrayList<Attack> attacks;
ArrayList<Enemy> enemies;





public void setup() {
  
  frameRate(60);

  w = a = s = d = j = false;

  petAlive = false;

  petCooldown = false;

  summon = false;

  attacking = false;

  camera = width/38;

  parallax = 0;

  summonCount = 0;

  guardianAttacks = 0;

  guardianAttackDamage = START_GUARDIAN_ATTACK;

  enemyAttackDamage = START_ENEMY_ATTACK;

  enemyMeleeDamage = START_ENEMY_MELEE;

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

  platGen = new PlatformGenerator();

  spawnEnemies();

  System.out.println(width/HEALTH_HEIGHT);

  System.out.println(width/HEALTH_WIDTH);

}

public void draw() {
  imageMode(CORNER);
  background(255);
  checkAttacking();

  if(!attacking && !guardian.colliding) {
    drawParallaxBackround();
  } else {
    background.draw(PARALLAX_NONE);
    platGen.draw(PARALLAX_NONE);
  }

  playerMove();
  if(petAlive) {
    pet.draw();
  }

  showHealthBar();
  unsummonPet();
  guardian.draw();
  attack();
  drawEnemies();
  enemyAttack();
  updateEnemies();
  bar();
  checkCooldowns();
  detectAttackCollision();
  updateAnchor();
  checkLanded();
  checkGrounded();
  guardianCollision();
  removeDeadEnemies();
}

public void showHealthBar() {
  pushMatrix();
  rectMode(CENTER);
  fill(0,0,0,100);
  rect(width/2 , height/2 - HEALTH_HEIGHT_SCALE * height/2, width/HEALTH_WIDTH, width/HEALTH_HEIGHT);
  fill(255 - HEALTH_COLOUR_SCALE * guardian.health, HEALTH_COLOUR_SCALE * guardian.health, 0);
  rect(width/2, height/2 - HEALTH_HEIGHT_SCALE * height/2, HEALTH_DECREASE_SCALE * guardian.health, width/HEALTH_HEIGHT);
  popMatrix();
}

public void spawnEnemies() {
  for(Platform platform : platGen.platforms) {
    if(platform.enemy == true) {
      enemies.add(new Enemy(ENEMY_ONE_PATH, platform.position.x, platform.position.y - 1.3f * platform.platformHeight, platform));
    }
  }
}

public void updateEnemies() {
  for(Enemy enemy : enemies ) {
    if(!attacking) {
      enemy.position.x = enemy.platform.position.x;
    }
  }
}


public void updateAnchor() {
  if(attacking) {
    guardian.anchorLeft = false;
    guardian.anchorRight = false;
    platGen.resetTransitionSpeed();
    background.resetTransitionSpeed();
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
    pushMatrix();
    rectMode(CORNER);
    fill(255,255,255, 100);
    rect(guardian.position.x - width/BAR_LEFT, guardian.position.y - width/BAR_ABOVE, width/BAR_WIDTH, width/BAR_HEIGHT);
    fill(255 -  2 * summonCount,2 * summonCount, 0);
    if(summonCount < width/BAR_WIDTH) {
      rect(guardian.position.x - width/BAR_LEFT, guardian.position.y - width/BAR_ABOVE, summonCount, width/BAR_HEIGHT);
    }
    fill(0,0,0,0);
    strokeWeight(3);
    rect(guardian.position.x + width/LINE_ONE, guardian.position.y - width/BAR_ABOVE, width/LINE_SUCCESS, width/BAR_HEIGHT);
    popMatrix();
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
    if(guardian.anchorRight && guardian.idle) {
        background.backgroundAnchorSpeed();
        platGen.anchorSpeed();
        parallax = PARALLAX_LEFT;
        guardian.velocity.x = camera;
    } else if (guardian.anchorLeft && guardian.idle) {
        background.backgroundAnchorSpeed();
        platGen.anchorSpeed();
        parallax = PARALLAX_RIGHT;
        guardian.velocity.x = -camera;
      } else if(guardian.right && guardian.anchorRight
        && !guardian.idle) {
          if(guardian.velocity.x == 0) {
            background.resetTransitionSpeed();
            platGen.resetTransitionSpeed();
          } else {
            background.cameraTransitionSpeed();
            platGen.cameraTransitionSpeed();
          }
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
        parallax = PARALLAX_LEFT;
    } else {
        parallax = PARALLAX_NONE;
        background.cameraTransitionSpeed();
        platGen.cameraTransitionSpeed();
    }
    background.draw(parallax);
    platGen.draw(parallax);
  }



//adjust enemis for parallax
public void positionEnemies(int velocity) {
    for(Enemy enemy : enemies) {
      enemy.position.x += velocity;
    }
}

public void positionPlatforms(int velocity) {
    for(Platform platform : platGen.platforms) {
      platform.position.x += velocity;
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

    if(summonCount >= LOWER_SUCCESS && summonCount <= UPPER_SUCCESS ) {
      summonPet();
      System.out.println("success");
    } else {
      petCooldown = false;
      System.out.println("fail");
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
    if(!guardian.colliding) {
      guardian.move(3, attacking);
      if(petAlive) {
        pet.move(3, attacking);
      }
    } else if (!guardian.right && guardian.colliding){
      guardian.colliding = false;
    }
  }

  if(a)  {
    if(!guardian.colliding) {
      guardian.move(4, attacking);
      if(petAlive) {
        pet.move(4, attacking);
      }
    } else if (guardian.right && guardian.colliding) {
      guardian.colliding = false;
    }
  }
      if(!w && !s && !d && !a) {
    guardian.move(5, attacking);
    if(petAlive)
      pet.move(5, attacking);
  }
  if(j) {
    guardian.colliding = false;
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
      guardianAttacks++;
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
    if(enemy.alive) {

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
      detectMeleeAttack(enemy);
    } else if(!enemy.right && guardian.position.x > enemy.position.x - width/ATTACK_DISTANCE) {
      enemy.attack = true;
      enemy.velocity.x = 0;
      detectMeleeAttack(enemy);
    } else if (dist(guardian.position.x, guardian.position.y, enemy.position.x, enemy.position.y) > width/2) {
      enemy.idle = true;
      enemy.attack = false;
    } else {
      enemy.idle = false;
    }
  } else {
      if(enemy.right && guardian.position.x < enemy.position.x + width/RANGED_ATTACK_DISTANCE) {
        enemy.attack = true;
        enemy.idle = false;
        enemy.velocity.x = 0;
      } else if(!enemy.right && guardian.position.x > enemy.position.x - width/RANGED_ATTACK_DISTANCE) {
        enemy.attack = true;
        enemy.idle = false;
        enemy.velocity.x = 0;
      } else {
        enemy.idle = true;
      }
    }

    //change magic numbers
    if(enemy.attack) {
      if(frameCount % 50 == 0) {
        if(enemy.ranged == 1) {
          if(enemy.right) {
            attacks.add(new Attack(enemy.position.x, enemy.position.y + width/ARROW_HEIGHT_ADJUST,
              guardian.position.x, guardian.position.y + width/GUARDIAN_HEIGHT/2, true, 1));
          } else {
            attacks.add(new Attack(enemy.position.x, enemy.position.y + width/ARROW_HEIGHT_ADJUST,
              guardian.position.x, guardian.position.y + width/GUARDIAN_HEIGHT/2, false, 1));
          }
        } else if(enemy.ranged == 2) {
          if(enemy.right) {
            attacks.add(new Attack(enemy.position.x, enemy.position.y,
              guardian.position.x, calculateAimHeight(enemy), true, 2));
          } else {
            attacks.add(new Attack(enemy.position.x, enemy.position.y,
              guardian.position.x, calculateAimHeight(enemy), false, 2));
          }
        }
      }
    }
      if(!enemy.idle) {
      enemy.attack();
      }
    }
  }
}

public void detectMeleeAttack(Enemy enemy) {
  if(guardian.position.y + width/GUARDIAN_HEIGHT/2 > enemy.position.y &&
     guardian.position.y < enemy.position.y + width/GUARDIAN_HEIGHT) {
       guardian.health -= enemyMeleeDamage;
     }
}





public float calculateAimHeight(Enemy enemy) {
  float maxLaunchHeight = height - guardian.position.y;

  float enemyGuardianDistance = dist(guardian.position.x, guardian.position.y, enemy.position.x, enemy.position.y);

  float optimalHeight = height - 0.85f * enemyGuardianDistance;

  return optimalHeight;

}

public void checkGrounded() {
  if(guardian.position.y + guardian.velocity.y >= ground) {
    guardian.grounded = true;
    guardian.position.y = ground;
  }
}


public void checkLanded() {
    float guardianVertPosition = guardian.position.y + width/GUARDIAN_FEET;
    float guardianHoriPosition = guardian.position.x + width/(GUARDIAN_WIDTH);
    int i = 0;

    for(Platform platform : platGen.platforms) {

      // pushMatrix();
      //   stroke(255,0,0);
      //   line(platform.position.x, height, platform.position.x, 0);
      //   line(platform.position.x + platform.platformWidth, height, platform.position.x + platform.platformWidth, 0);
      //   line(guardian.position.x, height, guardian.position.x, 0);
      //   line(guardianHoriPosition, height, guardianHoriPosition, 0);
      //   line(0, guardianVertPosition, width,  guardianVertPosition );
      // popMatrix();


        if(guardianVertPosition >= platform.position.y && guardian.position.y + width/GUARDIAN_FEET/2 < platform.position.y) {
          if(guardianHoriPosition > platform.position.x && guardian.position.x < platform.position.x + platform.platformWidth) {
            guardian.grounded = true;
            guardian.position.y = platform.position.y - width/GUARDIAN_FEET;
            i++;
          }
        }
      }
      if (i == 0) {
        guardian.grounded = false;
      }
    }



    //checks for whether an enemy is attacking to stop parallax mode for combat
    public void checkAttacking() {

      int i = 0;
      for(Enemy enemy : enemies) {
        if(!enemy.idle) {
          attacking = true;
          i++;
        }
      }
      if(i == 0) {
        attacking = false;
      }
    }

public void guardianCollision() {

  float guardWidth = width/GUARDIAN_WIDTH;
  float guardHeight = width/GUARDIAN_FEET;

  int platIndex = 0;

  for (Platform platform : platGen.platforms) {

    //try out simple rectangle collision;

    if (guardian.position.x + guardWidth + guardian.velocity.x > platform.position.x &&
        guardian.position.x + guardian.velocity.x < platform.position.x + platform.platformWidth &&
        guardian.position.y + guardHeight > platform.position.y &&
        guardian.position.y < platform.position.y + platform.platformHeight) {
          guardian.velocity.x = -guardian.velocity.x;
          guardian.colliding = true;
          platIndex = platGen.platforms.indexOf(platform);
          if(guardian.right) {
            guardian.position.x = platform.position.x - guardWidth;
          } else {
            guardian.position.x = platform.position.x + platform.platformWidth;
          }
        }

    if (guardian.position.x + guardWidth > platform.position.x &&
        guardian.position.x < platform.position.x + platform.platformWidth &&
        guardian.position.y + guardHeight + guardian.velocity.y > platform.position.y &&
        guardian.position.y + guardian.velocity.y < platform.position.y + platform.platformHeight) {
          guardian.velocity.y = 0;
    }
  }

  if(guardian.colliding) {

    Platform platform = platGen.platforms.get(platIndex);

    if(!(guardian.position.x + guardWidth + guardian.velocity.x > platform.position.x &&
          guardian.position.x + guardian.velocity.x < platform.position.x + platform.platformWidth &&
          guardian.position.y + guardHeight > platform.position.y &&
          guardian.position.y < platform.position.y + platform.platformHeight)) {
            guardian.colliding = false;
          }
    }
}




//detect whether guardian attack hits enemy
//simplified to point rectangle collision
public void detectAttackCollision() {
  for (Attack attack : new ArrayList<Attack>(attacks)) {
    float attackX = attack.position.x + attack.attackRight.width/2;
    float attackY = attack.position.y + attack.attackRight.height/2;



    if(attack.attackType == 0) {

      for(Enemy enemy : new ArrayList<Enemy>(enemies)) {

        float enemyX = enemy.position.x + width/GUARDIAN_WIDTH;
        float enemyY = enemy.position.y + width/GUARDIAN_FEET;

        if( attackX < enemyX && attackX > enemy.position.x ) {
          if(attackY < enemyY && attackY > enemy.position.y) {
              enemy.health -= guardianAttackDamage;
              attacks.remove(attack);
              guardianAttacks--;
          }
        }
      }
    } else {

        float guardianX = guardian.position.x + width/GUARDIAN_WIDTH;
        float guardianY = guardian.position.y + width/GUARDIAN_FEET;

          if(attackX < guardianX && attackX > guardian.position.x ) {

            if(attackY < guardianY && attackY > guardian.position.y) {
              guardian.health -= enemyAttackDamage;
              attacks.remove(attack);
            }
          }
    }
  }
}

public void removeDeadEnemies() {
    for(Enemy enemy : new ArrayList<Enemy>(enemies)) {
      if(enemy.health <= 0) {
        enemy.attack = false;
        enemy.alive = false;
        if(enemy.playDead) {
          enemies.remove(enemy);
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
  final int ANIM_TIME = 100;

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
    this.deltaTime = ANIM_TIME;
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
  public void draw(PVector position, int health) {
    if(millis() > prevTime + deltaTime) {
      currentFrame++;
      if(currentFrame > TOTAL_FRAMES - 1) {
        animated = true;
        currentFrame = 0;
      }
      prevTime = millis();
    }

    pushMatrix();

    image(animation.get(currentFrame), position.x, position.y );

    if(health < 15) {
    tint(255, 0, 0, 100);
    image(animation.get(currentFrame), position.x, position.y );
    tint(255,255);
    }

    popMatrix();
  }

  public void drawOnce(PVector position, int health) {
    if(millis() > prevTime + deltaTime) {
      if(!animated) {
        currentFrame++;
      }
      if(currentFrame > TOTAL_FRAMES - 1) {
        animated = true;
        currentFrame--;
      }
      prevTime = millis();
    }
    pushMatrix();

    image(animation.get(currentFrame), position.x, position.y );
    tint(255,0,0,100);
    image(animation.get(currentFrame), position.x, position.y );
    tint(255,255);
    popMatrix();
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
    arrowRight.resize(ATTACK_SIZE/2, 0);
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

  public void draw(){
    update();
    display();
  }
}
//Background class that loads in all layers for parallax
public class Background {

  final String PNG = ".png";
  final int CAMERA = width/38;
  final int ANCHOR = width/50;
  final int BASE = 80;

  final int BASE_MULTIPLIER = 2;
  final int CAMERA_MULTIPLIER = 5;


  int startX = 0;
  int startY = 0;
  int resize = height + height/4;
  int layerTotal;
  String path;
  int cameraType;

  boolean reset;

  ArrayList<Layer> layers;

  //Pass in background path and number of layers
  Background(String path, int layerTotal) {
    this.path = path;
    this.layerTotal = layerTotal;
    this.layers = new ArrayList<Layer>();
    initialiseLayers();
    resizeLayers();
    this.cameraType = BASE;
  }

  //add all layers into the ArrayList of layers
  public void initialiseLayers() {
    for(int i = 0; i < layerTotal; i ++) {
      layers.add(new Layer(path + i + PNG, startX, startY, i*2));
    }
  }

  //transition speed of layers set to default
  public void resetTransitionSpeed() {
    if(cameraType != BASE) {
      for(int i = 0; i < layerTotal; i++) {
          layers.get(i).transition = i*BASE_MULTIPLIER;
      }
      cameraType = BASE;
    }
  }

  //increase the transition speed for camera change
  public void cameraTransitionSpeed() {
    int split = CAMERA/(layerTotal);
    if(cameraType != CAMERA) {
      for(int i = 0; i < layerTotal; i++) {
        layers.get(i).transition = i*split;
      }
      cameraType = CAMERA;
    }
  }

  public void backgroundAnchorSpeed() {
    int split = ANCHOR/(layerTotal);
    if(cameraType != ANCHOR) {
      for(int i = 0; i < layerTotal; i++) {
        layers.get(i).transition = i*split;
      }
        cameraType = ANCHOR;
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
  final int DIE_RESIZE_1 = width/17;

  final int IDLE_RESIZE_2 = width/25;
  final int ATTACK_RESIZE_2 = width/24;
  final int JUMP_RESIZE_2 = width/20;
  final int RUN_RESIZE_2 = width/25;
  final int DIE_RESIZE_2 = width/17;

  final int IDLE_RESIZE_3 = width/20;
  final int ATTACK_RESIZE_3 = width/20;
  final int JUMP_RESIZE_3 = width/15;
  final int RUN_RESIZE_3 = width/18;
  final int DIE_RESIZE_3 = width/25;

  final int IDLE_RESIZE_4 = width/20;
  final int ATTACK_RESIZE_4 = width/17;
  final int JUMP_RESIZE_4 = width/15;
  final int RUN_RESIZE_4 = width/19;
  final int DIE_RESIZE_4 = width/25;

  final int ENEMY_SPEED = 7;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;
  final int ENEMY_WIDTH = 20;

  final int BOW = 1;
  final int ROCK = 2;
  final int MELEE = 0;

  int ranged;
  Platform platform;


  Enemy(String path, float x, float y, Platform platform) {
    super(path, x ,y);
    this.ranged = checkType(path);
    this.grounded = true;
    this.platform = platform;
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
    resizeDie(path);
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
  public void resizeDie(String path) {
    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(DIE_LEFT).animation) {
        frame.resize(DIE_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(DIE_RIGHT).animation) {
        frame.resize(DIE_RESIZE_1, 0);
      }
    } else if(path.equals(ENEMY_TWO_PATH)) {
        for(PImage frame : animations.get(DIE_LEFT).animation) {
          frame.resize(DIE_RESIZE_2, 0);
        }
        for(PImage frame : animations.get(DIE_RIGHT).animation) {
          frame.resize(DIE_RESIZE_2, 0);
        }
    } else if(path.equals(ENEMY_THREE_PATH)) {
        for(PImage frame : animations.get(DIE_LEFT).animation) {
          frame.resize(DIE_RESIZE_3, 0);
        }
        for(PImage frame : animations.get(DIE_RIGHT).animation) {
          frame.resize(DIE_RESIZE_3, 0);
        }
    } else if(path.equals(ENEMY_FOUR_PATH)) {
        for(PImage frame : animations.get(DIE_LEFT).animation) {
          frame.resize(DIE_RESIZE_4, 0);
        }
        for(PImage frame : animations.get(DIE_RIGHT).animation) {
          frame.resize(DIE_RESIZE_4, 0);
        }
    }

  }

  //attack and pursue guardian
  public void attack() {
    if(!attack && ranged ==0) {
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
  final String DIE_LEFT = "dieLeft/";

  String idleRightPath;
  String idleLeftPath;
  String runRightPath;
  String runLeftPath;
  String jumpRightPath;
  String jumpLeftPath;
  String attackRightPath;
  String attackLeftPath;
  String dieRightPath;
  String dieLeftPath;


  float GROUND = height - height/6.85f;
  final int ENTITY_SPEED = 10;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 3;
  final int HEALTH = 100;

  boolean right;
  boolean idle;
  boolean jump;
  boolean grounded;
  boolean attack;
  boolean anchorRight;
  boolean anchorLeft;
  boolean alive;
  boolean colliding;
  boolean playDead;

  int health;

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
    this.dieRightPath = path + DIE_RIGHT;
    this.dieLeftPath = path + DIE_LEFT;

    initialiseAnimations();

    this.right = true;
    this.idle = true;
    this.jump = false;
    this.attack = false;
    this.grounded = true;

    this.anchorLeft = false;
    this.anchorRight = false;

    this.health = HEALTH;
    this.alive = true;
    this.playDead = false;

    this.colliding = false;
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
    Animation dieRight = new Animation(dieRightPath);
    Animation dieLeft = new Animation(dieLeftPath);

    animations.put(IDLE_RIGHT, idleRight);
    animations.put(IDLE_LEFT, idleLeft);
    animations.put(RUN_RIGHT, runRight);
    animations.put(RUN_LEFT, runLeft);
    animations.put(JUMP_RIGHT, jumpRight);
    animations.put(JUMP_LEFT, jumpLeft);
    animations.put(ATTACK_RIGHT, attackRight);
    animations.put(ATTACK_LEFT, attackLeft);
    animations.put(DIE_RIGHT, dieRight);
    animations.put(DIE_LEFT, dieLeft);
  }


  //add momentum to entites and friction
  //gravity also added to entity movement
  public void update() {
    if(velocity.x > 1 || velocity.x < -1) {
      velocity.x *= 0.7f;
    } else {
      velocity.x = 0;
    }

    if(!grounded) {
      velocity.y += GRAVITY;
    } else {
      velocity.y = 0;
      this.jump = false;
    }




    position.add(velocity);
  }

  //Display method used to show the correct animation
  public void display() {

    if(alive) {
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
    } else {

      if(!playDead) {
        if(right) {
          animateOnce(DIE_RIGHT);
          if(animations.get(DIE_RIGHT).animated) {
            playDead = true;
          }
        } else {
          animateOnce(DIE_LEFT);
          if(animations.get(DIE_LEFT).animated) {
            playDead = true;
          }
        }
      }
    }
  }

  //play an animation
  public void animate(String animation) {
    animations.get(animation).draw(position, this.health);
  }

  public void animateOnce(String animation) {
    animations.get(animation).drawOnce(position, this.health);
  }

  //draw
  public void draw() {
    update();
    display();
  }

  public void move(int i, boolean b){
  }

  public int getAnchorRightPos() {
    return width/3;
  }

  public int getAnchorLeftPos() {
    return width/5;
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
  final int GUARDIAN_SPEED = width/150;
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
      this.anchorLeftPos =  width/5;
      resize();
      System.out.println(GUARDIAN_SPEED);
  }

  //get anchors
  public boolean getAnchorRight() {
    return anchorRight;
  }

  public boolean getAnchorLeft() {
    return anchorLeft;
  }

  public int getAnchorRightPos() {
    return anchorRightPos;
  }

  public int getAnchorLeftPos() {
    return anchorLeftPos;
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
      if(velocity.x < 2 * GUARDIAN_SPEED) {
        velocity.x += GUARDIAN_SPEED;
      }
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

    if(!this.colliding) {
      if(position.x + width/GUARDIAN_WIDTH <= displayWidth) {
        if(velocity.x < 2 * GUARDIAN_SPEED)
          velocity.x += GUARDIAN_SPEED;
        } else{
          velocity.x = -GUARDIAN_SPEED;
        }
    } else if(!right && this.colliding) {
      this.colliding = false;
    }

    right = true;
    idle = false;
  }

  //basic move left
  public void moveLeft() {

    if(!this.colliding) {

      if(position.x >= 0 ) {
        if(velocity.x > 2 * - GUARDIAN_SPEED)
          velocity.x -= GUARDIAN_SPEED;
      } else {
        velocity.x = GUARDIAN_SPEED;
      }
    } else if(right && this.colliding) {
        this.colliding = false;
    }

    right = false;
    idle = false;
  }

  //parallax move left
  public void moveLeftParallax() {
    if(position.x > anchorLeftPos && !anchorLeft) {
      if(velocity.x > 2 * - GUARDIAN_SPEED) {
        velocity.x -= GUARDIAN_SPEED;
      }
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
    if(!jump) {
      velocity.y = -JUMP_SPEED;
      jump = true;
      grounded = false;
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
  PVector velocity;
  PImage tile;
  boolean enemy;
  float transition;
  int platformWidth;
  int platformHeight;
//
  final int RESIZE = 10;

  Platform( float x, float y, float transition, boolean enemy) {
    this.tile = loadImage(imgPath);
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.tile.resize(width/RESIZE, 0);
    this.platformWidth = tile.width;
    this.platformHeight = tile.height;
    this.transition = transition;
    this.enemy = enemy;
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

  final int PLATFORM_NUM = 100;

  final int BLOCK_ONE = 1;
  final int BLOCK_TWO = 2;
  final int BLOCK_FIVE = 5;
  final int BLOCK_MAX = 15;
  final float PERCENT_FORTY = 0.4f;
  final float PERCENT_SEVENTY = 0.7f;
  final float PERCENT_NINETY = 0.9f;
  final float PERCENT_TEN = 0.1f;

  final int CAMERA_SPEED = 34;
  final int ANCHOR_SPEED = 85;
  final int BASE_SPEED = 80;

  ArrayList<Platform> platforms;

  int numberOfPlatforms;
  int newPlatformHeight;
  int newPlatformWidth;

  int cameraType;

  PlatformGenerator() {
   this.platforms  = new ArrayList<Platform>();
    this.numberOfPlatforms = PLATFORM_NUM;
    generatePlatforms();
    this.cameraType = BASE_SPEED;
  }

  public void generatePlatforms() {

    platforms.add(new Platform(width, height - height/5, width/BASE_SPEED, true));
    this.newPlatformWidth = platforms.get(0).platformWidth;
    this.newPlatformHeight = platforms.get(0).platformHeight*2;

    int last;
    float ground = height - height/6.85f;

    for(int i = 0; i < PLATFORM_NUM; i++) {

      last = platforms.size() - 1;

      float randomPlatforms = random(0, 1);
      float randomPlatformHeight = random(platforms.get(last).position.y - newPlatformHeight, ground);
      float positionX = platforms.get(last).position.x + 2*newPlatformWidth;

      int numPlat = 0;

      if(randomPlatforms <= PERCENT_FORTY) {
          numPlat = BLOCK_ONE;
      } else if (randomPlatforms > PERCENT_FORTY && randomPlatforms <= PERCENT_SEVENTY) {
          numPlat = BLOCK_TWO;
      } else if (randomPlatforms > PERCENT_SEVENTY  && randomPlatforms <= PERCENT_NINETY) {
          numPlat = BLOCK_FIVE;
      } else {
        numPlat = BLOCK_MAX;
      }

      for(int j = 0; j < numPlat; j++) {
        if (numPlat == BLOCK_MAX && j == numPlat - 1) {
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, true));
        } else {
          platforms.add(new Platform(positionX + j*this.newPlatformWidth, randomPlatformHeight, width/BASE_SPEED, false));
        }
      }
    }
  }

  public void anchorSpeed() {
    if(cameraType == BASE_SPEED || cameraType == CAMERA_SPEED) {
      for(Platform platform : platforms) {
        platform.transition = width/ANCHOR_SPEED;
      }
    cameraType = ANCHOR_SPEED;
    }
  }

  public void resetTransitionSpeed() {
    if(cameraType == ANCHOR_SPEED || cameraType == CAMERA_SPEED) {
      for(Platform platform : platforms) {
        platform.transition = width/BASE_SPEED;
      }
    cameraType = BASE_SPEED;
    }
  }

  public void cameraTransitionSpeed() {
    if(cameraType == ANCHOR_SPEED || cameraType == BASE_SPEED) {
      for(Platform platform : platforms) {
        platform.transition = width/CAMERA_SPEED;
      }
      cameraType = CAMERA_SPEED;
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
