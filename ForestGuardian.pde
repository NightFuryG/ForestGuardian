Background background;
Entity guardian;
Entity pet;

final int GUARDIAN_WIDTH = 20;
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

final int PARALLAX_RIGHT = 1;
final int PARALLAX_LEFT = 2;
final int PARALLAX_NONE = 0;

final int CAMERA_ANCHOR = 10;

final int BACKGROUND_ONE = 11;

final int PET_COOLDOWN_TIME = 3000;

final String GUARDIAN_PATH = "animations/guardian/";
final String WOLF_PATH = "animations/pet/1/";

boolean w, a, s, d, j;
boolean petAlive;
boolean summon;
boolean petCooldown;


int parallax;
int summonCount;
int petTimer;
int petCooldownTimer;


ArrayList<Attack> attacks;

void setup() {
  fullScreen();
  w = a = s = d = j = false;
  petAlive = false;
  petCooldown = false;
  summon = false;
  parallax = 0;
  summonCount = 0;
  petTimer = 0;
  petCooldownTimer = 0;


  background = new Background(BACKGROUND_ONE);
  guardian = new Guardian(GUARDIAN_PATH, width/2, height - height/6.85);
  attacks = new ArrayList<Attack>();

}

void draw() {
  imageMode(CORNER);
  background(255);
  drawParallaxBackround();
  playerMove();
  if(petAlive) {
    pet.draw();
  }
  unsummonPet();
  guardian.draw();
  attack();
  bar();
  checkCooldowns();

  System.out.println("LEFT: " + guardian.anchorLeft + " RIGHT: " + guardian.anchorRight);
}

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

void unsummonPet() {
  if(millis() > petTimer +  PET_MAX_LIFE) {
    petAlive = false;
    pet = null;
    petTimer = millis();
  }
}

void checkCooldowns() {
  if(millis() > petCooldownTimer + PET_COOLDOWN_TIME) {
    petCooldown = true;
    petCooldownTimer = millis();
  }
}

void summonPet() {
  petAlive = true;
  pet = new Pet(WOLF_PATH, guardian.position.x, guardian.position.y);
  petTimer = millis();
}

void drawParallaxBackround() {

  if(guardian.anchorRight && guardian.idle) {
      parallax = PARALLAX_LEFT;
      guardian.velocity.x = 100;
  } else if (guardian.anchorLeft && guardian.idle) {
      parallax = PARALLAX_RIGHT;
      guardian.velocity.x = -100;
    } else if(guardian.right && guardian.anchorRight
      && !guardian.idle) {
      parallax = PARALLAX_RIGHT;
  } else if (!guardian.right && guardian.anchorLeft
      && !guardian.idle){
      parallax = PARALLAX_LEFT;
  } else {
      parallax = PARALLAX_NONE;
  }
  background.draw(parallax);

}

// movement
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

// movement
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


// movement
void playerMove() {
  if(w) {
    guardian.move(1);
    if(petAlive)
      pet.move(1);
  }
  if(s) {
    guardian.move(2);
    if(petAlive)
      pet.move(2);
  }
  if(d) {
    guardian.move(3);
    if(petAlive)
      pet.move(3);
  }
  if(a) {
    guardian.move(4);
    if(petAlive)
      pet.move(4);
  }
  if(!w && !s && !d && !a) {
    guardian.move(5);
    if(petAlive)
      pet.move(5);
  }
  if(j) {
    guardian.move(6);
    if(petAlive)
      pet.move(6);
  }
  if(petAlive) {
    updatePet();
  }
}

void mousePressed() {
  if(mouseButton == LEFT) {
    guardian.attack = true;
    if(attacks.size() == 0)
      if(guardian.right) {
        if(mouseX < guardian.position.x) {
          attacks.add( new Attack(guardian.position.x - width/GUARDIAN_WIDTH, guardian.position.y, mouseX, mouseY, false));
        } else {
          attacks.add( new Attack(guardian.position.x + width/GUARDIAN_WIDTH, guardian.position.y, mouseX, mouseY, true));
        }
      } else {
        if(mouseX > guardian.position.x) {

          attacks.add( new Attack(guardian.position.x + width/GUARDIAN_WIDTH, guardian.position.y, mouseX, mouseY, true));
        } else {
          attacks.add( new Attack(guardian.position.x - width/GUARDIAN_WIDTH, guardian.position.y, mouseX, mouseY, false));
        }
      }
  }
}

void attack() {
  drawAttack();
  removeAttack();
}

void removeAttack() {
  for(Attack attack : new ArrayList<Attack>(attacks)) {
    if(attack.distance > attack.MAX_DISTANCE || attack.position.y < GROUND ) {
      attacks.remove(attack);
    }
  }
}

void drawAttack() {
  for(Attack attack : attacks) {
    attack.draw();
  }
}
