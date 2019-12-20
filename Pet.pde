//Pet class used for when successfully summoned
public class Pet extends Entity {

  final int IDLE_RESIZE = width/15;
  final int ATTACK_RESIZE = width/14;
  final int JUMP_RESIZE = width/13;
  final int RUN_RESIZE = width/14;

  final int PET_SPEED = 20;
  float GROUND = height - height/6.85;
  float MIDDLE = width/2;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;

  Entity target;

  Pet(String path, float x, float y) {
    super(path, x, y);
    resize();
    this.attack = true;
    this.target = null;
  }

  //resize Animations
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
    right = true;
    idle = false;
  }

  void moveLeft() {
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
  void setVelR() {
    velocity.x = PET_SPEED*2;
  }


  @Override
  void setVelL() {
    velocity.x = -PET_SPEED*2;
  }

  @Override
  void move(int i, boolean b) {
    switch (i) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        if(!b)
          moveRight();
        break;
      case 4:
        if(!b)
          moveLeft();
        break;
      case 5:
        if(!b)
          idle = true;
        break;
      case 6:
        if(!b)
          jump();
        break;
      default:
        break;
    }
  }

  @Override
  void attackTarget() {
    if(!this.attack) {
      if(this.right && !this.onRightEdge) {
        this.velocity.x = PET_SPEED;
      } else if( !this.right && !this.onLeftEdge){
        this.velocity.x = -PET_SPEED;
      }
    }

  }


}
