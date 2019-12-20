public class Animator {

  final String GUARDIAN_PATH = "animations/guardian/";
  final String WOLF_PATH = "animations/pet/1/";
  final String ENEMY_ONE_PATH = "animations/enemy/1/";
  final String ENEMY_TWO_PATH = "animations/enemy/2/";
  final String ENEMY_THREE_PATH = "animations/enemy/3/";
  final String ENEMY_FOUR_PATH = "animations/enemy/4/";

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

  final int IDLE_RESIZE_WOLF = width/15;
  final int ATTACK_RESIZE_WOLF = width/14;
  final int JUMP_RESIZE_WOLF = width/13;
  final int RUN_RESIZE_WOLF = width/14;
  final int DIE_RESIZE_WOLF = width/14;

  final int IDLE_RESIZE_G = width/23;
  final int ATTACK_RESIZE_G = width/22;
  final int JUMP_RESIZE_G = width/20;
  final int RUN_RESIZE_G = width/20;
  final int DIE_RESIZE_G = width/20;

  final int ANIMATION_TOTAL = 10;

  HashMap<String, Animation> guardian;
  HashMap<String, Animation> wolf;
  HashMap<String, Animation> enemyOne;
  HashMap<String, Animation> enemyTwo;
  HashMap<String, Animation> enemyThree;
  HashMap<String, Animation> enemyFour;

  ArrayList<String> animationPaths;

  Animator() {
    guardian = new HashMap<String, Animation>();
    wolf = new HashMap<String, Animation>();
    enemyOne = new HashMap<String, Animation>();
    enemyTwo = new HashMap<String, Animation>();
    enemyThree = new HashMap<String, Animation>();
    enemyFour = new HashMap<String, Animation>();
    animationPaths = new ArrayList();
    initAnimationPaths();
    initAnimations();
    resizeAnimations();
  }

  void initAnimationPaths() {
    animationPaths.add(IDLE_RIGHT);
    animationPaths.add(IDLE_LEFT);
    animationPaths.add(RUN_RIGHT);
    animationPaths.add(RUN_LEFT);
    animationPaths.add(JUMP_RIGHT);
    animationPaths.add(JUMP_LEFT);
    animationPaths.add(ATTACK_RIGHT);
    animationPaths.add(ATTACK_LEFT);
    animationPaths.add(DIE_RIGHT);
    animationPaths.add(DIE_LEFT);
  }

  void initAnimations() {
    for(int i = 0; i < ANIMATION_TOTAL; i ++) {
      guardian.put(animationPaths.get(i), new Animation(GUARDIAN_PATH + animationPaths.get(i)));
      wolf.put(animationPaths.get(i), new Animation(WOLF_PATH + animationPaths.get(i)));
      enemyOne.put(animationPaths.get(i), new Animation(ENEMY_ONE_PATH + animationPaths.get(i)));
      enemyTwo.put(animationPaths.get(i), new Animation(ENEMY_TWO_PATH + animationPaths.get(i)));
      enemyThree.put(animationPaths.get(i), new Animation(ENEMY_THREE_PATH + animationPaths.get(i)));
      enemyFour.put(animationPaths.get(i), new Animation(ENEMY_FOUR_PATH + animationPaths.get(i)));
    }
  }

  void resizeAnimations(){
    resizeGuardian(guardian);
    resizeWolf(wolf);
    resizeEnemyOne(enemyOne);
    resizeEnemyTwo(enemyTwo);
    resizeEnemyThree(enemyThree);
    resizeEnemyFour(enemyFour);
  }

  void resizeEnemyOne(HashMap<String, Animation> animations) {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(DIE_LEFT).animation) {
      frame.resize(DIE_RESIZE_1, 0);
    }
    for(PImage frame : animations.get(DIE_RIGHT).animation) {
      frame.resize(DIE_RESIZE_1, 0);
    }
  }

  void resizeEnemyTwo(HashMap<String, Animation> animations) {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(DIE_LEFT).animation) {
      frame.resize(DIE_RESIZE_2, 0);
    }
    for(PImage frame : animations.get(DIE_RIGHT).animation) {
      frame.resize(DIE_RESIZE_2, 0);
    }
  }

  void resizeEnemyThree(HashMap<String, Animation> animations) {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(DIE_LEFT).animation) {
      frame.resize(DIE_RESIZE_3, 0);
    }
    for(PImage frame : animations.get(DIE_RIGHT).animation) {
      frame.resize(DIE_RESIZE_3, 0);
    }
  }

  void resizeEnemyFour(HashMap<String, Animation> animations) {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(DIE_LEFT).animation) {
      frame.resize(DIE_RESIZE_4, 0);
    }
    for(PImage frame : animations.get(DIE_RIGHT).animation) {
      frame.resize(DIE_RESIZE_4, 0);
    }
  }

  void resizeGuardian(HashMap<String, Animation> animations) {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(DIE_LEFT).animation) {
      frame.resize(DIE_RESIZE_G, 0);
    }
    for(PImage frame : animations.get(DIE_RIGHT).animation) {
      frame.resize(DIE_RESIZE_G, 0);
    }
  }

  void resizeWolf(HashMap<String, Animation> animations) {
    for(PImage frame : animations.get(ATTACK_RIGHT).animation) {
      frame.resize(ATTACK_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(ATTACK_LEFT).animation) {
      frame.resize(ATTACK_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(IDLE_LEFT).animation) {
      frame.resize(IDLE_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(IDLE_RIGHT).animation) {
      frame.resize(IDLE_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(RUN_LEFT).animation) {
      frame.resize(RUN_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(RUN_RIGHT).animation) {
      frame.resize(RUN_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(JUMP_LEFT).animation) {
      frame.resize(JUMP_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(JUMP_RIGHT).animation) {
      frame.resize(JUMP_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(DIE_LEFT).animation) {
      frame.resize(DIE_RESIZE_WOLF, 0);
    }
    for(PImage frame : animations.get(DIE_RIGHT).animation) {
      frame.resize(DIE_RESIZE_WOLF, 0);
    }
  }


}
