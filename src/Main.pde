/*
  Sami-ul
  Main.pde
*/
Enemy[] enemies;
Homing[] h;
MousePlayer mp;
int[] xSpeeds;
int[] ySpeeds;
int enemyCount;
int homingCount;
int x;
int y;
int size;
int ms;
int score;
int hScore;
int oldSec;
float pSize;
boolean kRel;
boolean endScreen;
void setup() {
  size(800, 600);
  noStroke();
  frameRate(50);
  
  size = 15;
  score = 0;
  hScore = 0;
  oldSec = 0;
  ms = millis();
  enemyCount = 15;
  homingCount = 1;
  pSize = 15;
  kRel = false;
  endScreen = false;
  mp = new MousePlayer(pSize);
  xSpeeds = new int[enemyCount];
  ySpeeds = new int [enemyCount];
  enemies = new Enemy[enemyCount];
  h = new Homing[homingCount];
  
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
  for (int i = 0; i < h.length; i++) {
    x = (int) random(size, width-size);
    y = (int) random(size, width/4-size);
    h[i] = new Homing(x, y, size);
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
  
  for (int i = 0; i < enemies.length; i++) {
    enemies[i].display();
    if (enemies[i].collide(mp, pSize)){
      lose();
      return;
    }
    if (enemies[i].passedXRangeR()) {
      xSpeeds[i]*=-1;
      score+=5;
    }
    if (enemies[i].passedXRangeL()) {
      xSpeeds[i]*=-1;
      score+=5;
    }
    if (enemies[i].passedYRangeT()) {
      ySpeeds[i]*=-1;
      score+=5;
    }
    if (enemies[i].passedYRangeB()) {
      ySpeeds[i]*=-1;
      score+=5;
    }
    if (millis() - ms > 3000) {
      enemies[i].setXSpeed(xSpeeds[i]);
      enemies[i].setYSpeed(ySpeeds[i]);
      enemies[i].moveX();
      enemies[i].moveY();
    }
  }
  if (second() >= oldSec + 1) {
    hScore+=1;
    oldSec = second();
  }
  for (Homing hom: h) {
    hom.display();
    if (millis() - ms > 3000) {
      hom.playerCoor(mp.getX(), mp.getY(), pSize);
      hom.moveX();
      hom.moveY();
    } else {
      fill(22, 48, 43);
      text("Click and drag to move the ball", width/2, (height/3)*2);
    }
    if (hom.collide(mp, pSize)) {
      lose();
      return;
    }
  }
  if (mp.getX() > width || mp.getX() < 0 || mp.getY() > height || mp.getY() < 0) {
    lose();
    return;
  }
}

void keyReleased() {
  kRel = true;
}

void mousePressed() {
  if (endScreen) {
    
    if (mouseX >= width/2-30 &&
        mouseX <= width/2+30 &&
        mouseY >= height/2-60 &&
        mouseY <= height/2+60) {
          setup();
          loop();
        }
     endScreen = false;
  }
}

void lose() {
  score += hScore * 2;
  noLoop();
  background(133, 183, 157);
  fill(22, 48, 43);
  textSize(40);
  textAlign(CENTER);
  text("You Lose, Score: "+score, width/2, height/2);
  rectMode(CENTER);
  fill(22, 48, 43);
  rect(width/2, height/2+40, 60, 30, 50);
  rectMode(CORNER);
  textSize(15);
  fill(133, 183, 157);
  text("Retry",width/2+1, height/2+45);
  endScreen = true;
}
