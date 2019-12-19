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


  float GROUND = height - height/6.85;
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
  boolean onLeftEdge;
  boolean onRightEdge;

  int health;

  PVector velocity;
  PVector position;

  Entity target;
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

    this.onLeftEdge = false;
    this.onRightEdge = false;
    this.anchorLeft = false;
    this.anchorRight = false;

    this.health = HEALTH;
    this.alive = true;
    this.playDead = false;

    this.colliding = false;
    this.target = null;
  }

  //add animations to HashMap
  void initialiseAnimations() {

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
  void update() {
    if(velocity.x > 1 || velocity.x < -1) {
      velocity.x *= 0.7;
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
  void display() {

    if(alive) {
      if(attack && right && !idle) {
        animate(ATTACK_RIGHT);
        if(animations.get(ATTACK_RIGHT).animated) {
            attack = false;
            animations.get(ATTACK_RIGHT).animated = false;
        }
      } else if (attack && !right &&!idle) {
          animate(ATTACK_LEFT);
          if(animations.get(ATTACK_LEFT).animated) {
            attack = false;
            animations.get(ATTACK_LEFT).animated = false;
          }
      } else if(jump && right) {
        animate(JUMP_RIGHT);
      } else if (jump && !right) {
        animate(JUMP_LEFT);
      } else if ((onLeftEdge || onRightEdge) && right && !idle) {
        animate(IDLE_RIGHT);
      } else if ((onLeftEdge || onRightEdge)&& !right && !idle) {
        animate(IDLE_LEFT);
      } else if (idle && right) {
        animate(IDLE_RIGHT);
      } else if(idle && !right) {
        animate(IDLE_LEFT);
      } else if(!idle && right ) {
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
  void animate(String animation) {
    animations.get(animation).draw(position, this.health);
  }

  void animateOnce(String animation) {
    animations.get(animation).drawOnce(position, this.health);
  }

  //draw
  void draw() {
    update();
    display();
  }

  void move(int i, boolean b){
  }

  int getAnchorRightPos() {
    return width/3;
  }

  int getAnchorLeftPos() {
    return width/5;
  }

  void attackTarget() {
  }

  void setVelL() {

  }

  void setVelR() {
    
  }
}
