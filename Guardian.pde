//Class representing the playable Guardian
//contains the anchor positions for parallax;
public class Guardian extends Entity {

  final int IDLE_RESIZE = width/23;
  final int ATTACK_RESIZE = width/22;
  final int JUMP_RESIZE = width/20;
  final int RUN_RESIZE = width/20;

  final int VELOCITY_SWITCH = width/38;
  final int CAMERA_ANCHOR = 10;

  final float GROUND = height - height/6.85;
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
      this.anchorLeftPos =  width/5;
      System.out.println(VELOCITY_SWITCH);
      resize();
  }

  //get anchors
  boolean getAnchorRight() {
    return anchorRight;
  }

  boolean getAnchorLeft() {
    return anchorLeft;
  }

  public int getAnchorRightPos() {
    return anchorRightPos;
  }

  public int getAnchorLeftPos() {
    return anchorLeftPos;
  }

  //resize animations()
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

  //  parallax move right
  // logic for moving when moving right and anchoring
  // if anchored on right move to left anchor to create more visual space
  void moveRightParallax() {
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
  void moveRight() {
    if(position.x + width/GUARDIAN_WIDTH <= width) {
      velocity.x += GUARDIAN_SPEED;
    } else {
      velocity.x = -GUARDIAN_SPEED;
    }

    right = true;
    idle = false;
  }

  //basic move left
  void moveLeft() {
      if(position.x >= 0) {
        velocity.x -= GUARDIAN_SPEED;
      } else {
        velocity.x = GUARDIAN_SPEED;
      }

      right = false;
      idle = false;
  }

  //parallax move left
  void moveLeftParallax() {
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
  void jump() {
    if(!jump) {
      velocity.y = -JUMP_SPEED;
      jump = true;
      grounded = false;
    }
  }

  //move method needs more work done
  @Override
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
