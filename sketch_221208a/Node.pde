class Node {
  float x, y;
  float diameter = 30;
  int defaultColor = 255;
  int defaultStrokeColor = 0;
  int selectedStrokeColor = 255;
  int strokeWeight = 2;
  int fillColor;
  int strokeColor;
  boolean selected = false;
  int id;
  
  Node(int idNumber, float posX, float posY) {
    id = idNumber;
    x = posX;
    y = posY;
    fillColor = defaultColor;
    strokeColor = defaultStrokeColor;
  }
  
  void display() {
    fill(fillColor);
    stroke(strokeColor);
    strokeWeight(strokeWeight);
    ellipse(x, y, diameter, diameter);
  }
  
  boolean isPointOver(float xPos, float yPos) {  
    float xDistance = x - xPos;
    float yDistance = y - yPos;
    float distance = sqrt(sq(xDistance) + sq(yDistance));
    if (distance < diameter/2) {
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
  
  void update() {
   
  }

}
