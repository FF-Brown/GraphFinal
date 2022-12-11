int nodeDiameter;
ArrayList<Node> nodes;
ArrayList<Edge> edges;
Node selectedNode;
DrawingMode mode = DrawingMode.SELECT;
boolean dragging = false;
Node draggingNode;
Edge draggingEdge;
boolean draggingHandle = false;
int backgroundColor = 102;
int nodeID = 0;
int edgeID = 0;

void setup() {
  size(960, 540);
  background(backgroundColor);
  nodes = new ArrayList<Node>();
  edges = new ArrayList<Edge>();
}

void addNode() {
  Node newNode = new Node(nodeID, mouseX, mouseY);
  nodeID++;
  nodes.add(newNode);
}

void addEdge() {
  
}

void draw() {
  background(102);
  if (dragging && draggingNode != null) {
    findNodeByID(nodes, draggingNode.id).x = mouseX;
    findNodeByID(nodes, draggingNode.id).y = mouseY;
    //nodes.get(draggingNode.id).x = mouseX;
    //nodes.get(draggingNode.id).y = mouseY;
    for (Edge edge : getConnectedEdges(draggingNode)) {
      findEdgeByID(edges, edge.id).resetHandleLocation();
      //edges.get(edge.id).resetHandleLocation();
    }
  }
  else if (draggingHandle && draggingEdge != null) {
    findEdgeByID(edges, draggingEdge.id).handle.x = mouseX;
    findEdgeByID(edges, draggingEdge.id).handle.y = mouseY;
    //edges.get(draggingEdge.id).handle.x = mouseX;
    //edges.get(draggingEdge.id).handle.y = mouseY;
  }
  
  for (Edge edge : edges) {
    edge.display();
  }
  
  for (Node node : nodes) {
    node.display();
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
  Node hoveredNode = getHoveredNode();
  
  if (hoveredNode == null && selectedNode == null) {
    println("Adding");
    addNode();
  }
  else {
    if (selectedNode != null && hoveredNode != null) {
      println("Adding edge");
      drawEdge(selectedNode, hoveredNode);
    }
    if (selectedNode != null) {
      println("Deselecting");
      deselectNode(selectedNode);
    }
    if (hoveredNode != null) {
      println("Selecting");
      selectNode(hoveredNode);
    }
  }
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
}

void deselectNode(Node node) {
  node.deselect();
  selectedNode = null;
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
  println("Mouse pressed");
  if (mouseButton == LEFT) {
    draggingNode = getHoveredNode();
    draggingEdge = getHoveredHandle();
    
    if (draggingNode != null) {
      dragging = true;
      println("Started dragging node ", draggingNode.id);
    }
    else if (draggingEdge != null) {
      draggingHandle = true;
      println("Started dragging edge handle.");
    }
  }
}

void mouseReleased() {
  println("Mouse released");
  dragging = false;
  draggingNode = null;
  draggingHandle = false;
}

void mouseWheel(MouseEvent event) {
  Node hoveredNode = getHoveredNode();
  
  if (hoveredNode != null) {
    hoveredNode.fillColor += (event.getCount() * -1);
    if (hoveredNode.fillColor < 0) {
      hoveredNode.fillColor = 255;
    }
    if (hoveredNode.fillColor > 255) {
      hoveredNode.fillColor = 0;
    }
  }
}
