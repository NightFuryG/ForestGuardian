
final int GUARDIAN_WIDTH = 24;
final int ATTACK_WIDTH = 40;
final int GUARDIAN_HEIGHT = 20;
final int GUARDIAN_FEET = 22;
final int ATTACK_DISTANCE = 40;
final float RANGED_ATTACK_DISTANCE = 1.6;

final int BAR_WIDTH = 20;
final int BAR_LEFT = 150;
final int BAR_HEIGHT = 100;
final int BAR_ABOVE = 80;

final int LINE_ONE = 30;
final int LINE_TWO = 100;
final int LINE_HEIGHT = 100;
final int LINE_SUCCESS = 200;
final int LOWER_SUCCESS = 65;
final int UPPER_SUCCESS = 85;

final int ENEMY_PARALLAX_POSITION = 20;

final float ONE_TWO_SPAWN = 1.3;
final float THREE_FOUR_SPAWN = 1.4;

final int START_GUARDIAN_ATTACK = 25;
final int START_ENEMY_ATTACK = 10;
final int START_ENEMY_MELEE = 1;
final int START_PET_MELEE = 1;

final int PET_MAX_LIFE = 10000;
final int SUMMON_INCREASE = 3;
final int PET_COOLDOWN_TIME = 20000;

final int CAMERA_SPEED = 50;
final int PARALLAX_RIGHT = 1;
final int PARALLAX_LEFT = 2;
final int PARALLAX_NONE = 0;
final int CAMERA_ANCHOR = 10;

final float HEALTH_COLOUR_SCALE = 2.55;
final float HEALTH_HEIGHT_SCALE = 0.925;
final int HEALTH_DECREASE_SCALE = 4;
final int HEALTH_HEIGHT = 41;
final float HEALTH_WIDTH = 4.2;

final int WOLF_IMAGE_RESIZE = 100;

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
final String WOLF_CD = "animations/pet/1/idleRight/0.png";

public final float GROUND_PROP = 6.85;
final float ENT_GROUND_PROP = 6;
final float GROUND_TILE = 12;


Background background;
Entity guardian;
Entity pet;
PImage wolfAbilityImg;

int level;


boolean w, a, s, d, j;
boolean petAlive;
boolean summon;
boolean petCooldown;
boolean attacking;
boolean petTargetChosen;
boolean doubleJump;
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
int petMeleeDamage;
Platform platform;
PlatformGenerator platGen;
ArrayList<Attack> attacks;
ArrayList<Enemy> enemies;





void setup() {
  fullScreen();
  frameRate(60);

  w = a = s = d = j = false;

  petAlive = false;

  petCooldown = false;

  petTargetChosen = false;

  summon = false;

  attacking = false;

  doubleJump = false;

  camera = width/38;

  parallax = 0;

  level = 1;

  summonCount = 0;

  guardianAttacks = 0;

  wolfAbilityImg = loadImage(WOLF_CD);
  wolfAbilityImg.resize(WOLF_IMAGE_RESIZE, 0);

  guardianAttackDamage = START_GUARDIAN_ATTACK;

  enemyAttackDamage = START_ENEMY_ATTACK;

  enemyMeleeDamage = START_ENEMY_MELEE;

  petMeleeDamage = START_PET_MELEE;

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

  platGen = new PlatformGenerator(level);

  spawnEnemies();

  System.out.println(width/HEALTH_HEIGHT);

  System.out.println(width/HEALTH_WIDTH);

}

