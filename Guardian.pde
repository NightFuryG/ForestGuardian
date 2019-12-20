//Class representing the playable Guardian
//contains the anchor positions for parallax;
public class Guardian extends Entity {

  final int VELOCITY_SWITCH = width/38;
  final int CAMERA_ANCHOR = 10;

  final float GROUND = height - height/6.85;
  final float MIDDLE = width/2;
  final int GUARDIAN_SPEED = width/150;
  final int JUMP_SPEED = 30;
  final int DASH_SPEED = width/12;
  final float GRAVITY = 3;
  final int GUARDIAN_WIDTH = 20;
  final int ENERGY = 25;

  int anchorRightPos;
  int anchorLeftPos;


  //path and position
  Guardian (HashMap<String, Animation> animations, float x, float y) {
      super(animations, x, y);
      this.anchorRight = false;
      this.anchorLeft = false;
      this.anchorRightPos = width/3;
      this.anchorLeftPos =  width/5;
    
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




  //  parallax move right
  // logic for moving when moving right and anchoring
  // if anchored on right move to left anchor to create more visual space
  void moveRightParallax() {
    if(position.x < anchorRightPos && !anchorRight) {
      if(velocity.x < 2 * GUARDIAN_SPEED) {
        velocity.x += GUARDIAN_SPEED;
      }
      anchorLeft = false;
    } else {
      anchorRight = true;
      anchorLeft = false;
      if(!this.dashing) {

      velocity.x = -VELOCITY_SWITCH;
      }
      if(position.x <= anchorLeftPos) {
        if(!this.dashing) {
          velocity.x = 0;
        }
      }
    }
    right = true;
    idle = false;
  }

  //basic move right
  void moveRight() {

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
  void moveLeft() {

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
  void moveLeftParallax() {
    if(position.x > anchorLeftPos && !anchorLeft) {
      if(velocity.x > 2 * - GUARDIAN_SPEED) {
        velocity.x -= GUARDIAN_SPEED;
      }
      anchorRight = false;
    } else {
      anchorLeft = true;
      anchorRight = false;
      if(!this.dashing) {

      velocity.x = VELOCITY_SWITCH;
      }
      if(position.x >= anchorRightPos) {
        if(!this.dashing) {
          velocity.x = 0;
        }
      }
    }
    right = false;
    idle = false;
  }

  //jump - needs work
  void jump() {
    if(this.jumps == 2 ) {
      this.velocity.y = -JUMP_SPEED;
      this.jump = true;
      this.grounded = false;
      this.jumps--;
    } else if(this.jumps == 1) {
      if(this.energy >= ENERGY) {
        this.velocity.y = -JUMP_SPEED;
        this.jump = true;
        this.grounded = false;
        this.jumps--;
        this.energy -= ENERGY;
      }
    }
  }


  void dash() {
    if(this.dash > 0 && this.energy >= ENERGY) {
      this.dashing = true;
      if(this.right) {
        this.velocity.x += DASH_SPEED;
      } else {
        this.velocity.x -= DASH_SPEED;
      }
      this.dash--;
      this.energy -= ENERGY;
    }
  }

  //move method needs more work done
  @Override
  void move(int i, boolean b) {
    switch (i) {
      case 1:
        if(!this.grounded) {
          dash();
        }
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
        if(!this.attack)
          this.idle = true;
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
