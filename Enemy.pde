public class Enemy extends Entity {

  final int IDLE_RESIZE = width/30;
  final int ATTACK_RESIZE = width/22;
  final int JUMP_RESIZE = width/20;
  final int RUN_RESIZE = width/25;

  final int ENEMY_SPEED = 7;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;
  final int ENEMY_WIDTH = 20;


  Enemy(String path, float x, float y) {
    super(path, x ,y);
    resize();
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

  void attack() {
    if(!attack) {
      if(right) {
        enemy.velocity.x = ENEMY_SPEED;
      } else {
        enemy.velocity.x = -ENEMY_SPEED;
      }
    }

  }

}
