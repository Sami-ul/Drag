/*
  Sami-ul
  MousePlayer.pde
*/
public class MousePlayer {
  private float mouseXV;
  private float mouseYV;
  private PVector mouseVect;
  private PVector loc;
  private PVector vel;
  private PVector acc;
  private float top;
  private float size;
  private int oldMPX;
  private int oldMPY;
  
  public MousePlayer(float size) {
    this.loc = new PVector(width/2, height/2);
    this.vel = new PVector(0, 0);
    this.top = 7;
    this.size = size;
  }
  public void move(float x, float y, boolean released) {
    this.mouseXV = x;
    this.mouseYV = y;
    // Keeping in bounds
    if ((loc.x + size/2 > width) || (loc.x - size/2 < 0)) {
      vel.x = vel.x * -1;
    }
    if ((loc.y + size/2 > height) || (loc.y - size/2 < 0)) {
      vel.y = vel.y * -1;
    }
    
    this.mouseVect = new PVector(mouseXV, mouseYV);
    this.acc = PVector.sub(mouseVect, loc);
    acc.setMag(0.5);
    if (!released) { // If the mouse is pressed, continue acceleration
      vel.add(acc);
    }
    vel.limit(top);
    loc.add(vel);
  }
  public float getX() {
    return loc.x;
  }
  public float getY() {
    return loc.y;
  }
  public void display() {
    fill(22, 48, 43);
    ellipse(mp.getX(), mp.getY(), size, size);
    if (mousePressed) { // If mouse pressed follow the ball
      mp.move(mouseX, mouseY, false);
      oldMPX = mouseX;
      oldMPY = mouseY;
      strokeWeight(2);
      stroke(22, 48, 43);
      line(mp.getX(), mp.getY(), mouseX, mouseY);
      noStroke();
    } else { // otherwise go in the old direction
      mp.move(oldMPX, oldMPY, true);
    }
  }
}