void draw() {
  imageMode(CORNER);
  background(255);
  checkAttacking();

  if(!attacking && !guardian.colliding && !guardian.dashing) {
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
  showEnergyBar();
  showWolfCooldown();
  regenEnergy();
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
  stopEnemiesFalling();
  removeDeadEnemies();
  stopPetFalling();
  setIdleOffScreen();
  //drawPlatformEdges();
}

void showHealthBar() {
  pushMatrix();
  rectMode(CENTER);
  fill(0,0,0,100);
  rect(width/2 - width/4, height/2 - HEALTH_HEIGHT_SCALE * height/2, width/HEALTH_WIDTH, width/HEALTH_HEIGHT);
  fill(255 - HEALTH_COLOUR_SCALE * guardian.health, HEALTH_COLOUR_SCALE * guardian.health, 0);
  rect(width/2 - width/4, height/2 - HEALTH_HEIGHT_SCALE * height/2, HEALTH_DECREASE_SCALE * guardian.health, width/HEALTH_HEIGHT);
  rectMode(CORNER);
  popMatrix();
}

void showEnergyBar() {
  pushMatrix();
  rectMode(CENTER);
  fill(0,0,0,100);
  rect(width/2 + width/4, height/2 - HEALTH_HEIGHT_SCALE * height/2, width/HEALTH_WIDTH, width/HEALTH_HEIGHT);
  fill(255 - HEALTH_COLOUR_SCALE * guardian.energy, 0,HEALTH_COLOUR_SCALE * guardian.energy);
  rect(width/2 + width/4, height/2 - HEALTH_HEIGHT_SCALE * height/2, HEALTH_DECREASE_SCALE * guardian.energy, width/HEALTH_HEIGHT);
  rectMode(CORNER);
  noFill();
  popMatrix();
}

void showWolfCooldown() {

  pushMatrix();
  if(!petCooldown) {
    tint(100, 50);

  }
  image(wolfAbilityImg, width/2 - wolfAbilityImg.width/2, wolfAbilityImg.height/4);

  noTint();
  popMatrix();

}

void regenEnergy() {
  if(frameCount % 10 == 0) {
    if(guardian.energy < 100) {
      guardian.energy++;
    }
  }
}

void spawnEnemies() {
  for(Platform platform : platGen.platforms) {
    if(platform.enemy == true) {

      float r = random (0,1);

      if(r < 0.25) {
        enemies.add(new Enemy(ENEMY_ONE_PATH, platform.position.x, platform.position.y - ONE_TWO_SPAWN * platform.platformHeight, platform));
      } else if ( r >= 0.25 && r < 0.5) {
        enemies.add(new Enemy(ENEMY_TWO_PATH, platform.position.x, platform.position.y - ONE_TWO_SPAWN * platform.platformHeight, platform));
      } else if (r >= 0.5 && r < 0.75) {
        enemies.add(new Enemy(ENEMY_THREE_PATH, platform.position.x, platform.position.y - THREE_FOUR_SPAWN * platform.platformHeight, platform));
      } else {
        enemies.add(new Enemy(ENEMY_FOUR_PATH, platform.position.x, platform.position.y -  THREE_FOUR_SPAWN * platform.platformHeight, platform));
      }

    }
  }
}

void updateEnemies() {
  for(Enemy enemy : enemies ) {
    if(!attacking) {
      enemy.position.x = enemy.platform.position.x;
    }
  }
}




void updateAnchor() {
  if(attacking) {
    guardian.anchorLeft = false;
    guardian.anchorRight = false;
    platGen.resetTransitionSpeed();
    background.resetTransitionSpeed();
  }
}

//mirrors pet movement when travelling
void updatePet() {
  if(!attacking) {
    pet.position.x = guardian.position.x;
    pet.position.y = guardian.position.y;
    pet.attack = false;
    pet.onRightEdge = false;
    pet.onLeftEdge = false;

  } else {
    if(!petTargetChosen) {
      for(Enemy enemy : enemies) {
        if(!enemy.idle) {
          pet.target = enemy;
          petTargetChosen = true;
        }
      }
    }
  }
}



void petAttack() {
  if(attacking && petTargetChosen) {
    if(pet.target != null) {

      if(!pet.attack) {
        if(pet.position.x < pet.target.position.x) {
          pet.right = true;
        } else {
          pet.right = false;
        }
      }

      if(pet.right && pet.target.position.x + (width/GUARDIAN_WIDTH)/2 < pet.position.x + width/GUARDIAN_WIDTH + width/ATTACK_DISTANCE/4) {
        pet.attack = true;
        pet.idle = false;
        pet.velocity.x = 0;
        petMeleeDamage();
      } else if(!pet.right && pet.target.position.x + (width/GUARDIAN_WIDTH)/2 > pet.position.x - width/ATTACK_DISTANCE/4) {
        pet.attack = true;
        pet.idle = false;
        pet.velocity.x = 0;
        petMeleeDamage();
       } else {
        pet.idle = false;
      }
      if(!pet.idle) {
        pet.attackTarget();
      }
    }
  }
}

void petMeleeDamage() {
  pet.target.health -= petMeleeDamage;
}

/*
  Pet Summoning Bar
  When holding 1 to summon - stop the bar in the two lines
  if target missed wolf cool down activated
*/
void bar() {
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
    strokeWeight(1);
    rect(guardian.position.x + width/LINE_ONE, guardian.position.y - width/BAR_ABOVE, width/LINE_SUCCESS, width/BAR_HEIGHT);
    strokeWeight(1);
    popMatrix();
  }
}

