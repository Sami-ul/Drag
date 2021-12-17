/*
  Sami-ul
  Enemy.pde
*/
public class Enemy {
    private int x;
    private int y;
    private int shapeSize;
    private int xSpeed;
    private int ySpeed;
    
    public Enemy(int x, int y, int xSpeed, int ySpeed, int shapeSize) {
      this.x = x;
      this.y = y;
      this.shapeSize = shapeSize;
      this.xSpeed = xSpeed;
      this.ySpeed = ySpeed;
    }
    public void move() {
      x+=xSpeed;
      y+=ySpeed;
    }
    public boolean passedXRangeL() {
      return x < shapeSize/2;
    }
    public boolean passedXRangeR() {
      return x > width - shapeSize/2;
    }
    public boolean passedYRangeT() {
      return y < shapeSize/2;
    }
    public boolean passedYRangeB() {
      return y > height - shapeSize/2;
    }
    public int getX() {
      return x;
    }
    public int getY() {
      return y;
    }
    public int getSize() {
      return shapeSize;
    }
    public void setXSpeed(int nSpeed) {
      xSpeed = nSpeed;
    }
    public void setYSpeed(int nSpeed) {
      ySpeed = nSpeed;
    }
    public boolean collide(MousePlayer mp, float size) {
      return mp.getX() + size/2 > x - shapeSize/2 &&
      mp.getX() - size/2 < x + shapeSize/2 &&
      mp.getY() + size/2 > y - shapeSize/2 &&
      mp.getY() - size/2 < y + shapeSize/2;      
    }
    public void display() {
      fill(23, 104, 172);
      ellipse(x, y, shapeSize, shapeSize);
    }
}
