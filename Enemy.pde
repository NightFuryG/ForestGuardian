//Enemy class used for enemy entites
public class Enemy extends Entity {

  final int ENEMY_SPEED = 15;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;
  final int ENEMY_WIDTH = 20;

  final int BOW = 1;
  final int ROCK = 2;
  final int MELEE = 0;

  int ranged;
  Platform platform;


  Enemy(HashMap<String, Animation> animations, int type, float x, float y, Platform platform) {
    super(animations, x ,y);
    this.ranged = checkType(type);
    this.grounded = true;
    this.platform = platform;
  }

  int checkType(int type) {
    if(type == BOW)   {
      return BOW;
    } else if (type == ROCK) {
      return ROCK;
    }

    return MELEE;

  }

  //attack and pursue guardian
  void attack() {
    if(!this.attack && ranged ==0) {
      if(right && !this.onRightEdge) {
        this.velocity.x = ENEMY_SPEED;
      } else if(!right && !this.onLeftEdge){
        this.velocity.x = -ENEMY_SPEED;
      }
    }

  }

}
