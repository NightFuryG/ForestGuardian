public class Entity {

  final String IDLE_RIGHT = "idleRight/";
  final String IDLE_LEFT = "idleLeft/";
  final String RUN_RIGHT = "runRight/";
  final String RUN_LEFT = "runLeft/";
  final String JUMP_RIGHT = "jumpRight/";
  final String JUMP_LEFT = "jumpLeft/";
  final String ATTACK_RIGHT = "attackRight/";
  final String ATTACK_LEFT = "attackLeft/";

  String idleRightPath;
  String idleLeftPath;
  String runRightPath;
  String runLeftPath;
  String jumpRightPath;
  String jumpLeftPath;
  String attackRightPath;
  String attackLeftPath;


  float GROUND = height - height/6.85;
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

  void initialiseAnimations() {

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


  void update() {
    if(velocity.x > 1 || velocity.x < -1) {
      velocity.x *= 0.7;
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

  void display() {
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

  void animate(String animation) {
    animations.get(animation).draw(position);
  }

  void draw() {
    update();
    display();
  }

  void move(int i) {

  }
}
