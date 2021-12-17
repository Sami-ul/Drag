/*
  Sami-ul
  Main.pde
*/

// Global declarations
Enemy[] enemies;
Homing[] homingEnemies;
MousePlayer mp;

// Enemy speeds
int[] xSpeeds;
int[] ySpeeds;

int size;
float pSize;

int ms;
int score;
int hScore;
int oldSec;

boolean endScreen;
boolean slowed;

void setup() {
  size(800, 600);
  noStroke();
  frameRate(50);
  
  // Local variables
  int enemyCount = 15;
  int homingCount = 1;
  int x;
  int y;
  
  // Global variable assignment
  size = 15;
  score = 0;
  hScore = 0;
  oldSec = 0;
  ms = millis();
  pSize = 15;
  endScreen = false;
  slowed = false;
  
  mp = new MousePlayer(pSize);
  xSpeeds = new int[enemyCount];
  ySpeeds = new int[enemyCount];
  enemies = new Enemy[enemyCount];
  homingEnemies = new Homing[homingCount];
  
  // Filling enemies array and enemy speeds array
  for (int i = 0; i < enemies.length; i++) {
    x = (int) random(size, width-size);
    y = (int) random(size, width/4+size);
    xSpeeds[i] = (int) random(-7, 7);
    ySpeeds[i] = (int) random(-7, 7);
    if (xSpeeds[i] == 0)
      xSpeeds[i] = 1;
    if (ySpeeds[i] == 0)
      ySpeeds[i] = 1;
    enemies[i] = new Enemy(x, y, xSpeeds[i], ySpeeds[i], size);
  }
  
  // Filling homing array
  for (int i = 0; i < homingEnemies.length; i++) {
    x = (int) random(size, width-size);
    y = (int) random(size, width/4-size);
    homingEnemies[i] = new Homing(x, y, size);
  }
}

void draw() {
  background(133, 183, 157);
  textSize(20);
  textAlign(CENTER);
  fill(22, 48, 43);
  text("Score: "+score, 40, 20);
  fill(8, 76, 28);
  
  mp.display();
  
  // Checking for collusion with ball and enemy or wall and enemy
  for (int i = 0; i < enemies.length; i++) {
    enemies[i].display();
    if (enemies[i].collide(mp, pSize)){
      lose();
      return;
    }
    // Score is added by collisions and by time
    if (enemies[i].passedXRangeR()) {
      xSpeeds[i]*=-1;
      if (!slowed)
        score+=5;
    }
    if (enemies[i].passedXRangeL()) {
      xSpeeds[i]*=-1;
      if (!slowed)
        score+=5;
    }
    if (enemies[i].passedYRangeT()) {
      ySpeeds[i]*=-1;
      if (!slowed)
        score+=5;
    }
    if (enemies[i].passedYRangeB()) {
      ySpeeds[i]*=-1;
      if (!slowed)
        score+=5;
    }
    if (millis() - ms > 3000) {
      enemies[i].setXSpeed(xSpeeds[i]);
      enemies[i].setYSpeed(ySpeeds[i]);
      enemies[i].move();
    }
  }
  // Adding score for surviving time
  if (second() >= oldSec + 1) {
    hScore+=1;
    oldSec = second();
  }
  
  // Testing collusion with homing and player
  for (Homing hom: homingEnemies) {
    hom.display();
    if (millis() - ms > 3000) {
      hom.playerCoor(mp.getX(), mp.getY(), pSize);
      hom.move();
    } else {
      fill(22, 48, 43);
      text("Click and drag to move the ball", width/2, (height/3)*2);
    }
    if (hom.collide(mp, pSize)) {
      lose();
      return;
    }
  }
  // Patch for ability to glitch out, player loses if passes out of bounds by glitch
  if (mp.getX() > width || mp.getX() < 0 || mp.getY() > height || mp.getY() < 0) {
    lose();
    return;
  }
}

void keyPressed() {
  // When player presses space the balls slow down
  // Player pays 20 points to slow, no points are gained while slowed
  if (!slowed && key == ' ') {
    slowed = true;
    score -= 20;
    for (int i = 0; i < xSpeeds.length; i++) {
      xSpeeds[i] = xSpeeds[i]/2;
      ySpeeds[i] = ySpeeds[i]/2;
      // Integer division sometimes results in 0, so fixing that
      if (xSpeeds[i] == 0) 
        xSpeeds[i]+=random(1, 4);
      if (ySpeeds[i] == 0)
        ySpeeds[i]+=random(1, 4);
    }
  }
}

void keyReleased() {
  // Unslow upon release
  if (slowed && key == ' ') {
    slowed = false;
    for (int i = 0; i < xSpeeds.length; i++) {
      xSpeeds[i] = xSpeeds[i]*2;
      ySpeeds[i] = ySpeeds[i]*2;
    }
  }
}

void mousePressed() {
  // Detect clicking of retry button
  // Issue with retrying several times, retry screen stops working after 5 or so rounds
  if (endScreen) {
    endScreen = false;
    if (mouseX >= width/2-30 &&
        mouseX <= width/2+30 &&
        mouseY >= height/2-60 &&
        mouseY <= height/2+60) {
          setup();
          loop();
    }
  }
}

void lose() {
  score += hScore * 2; // Adding time points to score
  
  noLoop(); // Prevent game from continuing
  
  // Lose screen and score
  background(133, 183, 157);
  fill(22, 48, 43);
  textSize(40);
  textAlign(CENTER);
  text("You Lose, Score: "+score, width/2, height/2);
  
  // Retry button
  rectMode(CENTER);
  fill(22, 48, 43);
  rect(width/2, height/2+40, 60, 30, 50);
  rectMode(CORNER);
  textSize(15);
  fill(133, 183, 157);
  text("Retry",width/2+1, height/2+45);
  endScreen = true;
}
