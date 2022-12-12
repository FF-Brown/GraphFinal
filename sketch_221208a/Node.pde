class Node {
  float x, y;
  float diameter = 30;
  float radius = diameter/2;
  private color defaultColor = color(255,255,255);
  private int defaultStrokeColor = 0;
  private color selectedStrokeColor = color(255,255,255);
  int strokeWeight = 2;
  color fillColor;
  int strokeColor;
  boolean selected = false;
  int id;
  PVector velocity = new PVector(0,0);
  
  
  Node(int idNumber, float posX, float posY) {
    id = idNumber;
    x = posX;
    y = posY;
    fillColor = defaultColor;
    strokeColor = defaultStrokeColor;
  }
  
  void applyForce(PVector vector) {
    velocity.add(vector);
  }
  
  void update() {
    this.x += velocity.x;
    this.y += velocity.y;
    velocity.x /= 2;
    velocity.y /= 2;
  }
  
  void display() {
    fill(fillColor);
    stroke(strokeColor);
    strokeWeight(strokeWeight);
    ellipse(x, y, diameter, diameter);
    text("n"+id, x+radius, y+radius);
  }
  
  boolean isPointOver(float xPos, float yPos) {  
    float xDistance = x - xPos;
    float yDistance = y - yPos;
    float distance = sqrt(sq(xDistance) + sq(yDistance));
    if (distance < radius) {
      return true;
    } else {
      return false;
    }
  }
  
  void select() {
    strokeColor = selectedStrokeColor;
    selected = true;
  }
  
  void deselect() {
    strokeColor = defaultStrokeColor;
    selected = false;
  }
}
