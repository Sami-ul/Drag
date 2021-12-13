public class Homing {
  private int x;
  private int y;
  private int shapeSize;
  private float px;
  private float py;
  private double slow;
  public Homing(int x, int y, int shapeSize) {
    this.x = x;
    this.y = y;
    this.shapeSize = shapeSize;
    slow = 0.03;
  }
  public void playerCoor(float x, float y, float size) {
    px = x + size/2;
    py = y + size/2;
  }
  public void moveX() {
    x += (px - x) * slow;
  }
  public void moveY() {
    y += (py - y) * slow;
  }
  public int getX() {
    return constrain(x, 0, width - shapeSize);
  }
  public int getY() {
    return constrain(y, 0, height - shapeSize);
  }
  public int getSize() {
    return shapeSize;
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
