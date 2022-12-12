import g4p_controls.*;

int nodeDiameter;
ArrayList<Node> nodes;
ArrayList<Edge> edges;
Node selectedNode;
boolean dragging = false;
Node draggingNode;
Edge draggingEdge;
boolean draggingHandle = false;
int backgroundColor = 102;
int nodeID = 0;
int edgeID = 0;
PFont f;
GTextField redField, greenField, blueField;
Size fieldSize = new Size(50,20);
Point redFieldPos, greenFieldPos, blueFieldPos;
Point buttonPos = new Point(10, 170);
Size buttonSize = new Size(50, 20);
boolean repelling = false;
int maxX = 960;
int maxY = 540;

void setup() {
  size(960, 540);
  background(backgroundColor);
  nodes = new ArrayList<Node>();
  edges = new ArrayList<Edge>();
  f = createFont("Times New Roman", 18);
  textFont(f);
  
  redFieldPos = new Point(20,70);
  redField = new GTextField(this, redFieldPos.x, redFieldPos.y, 50, 20);
  greenFieldPos = new Point(20,100);
  greenField = new GTextField(this, greenFieldPos.x, greenFieldPos.y, 50, 20);
  blueFieldPos = new Point(20,130);
  blueField = new GTextField(this, blueFieldPos.x, blueFieldPos.y, 50, 20);
  
  redField.setNumeric(0, 255, 0);
  greenField.setNumeric(0, 255, 0);
  blueField.setNumeric(0, 255, 0);
}

void addNode() {
  Node newNode = new Node(nodeID, mouseX, mouseY);
  nodeID++;
  nodes.add(newNode);
}

boolean repel() {
  float minDistance = 100;
  boolean stillWorking = false; //<>//
  for (Node target : nodes) {
    for (Node other : nodes) {
      if (target.id != other.id) {
        if (dist(target.x, target.y, other.x, other.y) < minDistance) {
          println("Pushing", other.id, "away from", target.id);
          // calculate vector
          PVector vector = new PVector(2/(other.x-target.x), 2/(other.y-target.y)); //<>//
  
          // repel nodes
          other.applyForce(vector);
          
          stillWorking = true;
        }
      }
    }
  }
  return stillWorking;
}

void draw() {
  background(102);
  if (dragging && draggingNode != null) {
    findNodeByID(nodes, draggingNode.id).x = mouseX; //<>//
    findNodeByID(nodes, draggingNode.id).y = mouseY;
    for (Edge edge : getConnectedEdges(draggingNode)) {
      findEdgeByID(edges, edge.id).resetHandleLocation();
    }
  }
  else if (draggingHandle && draggingEdge != null) {
    findEdgeByID(edges, draggingEdge.id).handle.x = mouseX; //<>//
    findEdgeByID(edges, draggingEdge.id).handle.y = mouseY;
  }
  
  updateEdges();
  updateNodes();
  
  text("Nodes:", 0, 15);
  text(nodes.size(), 60, 15);
  text("Edges:", 0, 35);
  text(edges.size(), 60, 35);
  text("R:", redFieldPos.x-20, redFieldPos.y+15);
  text("G:", greenFieldPos.x-20, greenFieldPos.y+15);
  text("B:", blueFieldPos.x-20, blueFieldPos.y+15);
  
  // Update selected node color
  if (selectedNode != null) {
    float r = float(redField.getText());
    float g = float(greenField.getText());
    float b = float(blueField.getText());
    
    selectedNode.fillColor = color(r,g,b);
  }
  
  if (repelling) {
    repelling = repel();
    if (!repelling) {
      println("Finished repelling");  
    }
  }
  
  // Draw button
  fill(0);
  rect(buttonPos.x, buttonPos.y, buttonSize.width, buttonSize.height);
  fill(255);
  text("Repel", buttonPos.x+5, buttonPos.y+15);
  
  boolean drawMatrix = true;
  if (drawMatrix && nodes != null && nodes.size() > 0) {
    String m = ""; //<>//
    for (Node node : nodes) {
      for (Node other : nodes) {
        if (areAdjacent(node,other))
          m = m.concat("1 ");
        else 
          m = m.concat("0 ");
      }
      m = m.concat("\n");
    }
    text(m, buttonPos.x+5, buttonPos.y+45);
  }
}

boolean areAdjacent(Node n1, Node n2) {
  boolean adjacent = false;
  for (Edge edge : edges) {
    if ((edge.startNode.id == n1.id && edge.endNode.id == n2.id)
    || (edge.endNode.id == n1.id && edge.startNode.id == n2.id)) {
      adjacent = true;
      break;
    }
  }
  return adjacent;
}

void updateNodes() {
  for (Node node : nodes) {
    node.update();
    node.display();
  }
}

void updateEdges() {
  for (Edge edge : edges) {
    edge.display();
    edge.update(findNodeByID(nodes,edge.startNode.id),findNodeByID(nodes,edge.endNode.id));
  }
}