//pet is unsummoned after the duration has finished
void unsummonPet() {
  if(millis() > petTimer +  PET_MAX_LIFE) {
    petAlive = false;
    petTargetChosen = false;
    pet.target = null;
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
  pet.position.x = guardian.position.x;
  pet.position.y = guardian.position.y;

  petAlive = true;

  petTimer = millis();
}



//parallax method for adjusting guardian, enemis and background
//uses a sliding window with in play area and uses hard and soft anchor points
void drawParallaxBackround() {
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
void positionEnemies(int velocity) {
    for(Enemy enemy : enemies) {
      enemy.position.x += velocity;
    }
}

void positionPlatforms(int velocity) {
    for(Platform platform : platGen.platforms) {
      platform.position.x += velocity;
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

    if(summonCount >= LOWER_SUCCESS && summonCount <= UPPER_SUCCESS ) {
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
    j = false;
    guardian.colliding = false;
    guardian.move(6, attacking);
    if(petAlive) {
      pet.move(6, attacking);
    }
  }


  if(petAlive) {
    updatePet();
    petAttack();
  }
}

//guardian attack
// fires and orients the attack depending on mouse click and direction
void mousePressed() {
  if(mouseButton == LEFT) {
    guardian.attack = true;
    if(guardianAttacks == 0) {
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

boolean checkEnemyOnScreen(Enemy enemy) {
  if( enemy.position.x > width - width/10) {
    return false;
  }
  return true;
}

//enemy detection distance
//enemy will pursue guardian and attack if close enough
void enemyAttack() {
  for(Enemy enemy : enemies) {
    if(enemy.alive) {

    if(!enemy.attack) {
      if(guardian.position.x < enemy.position.x) {
        enemy.right = false;
      } else {
        enemy.right = true;
      }
    }

    if(checkEnemyOnScreen(enemy)) {
      if(enemy.ranged == 0) {
        if(enemy.right && guardian.position.x < enemy.position.x + width/ATTACK_DISTANCE) {
          enemy.attack = true;
          enemy.idle = false;
          enemy.velocity.x = 0;
          detectMeleeAttack(enemy);
        } else if(!enemy.right && guardian.position.x > enemy.position.x - width/ATTACK_DISTANCE) {
          enemy.attack = true;
          enemy.idle = false;
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
          } else if (dist(guardian.position.x, guardian.position.y, enemy.position.x, enemy.position.y) > width/10) {
            enemy.idle = true;
            enemy.attack = false;
          } else {
            enemy.idle = false;
          }
        }
    }



      //change magic numbers
      if(enemy.attack) {
        if(frameCount % 50 == 0) {
          if(!petAlive) {
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
                attacks.add(new Attack(enemy.position.x, enemy.position.y + width/ARROW_HEIGHT_ADJUST,
                  guardian.position.x, calculateAimHeight(enemy), true, 2));
              } else {
                attacks.add(new Attack(enemy.position.x, enemy.position.y + width/ARROW_HEIGHT_ADJUST,
                  guardian.position.x, calculateAimHeight(enemy), false, 2));
              }
            }
          } else {
            if(enemy.ranged == 1) {
              if(enemy.right) {
                attacks.add(new Attack(enemy.position.x, enemy.position.y + width/ARROW_HEIGHT_ADJUST,
                  pet.position.x, pet.position.y + width/GUARDIAN_HEIGHT/2, true, 1));
              } else {
                attacks.add(new Attack(enemy.position.x, enemy.position.y + width/ARROW_HEIGHT_ADJUST,
                  pet.position.x, pet.position.y + width/GUARDIAN_HEIGHT/2, false, 1));
              }
            } else if(enemy.ranged == 2) {
              if(enemy.right) {
                attacks.add(new Attack(enemy.position.x, enemy.position.y + width/ARROW_HEIGHT_ADJUST,
                  pet.position.x, calculateAimHeight(enemy), true, 2));
              } else {
                attacks.add(new Attack(enemy.position.x, enemy.position.y + width/ARROW_HEIGHT_ADJUST,
                  pet.position.x, calculateAimHeight(enemy), false, 2));
              }
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

void detectMeleeAttack(Enemy enemy) {
  if(guardian.position.y + width/GUARDIAN_FEET/3 > enemy.position.y &&
     guardian.position.y < enemy.position.y + width/GUARDIAN_FEET/3) {
       guardian.health -= enemyMeleeDamage;
     }
}

float calculateAimHeight(Enemy enemy) {
  float enemyGuardianDistance = 0;
  float optimalHeight = 0;
  float heightDiff = 0;

  if(!petAlive) {
      enemyGuardianDistance = dist(guardian.position.x, guardian.position.y, enemy.position.x, enemy.position.y);
      heightDiff = guardian.position.y - enemy.position.y;
      optimalHeight = guardian.position.y + 1.5 *  heightDiff -  0.5 * enemyGuardianDistance;

  } else {
      enemyGuardianDistance = dist(pet.position.x, pet.position.y, enemy.position.x, enemy.position.y);
      heightDiff = pet.position.y - enemy.position.y;
      optimalHeight = guardian.position.y + 1.5 * heightDiff -  0.5 * enemyGuardianDistance;
  }
    return optimalHeight;

}

void checkGrounded() {
  if(guardian.position.y + guardian.velocity.y >= ground) {
    guardian.grounded = true;
    guardian.position.y = ground;
  }
}

void setIdleOffScreen() {
  for(Enemy enemy : enemies) {
    if( enemy.position.x > width || enemy.position.x < 0) {
        enemy.idle =true;
    }
  }
}

void checkLanded() {
    float guardianVertPosition = guardian.position.y + width/GUARDIAN_FEET;
    float guardianHoriPosition = guardian.position.x + width/(GUARDIAN_WIDTH);

    int i = 0;

    for(Platform platform : platGen.platforms) {

        if(guardianVertPosition >= platform.position.y && guardian.position.y + width/GUARDIAN_FEET/2 < platform.position.y) {
          if(guardianHoriPosition > platform.position.x && guardian.position.x < platform.position.x + platform.platformWidth) {
            guardian.grounded = true;
            guardian.position.y = platform.position.y - width/GUARDIAN_FEET;
            if((pet.onRightEdge || pet.onLeftEdge) && pet.position.y != guardian.position.y)  {
              pet.position.x = guardian.position.x;
              pet.position.y = guardian.position.y;
            }
            i++;
          }
        }
      }
      if (i == 0) {
        guardian.grounded = false;
      }
    }

void stopEnemiesFalling() {

  if(attacking){

    for(Enemy enemy : enemies) {

      if(!enemy.idle) {

        float enemyVertPosition = enemy.position.y + width/GUARDIAN_FEET;
        float enemyHoriPosition = enemy.position.x + width/(GUARDIAN_WIDTH);
        int i = 0;
        int j = 0;


      for(Platform platform : platGen.platforms) {

        if(enemy.position.x > platform.position.x && enemyHoriPosition < platform.position.x + platform.platformWidth) {

          if(enemy.right && platform.rightEdge) {
            if(enemyHoriPosition + 2 * enemy.velocity.x > platform.position.x + platform.platformWidth) {
              enemy.velocity.x = 0;
              enemy.position.x = platform.position.x + platform.platformWidth - width/GUARDIAN_WIDTH;
              i++;
            }
          }

          if(!enemy.right && platform.leftEdge) {
            if(enemy.position.x +  2 * enemy.velocity.x < platform.position.x) {
              enemy.velocity.x = 0;
              enemy.position.x = platform.position.x;
              j++;
            }
          }

            if(i > 0) {
              enemy.onRightEdge = true;
            } else {
              enemy.onRightEdge = false;
            }

            if(j > 0) {
              enemy.onLeftEdge = true;
            } else {
              enemy.onLeftEdge = false;
            }
          }


        }
      }
    }
  }
}

void stopPetFalling() {
  if(attacking) {
    if(!pet.idle) {
      float petVertPosition = pet.position.y + width/GUARDIAN_FEET;
      float petHoriPosition = pet.position.x + width/(GUARDIAN_WIDTH);
      int i = 0;
      int j = 0;

      for(Platform platform : platGen.platforms) {
        if(pet.position.x > platform.position.x && petHoriPosition < platform.position.x + platform.platformWidth) {

          if(pet.right && platform.rightEdge) {
            if(petHoriPosition +  pet.velocity.x > platform.position.x + platform.platformWidth) {
              pet.velocity.x = 0;
              pet.position.x = platform.position.x + platform.platformWidth - width/GUARDIAN_WIDTH;
              i++;
            }
          }

          if(!pet.right && platform.leftEdge) {
            if(pet.position.x + pet.velocity.x < platform.position.x) {
              pet.velocity.x = 0;
              pet.position.x = platform.position.x;
              j++;
            }
          }

            if(i > 0) {
              pet.onRightEdge = true;
            } else {
              pet.onRightEdge = false;
            }

            if(j > 0) {
              pet.onLeftEdge = true;
            } else {
              pet.onLeftEdge = false;
            }
        }
      }
    }
  }
}


void drawPlatformEdges() {
  for(Platform platform : platGen.platforms) {
    if(platform.leftEdge){
      line(platform.position.x, 0, platform.position.x, height);
    }
    if(platform.rightEdge) {
      line(platform.position.x + platform.platformWidth, 0, platform.position.x + platform.platformWidth, height);
    }

  }
}



//checks for whether an enemy is attacking to stop parallax mode for combat
void checkAttacking() {
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

void guardianCollision() {
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
void detectAttackCollision() {
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

        if(petAlive) {
          float petX = pet.position.x + width/GUARDIAN_WIDTH;
          float petY = pet.position.y + width/GUARDIAN_FEET;

          if(attackX < petX && attackX > pet.position.x ) {

            if(attackY < petY && attackY > pet.position.y) {
              attacks.remove(attack);
            }
          }

        }

    }
  }
}

void removeDeadEnemies() {
    for(Enemy enemy : new ArrayList<Enemy>(enemies)) {
      if(enemy.health <= 0) {
        enemy.attack = false;
        enemy.alive = false;

        if(enemy == pet.target) {
          pet.target = null;
          petTargetChosen = false;
        }

        if(enemy.playDead) {
          enemies.remove(enemy);
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
