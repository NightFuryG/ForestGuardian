//Enemy class used for enemy entites
public class Enemy extends Entity {

  final String ENEMY_ONE_PATH = "animations/enemy/1/";
  final String ENEMY_TWO_PATH = "animations/enemy/2/";
  final String ENEMY_THREE_PATH = "animations/enemy/3/";
  final String ENEMY_FOUR_PATH = "animations/enemy/4/";

  final int IDLE_RESIZE_1 = width/30;
  final int ATTACK_RESIZE_1 = width/23;
  final int JUMP_RESIZE_1 = width/20;
  final int RUN_RESIZE_1 = width/25;
  final int DIE_RESIZE_1 = width/17;

  final int IDLE_RESIZE_2 = width/25;
  final int ATTACK_RESIZE_2 = width/24;
  final int JUMP_RESIZE_2 = width/20;
  final int RUN_RESIZE_2 = width/25;
  final int DIE_RESIZE_2 = width/17;

  final int IDLE_RESIZE_3 = width/20;
  final int ATTACK_RESIZE_3 = width/20;
  final int JUMP_RESIZE_3 = width/15;
  final int RUN_RESIZE_3 = width/18;
  final int DIE_RESIZE_3 = width/15;

  final int IDLE_RESIZE_4 = width/20;
  final int ATTACK_RESIZE_4 = width/17;
  final int JUMP_RESIZE_4 = width/15;
  final int RUN_RESIZE_4 = width/19;
  final int DIE_RESIZE_4 = width/15;

  final int ENEMY_SPEED = 15;
  final int JUMP_SPEED = 20;
  final float GRAVITY = 2;
  final int ENEMY_WIDTH = 20;

  final int BOW = 1;
  final int ROCK = 2;
  final int MELEE = 0;

  int ranged;
  Platform platform;


  Enemy(String path, float x, float y, Platform platform) {
    super(path, x ,y);
    this.ranged = checkType(path);
    this.grounded = true;
    this.platform = platform;
    resize(path);
  }

  Enemy(Enemy enemy) {
    
  }

  int checkType(String path) {
    if(path.equals(ENEMY_TWO_PATH)  ) {
      return BOW;
    } else if (path.equals(ENEMY_THREE_PATH)) {
      return ROCK;
    }

    return MELEE;

  }

  //resize animations so all same size
  void resize(String path) {
    resizeIdle(path);
    resizeRun(path);
    resizeJump(path);
    resizeAttack(path);
    resizeDie(path);
  }