Edge findEdgeByID(ArrayList<Edge> edgeList, int edgeID) {
  for (Edge edge : edgeList) {
    if (edge.id == edgeID) {
      return edge;
    }
  }
  return null;
}

Node findNodeByID(ArrayList<Node> nodeList, int nodeID) {
  for (Node node : nodeList) {
    if (node.id == nodeID) {
      return node;
    }
  }
  return null;
}

ArrayList<Edge> getConnectedEdges(Node node) {
  ArrayList<Edge> connectedEdges = new ArrayList<Edge>();
  
  for (Edge edge : edges) {
    if (edge.startNode.id == node.id || edge.endNode.id == node.id) {
      connectedEdges.add(edge);
    }
  }
  
  return connectedEdges;
}

void mouseClicked() {  
  if (mouseButton == LEFT) {
    handleLeftClick();
  }
  else if (mouseButton == RIGHT) {
    handleRightClick();
  }
  
}

void handleLeftClick() {
  if (isOverTextFields()) {
    return;
  }
  
  if (isOverRect(new Point(mouseX,mouseY), buttonPos, buttonSize)) {
    repelling = true;
    return;
  }
  
  Node hoveredNode = getHoveredNode();
  
  if (hoveredNode == null && selectedNode == null) {
    //println("Adding");
    addNode();
  }
  else {
    if (selectedNode != null && hoveredNode != null) {
      //println("Adding edge");
      drawEdge(selectedNode, hoveredNode);
    }
    if (selectedNode != null) {
      //println("Deselecting");
      deselectNode(selectedNode);
    }
    if (hoveredNode != null) {
      //println("Selecting");
      selectNode(hoveredNode);
    }
  }
}

boolean isOverTextFields() {
  return isOverRect(new Point(mouseX,mouseY), redFieldPos, fieldSize)
      || isOverRect(new Point(mouseX,mouseY), greenFieldPos, fieldSize)
      || isOverRect(new Point(mouseX,mouseY), blueFieldPos, fieldSize);
}

boolean isOverRect(Point pos, Point rectPos, Size size) {
  boolean isOver = false;
  
  if (pos.x > rectPos.x && pos.x < rectPos.x+size.width
  && pos.y > rectPos.y && pos.y < rectPos.y+size.height) {
    isOver = true;
  }
  
  return isOver;
}

void handleRightClick() {
  Node hoveredNode = getHoveredNode();
  Edge hoveredHandle = getHoveredHandle();
  
  if (hoveredNode != null) {
    removeNode(hoveredNode);
  }
  else if (hoveredHandle != null) {
    removeEdge(hoveredHandle);
  }
}

void removeNode(Node node) {
  nodes.remove(node);
  
  ArrayList<Edge> edgesToRemove = new ArrayList<Edge>();
  
  for (Edge edge : edges) {
    if (edge.startNode.id == node.id || edge.endNode.id == node.id) {
      edgesToRemove.add(edge);
    }
  }
  
  for (var edge : edgesToRemove) {
    edges.remove(edge);
  }
}

void removeEdge(Edge edge) {
  edges.remove(edge);
}

void selectNode(Node node) {
  node.select();
  selectedNode = node;
  float r = red(selectedNode.fillColor);
  float g = green(selectedNode.fillColor);
  float b = blue(selectedNode.fillColor);
  redField.setText(str(int(r)));
  greenField.setText(str(int(g)));
  blueField.setText(str(int(b)));
}

void deselectNode(Node node) {
  node.deselect();
  selectedNode = null;
  redField.setText("");
  greenField.setText("");
  blueField.setText("");
}

void drawEdge(Node node1, Node node2) {
  edges.add(new Edge(edgeID, node1, node2));
  edgeID++;
}

Node getHoveredNode() {
  Node newSelection = null;
  
  for (Node node : nodes) {
    if (node.isPointOver(mouseX, mouseY)) {
      newSelection = node;
    }
  }
  
  return newSelection;
}

Edge getHoveredEdge() {
  Edge newSelection = null;
  
  for (var edge : edges) {
    if (edge.isPointOver(mouseX, mouseY)) {
      newSelection = edge;
    }
  }
  
  return newSelection;
}

Edge getHoveredHandle() {
  Edge newSelection = null;
  
  for (var edge : edges) {
    if (edge.isPointOverHandle(new Point(mouseX, mouseY))) {
      newSelection = edge;
    }
  }
  
  return newSelection;
}

void mousePressed() {
  //println("Mouse pressed");
  if (mouseButton == LEFT) {
    draggingNode = getHoveredNode();
    draggingEdge = getHoveredHandle();
    
    if (draggingNode != null) {
      dragging = true;
      //println("Started dragging node ", draggingNode.id);
    }
    else if (draggingEdge != null) {
      draggingHandle = true;
      //println("Started dragging edge handle.");
    }
  }
}

void mouseReleased() {
  //println("Mouse released");
  dragging = false;
  draggingNode = null;
  draggingHandle = false;
}
