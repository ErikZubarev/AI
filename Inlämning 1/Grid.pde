class Grid {
  int cols, rows;
  int grid_size;
  Node[][] nodes;

  //***************************************************  
  Grid(int _cols, int _rows, int _grid_size) {
    cols = _cols;
    rows = _rows;
    grid_size = _grid_size;
    nodes = new Node[cols][rows];

    createGrgetId();
  }

  //***************************************************  
  void createGrgetId() {

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Initialize each object
        nodes[i][j] = new Node(i, j, i*grid_size+grid_size, j*grid_size+grid_size);
      }
    }
  }

  //***************************************************  
  void lineDisplay() {
    strokeWeight(1);
    line(cols*grid_size+grid_size - 25, 0, cols*grid_size+grid_size - 25, height);
    line(0, rows*grid_size+grid_size - 25, width, rows*grid_size+grid_size - 25);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Initialize each object
        line(j*grid_size+grid_size - 25, 0, j*grid_size+grid_size - 25, height);
      }
      line(0, i*grid_size+grid_size - 25, width, i*grid_size+grid_size - 25);
    }
  }

  //***************************************************  
  void dotDisplay() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Initialize each object
        fill(#000000, 10);
        ellipse(nodes[i][j].position.x, nodes[i][j].position.y, 5.0, 5.0);
      }
    }
  }

  //***************************************************  
  Node getNearestNode(PVector pvec) {
    // En justering för extremvärden.
    float tempx = pvec.x;
    float tempy = pvec.y;
    if (pvec.x < 5) { 
      tempx=5;
    } else if (pvec.x > width-5) {
      tempx=width-5;
    }
    if (pvec.y < 5) { 
      tempy=5;
    } else if (pvec.y > height-5) {
      tempy=height-5;
    }

    pvec = new PVector(tempx, tempy);

    ArrayList<Node> nearestNodes = new ArrayList<Node>();

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (nodes[i][j].position.dist(pvec) < grid_size) {
          nearestNodes.add(nodes[i][j]);
        }
      }
    }

    Node nearestNode = new Node(0, 0);
    for (int i = 0; i < nearestNodes.size(); i++) {
      if (nearestNodes.get(i).position.dist(pvec) < nearestNode.position.dist(pvec) ) {
        nearestNode = nearestNodes.get(i);
      }
    }

    return nearestNode;
  }
  
  //***************************************************  
  PVector getNearestNodePosition(PVector pvec) {
    Node n = getNearestNode(pvec);
    
    return n.position;
  }

  //***************************************************  
  void displayNearestNode(float x, float y) {
    PVector pvec = new PVector(x, y);
    displayNearestNode(pvec);
  }

  //***************************************************  
  void displayNearestNode(PVector pvec) {

    PVector vec = getNearestNodePosition(pvec);
    fill(#FFFFFF); 
    ellipse(vec.x, vec.y, 10, 10);
  }

  //***************************************************  
  PVector getRandomNodePosition() {
    int c = int(random(cols));
    int r = int(random(rows));

    PVector rn = nodes[c][r].position;

    return rn;
  }
  
}
