//Pet class used for when successfully summoned
public class Pet extends Entity {

  final int PET_SPEED = 20;
  float GROUND = height - height/6.85;
  float MIDDLE = width/2;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;

  Entity target;

  Pet(HashMap<String, Animation> animations, float x, float y) {
    super(animations, x, y);
    this.attack = true;
    this.target = null;
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