  void resizeAttack(String path) {

    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
        frame.resize(ATTACK_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(ATTACK_LEFT).animation) {
        frame.resize(ATTACK_RESIZE_1, 0);
      }
    } else if (path.equals(ENEMY_TWO_PATH)) {
        for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
          frame.resize(ATTACK_RESIZE_2, 0);
        }
        for(PImage frame : animations.get(ATTACK_LEFT).animation) {
          frame.resize(ATTACK_RESIZE_2, 0);
        }
    } else if (path.equals(ENEMY_THREE_PATH)) {
        for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
          frame.resize(ATTACK_RESIZE_3, 0);
        }
        for(PImage frame : animations.get(ATTACK_LEFT).animation) {
          frame.resize(ATTACK_RESIZE_3, 0);
        }
    } else if (path.equals(ENEMY_FOUR_PATH)) {
        for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
          frame.resize(ATTACK_RESIZE_4, 0);
        }
        for(PImage frame : animations.get(ATTACK_LEFT).animation) {
          frame.resize(ATTACK_RESIZE_4, 0);
        }
    }
  }

  void resizeIdle(String path) {
    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(IDLE_LEFT).animation) {
        frame.resize(IDLE_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(IDLE_RIGHT).animation) {
        frame.resize(IDLE_RESIZE_1, 0);
      }
    } else if(path.equals(ENEMY_TWO_PATH)) {
        for(PImage frame : animations.get(IDLE_LEFT).animation) {
          frame.resize(IDLE_RESIZE_2, 0);
        }
        for(PImage frame : animations.get(IDLE_RIGHT).animation) {
          frame.resize(IDLE_RESIZE_2, 0);
        }
    } else if(path.equals(ENEMY_THREE_PATH)) {
        for(PImage frame : animations.get(IDLE_LEFT).animation) {
          frame.resize(IDLE_RESIZE_3, 0);
        }
        for(PImage frame : animations.get(IDLE_RIGHT).animation) {
          frame.resize(IDLE_RESIZE_3, 0);
        }
    } else if(path.equals(ENEMY_FOUR_PATH)) {
        for(PImage frame : animations.get(IDLE_LEFT).animation) {
          frame.resize(IDLE_RESIZE_4, 0);
        }
        for(PImage frame : animations.get(IDLE_RIGHT).animation) {
          frame.resize(IDLE_RESIZE_4, 0);
        }
    }
  }

  void resizeRun(String path) {
    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(RUN_LEFT).animation) {
        frame.resize(RUN_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(RUN_RIGHT).animation) {
        frame.resize(RUN_RESIZE_1, 0);
      }
    } else if(path.equals(ENEMY_TWO_PATH)) {
      for(PImage frame : animations.get(RUN_LEFT).animation) {
        frame.resize(RUN_RESIZE_2, 0);
      }
      for(PImage frame : animations.get(RUN_RIGHT).animation) {
        frame.resize(RUN_RESIZE_2, 0);
      }
    } else if(path.equals(ENEMY_THREE_PATH)) {
      for(PImage frame : animations.get(RUN_LEFT).animation) {
        frame.resize(RUN_RESIZE_3, 0);
      }
      for(PImage frame : animations.get(RUN_RIGHT).animation) {
        frame.resize(RUN_RESIZE_3, 0);
      }
    } else if(path.equals(ENEMY_FOUR_PATH)) {
      for(PImage frame : animations.get(RUN_LEFT).animation) {
        frame.resize(RUN_RESIZE_4, 0);
      }
      for(PImage frame : animations.get(RUN_RIGHT).animation) {
        frame.resize(RUN_RESIZE_4, 0);
      }
    }

  }

  void resizeJump(String path) {
    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(JUMP_LEFT).animation) {
        frame.resize(JUMP_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(JUMP_RIGHT).animation) {
        frame.resize(JUMP_RESIZE_1, 0);
      }
    } else if(path.equals(ENEMY_TWO_PATH)) {
        for(PImage frame : animations.get(JUMP_LEFT).animation) {
          frame.resize(JUMP_RESIZE_2, 0);
        }
        for(PImage frame : animations.get(JUMP_RIGHT).animation) {
          frame.resize(JUMP_RESIZE_2, 0);
        }
    } else if(path.equals(ENEMY_THREE_PATH)) {
        for(PImage frame : animations.get(JUMP_LEFT).animation) {
          frame.resize(JUMP_RESIZE_3, 0);
        }
        for(PImage frame : animations.get(JUMP_RIGHT).animation) {
          frame.resize(JUMP_RESIZE_3, 0);
        }
    } else if(path.equals(ENEMY_FOUR_PATH)) {
        for(PImage frame : animations.get(JUMP_LEFT).animation) {
          frame.resize(JUMP_RESIZE_4, 0);
        }
        for(PImage frame : animations.get(JUMP_RIGHT).animation) {
          frame.resize(JUMP_RESIZE_4, 0);
        }
    }

  }
  void resizeDie(String path) {
    if(path.equals(ENEMY_ONE_PATH)) {
      for(PImage frame : animations.get(DIE_LEFT).animation) {
        frame.resize(DIE_RESIZE_1, 0);
      }
      for(PImage frame : animations.get(DIE_RIGHT).animation) {
        frame.resize(DIE_RESIZE_1, 0);
      }
    } else if(path.equals(ENEMY_TWO_PATH)) {
        for(PImage frame : animations.get(DIE_LEFT).animation) {
          frame.resize(DIE_RESIZE_2, 0);
        }
        for(PImage frame : animations.get(DIE_RIGHT).animation) {
          frame.resize(DIE_RESIZE_2, 0);
        }
    } else if(path.equals(ENEMY_THREE_PATH)) {
        for(PImage frame : animations.get(DIE_LEFT).animation) {
          frame.resize(DIE_RESIZE_3, 0);
        }
        for(PImage frame : animations.get(DIE_RIGHT).animation) {
          frame.resize(DIE_RESIZE_3, 0);
        }
    } else if(path.equals(ENEMY_FOUR_PATH)) {
        for(PImage frame : animations.get(DIE_LEFT).animation) {
          frame.resize(DIE_RESIZE_4, 0);
        }
        for(PImage frame : animations.get(DIE_RIGHT).animation) {
          frame.resize(DIE_RESIZE_4, 0);
        }
    }

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
