public class Guardian extends Entity {


  final int IDLE_RESIZE = width/23;
  final int ATTACK_RESIZE = width/22;
  final int JUMP_RESIZE = width/20;
  final int RUN_RESIZE = width/20;

  final int CAMERA_ANCHOR = 10;

  float GROUND = height - height/6.85;
  float MIDDLE = width/2;
  final int GUARDIAN_SPEED = 7;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;
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

  boolean getAnchorRight() {
    return anchorRight;
  }

  boolean getAnchorLeft() {
    return anchorLeft;
  }

  void resize() {
    resizeIdle();
    resizeRun();
    resizeJump();
    resizeAttack();
  }

  void resizeAttack() {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE, 0);
    }
  }

  void resizeIdle() {
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE, 0);
    }
  }

  void resizeRun() {
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE, 0);
    }
  }

  void resizeJump() {
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE, 0);
    }
  }

  void moveRight() {
    if(position.x < anchorRightPos && !anchorRight) {
      velocity.x += GUARDIAN_SPEED;
      anchorLeft = false;
    } else {
      anchorRight = true;
      anchorLeft = false;
      velocity.x = -50;
      if(position.x <= anchorLeftPos) {
        velocity.x = 0;
      }
    }
    right = true;
    idle = false;
  }

  void moveLeft() {
    if(position.x > anchorLeftPos && !anchorLeft) {
      velocity.x -= GUARDIAN_SPEED;
      anchorRight = false;
    } else {
      anchorLeft = true;
      anchorRight = false;
      velocity.x = 50;
      if(position.x >= anchorRightPos) {
          velocity.x = 0;
      }
    }
    right = false;
    idle = false;
  }

  void jump() {
    if(position.y >= GROUND && !jump) {
      velocity.y = -JUMP_SPEED;
      jump = true;
    }
  }

  @Override
  void move(int i) {
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
        if(anchorLeft) {
          if(guardian.position.x < 1.5*width/5) {
            anchorLeft = false;
            anchorRight = false;
            velocity.x = 0;
          }
        } else if (anchorRight) {
          if(guardian.position.x >= 1.5*width/5 - width/GUARDIAN_WIDTH) {
            anchorLeft = false;
            anchorRight = false;
            velocity.x = 0;
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
