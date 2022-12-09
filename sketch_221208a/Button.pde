class Button {
  float x, y;
  Size size;
  
  Button(float xPos, float yPos, float w, float h) {
    x = xPos;
    y = yPos;
    size = new Size(w, h);
  }
  
  void display() {
    rect(x, y, size.width, size.height);
  }
  
  boolean isPointOver(float xPos, float yPos) {
    if (xPos >= x && xPos <= x+size.width && 
      yPos >= y && yPos <= y+size.height) {
      return true;
    }
    else {
      return false;
    }
  }
}
