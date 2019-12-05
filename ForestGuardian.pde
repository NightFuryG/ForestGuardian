
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

final float GROUND_PROP = 6.85;
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



void setup() {
  fullScreen();

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

void draw() {
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
void checkAttacking() {
  for(Enemy enemy : enemies) {
    if(!enemy.idle) {
      attacking = true;
    }
  }
  if(enemies.size() == 0) {
    attacking = false;
  }
}

void updateAnchor() {
  if(attacking) {
    guardian.anchorLeft = false;
    guardian.anchorRight = false;
  }
}

//mirrors pet movement when travelling
void updatePet() {
  pet.position.x = guardian.position.x;
  pet.position.y = guardian.position.y;
}

/*
  Pet Summoning Bar
  When holding 1 to summon - stop the bar in the two lines
  if target missed wolf cool down activated
*/
void bar() {
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
void unsummonPet() {
  if(millis() > petTimer +  PET_MAX_LIFE) {
    petAlive = false;
    petTimer = millis();
  }
}

//check ability cooldowns to see if can be used again
void checkCooldowns() {
  if(millis() > petCooldownTimer + PET_COOLDOWN_TIME) {
    petCooldown = true;
    petCooldownTimer = millis();
  }
}

//summon pet
void summonPet() {
  petAlive = true;
  petTimer = millis();
}

//parallax method for adjusting guardian, enemis and background
//uses a sliding window with in play area and uses hard and soft anchor points
void drawParallaxBackround() {
  if(!attacking) {
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
    platGen.draw(parallax);
  }
}



//adjust enemis for parallax
void positionEnemies(int velocity) {
    for(Enemy enemy : enemies) {
      enemy.velocity.x = velocity;
    }
}

void positionPlatforms(int velocity) {
    for(Platform platform : platGen.platforms) {

    }
}

// movement and abilites
void keyPressed() {
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
void keyReleased() {
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
void playerMove() {
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
void mousePressed() {
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
void attack() {
  drawAttack();
  removeGuardianAttack();
}

//remove missed attacks
void removeGuardianAttack() {
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
void drawAttack() {
  for(Attack attack : attacks) {
    attack.draw();
  }
}

//enemy detection distance
//enemy will pursue guardian and attack if close enough
void enemyAttack() {
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


float calculateAimHeight(Enemy enemy) {
  float maxLaunchHeight = height - guardian.position.y;

  float enemyGuardianDistance = dist(guardian.position.x, guardian.position.y, enemy.position.x, enemy.position.y);

  float optimalHeight = height - 0.85 * enemyGuardianDistance;

  return optimalHeight;

}


//detect whether guardian attack hits enemy
//simplified to point rectangle collision
void detectAttackCollision() {
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
void drawEnemies() {
  for(Enemy enemy : enemies) {
    enemy.draw();
  }
}
