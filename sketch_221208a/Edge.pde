class Edge {
  Node startNode;
  Node endNode;
  Point handle;
  float handleDiameter = 10;
  int id;
 
  Edge(int edgeID, Node start, Node end) {
    startNode = start;
    endNode = end;
    handle = getHandleLocation();
    id = edgeID;
  }
  
  Point getHandleLocation() {
    Point handleLocation;
    if (startNode.id == endNode.id) {
      handleLocation = new Point(startNode.x + 20, startNode.y + 20);
    }
    else {
       handleLocation = new Point((startNode.x + endNode.x)/2, (startNode.y + endNode.y)/2);
    }
    return handleLocation;
  }
  
  void resetHandleLocation() {
    handle = getHandleLocation();
  }

  void display() {
    noFill();
    beginShape();
    curveVertex(startNode.x, startNode.y);
    curveVertex(startNode.x, startNode.y);
    curveVertex(handle.x, handle.y);
    curveVertex(endNode.x, endNode.y);
    curveVertex(endNode.x, endNode.y);
    endShape();
    ellipse(handle.x, handle.y, handleDiameter, handleDiameter);
  }
 
  void update(Node start, Node end) {
    startNode.x = start.x;
    startNode.y = start.y;
    endNode.x = end.x;
    endNode.y = end.y;
  }
  
  boolean isPointOverHandle(Point point) {
    float distance = dist(point.x, point.y, handle.x, handle.y);
    if (distance < handleDiameter/2) {
      return true;
    }
    else {
      return false;
    }
  }  

 
  boolean isPointOver(float xPos, float yPos) {
    float offset = 5;
    // create 2 parallel lines
    // create 2 perpendicular lines
    // check if point is between both sets of lines
    return false;
  }
  
  boolean isBetweenLines() {
    return false;
  }
  
  boolean isBetweenValues(float value, float x1, float x2) {
    float min = min(x1, x2);
    float max = max(x1, x2);
    return value > min && value < max;
  }
}
