class Tank extends Sprite {
  String name;
  PImage img;
  color col;
  String direction;
  float diameter;
  int state;
  boolean disabled; //For unmovable tanks
  
  PVector position;
  PVector startpos;
  Node node;
  Node startNode;
  
  boolean done; // Done going back home (can't A* search home twice in the same game)
  boolean shouldGoHome;
  int pathIndex = 0;
  
  Sensor sensor;
  HashMap<Node, ArrayList<Node>> path; // Map av varje nod till ArrayLista av dess ortogonala grannar. 

  //======================================  
  Tank(String _name, PVector _startpos, float _size, color _col ) {
    this.name         = _name;
    this.diameter     = _size;
    this.col          = _col;

    this.startpos     = new PVector(_startpos.x, _startpos.y);
    this.position     = new PVector(this.startpos.x, this.startpos.y);
    
    this.state        = 0;
    this.direction    = "right";
    this.node         = grid.getNearestNode(_startpos);
    this.startNode    = node;
    this.path         = new HashMap<>();
    this.sensor       = new Sensor(this);
    this.shouldGoHome = false;
    this.done         = false;
    this.disabled     = true;
    
    startNode.addContent(this);
    startNode.isEmpty = false;
}
  
//======================================
  void update() {
    if(shouldGoHome){
      goHome();
    }
    else {
      // 1(up), 2, (down), 3(left), 4(right)
      switch (state) {
        case 1:
          action("up");
          break;
        case 2:
          action("down");
          break;
        case 3:
          action("left");
          break;
        case 4:
          action("right");
          break;
      } 
    } 
  }
  
  void action(String _action) {
    direction = _action;
    int col = this.node.col;
    int row = this.node.row;
    
    switch (_action) {
      case "up":
        if(row > 0)
          row = row - 1;
        break;
      case "down":  
        if(row < 14)
          row = row + 1;
        break;
      case "left":
        if(col > 0)
          col = col - 1;
        break;
      case "right":
        if(col < 14)
          col = col + 1;
        break;
    }
    
    Node nextNode = grid.nodes[col][row];
    
    if(!collision(nextNode)){ //<>//
      this.position = nextNode.position;
      this.node = nextNode;
      actionCounter --;
    }
    
    
    seeAhead();
    delay(100);
  }
  
  void goHome(){
    Node target = pathHome.get(pathIndex);

    if (node.x < target.x) {
      action("right");
    } else if (node.position.x > target.position.x) {
      action("left");
    } else if (node.position.y < target.position.y) {
      action("down");
    } else if (node.position.y > target.position.y) {
      action("up");
    }
    
    if (node.equals(target)) {
      pathIndex++;
      if (pathIndex >= pathHome.size()) {
        shouldGoHome = false;
        pathHome = null;
        pathIndex = 0;
        done = true;
        
        homeArrivalTime = millis();
        isWaitingAtHome = true;
      }
    } 
  }
    
  boolean collision(Node n) { //<>//
    float x = n.position.x; //<>//
    float y = n.position.y;
    
    if(x >= width || x <= 0 || y >= height || y <= 0)
      return true;
    else if(!n.isEmpty){
      return true;
    }
    else
      return false;
  } 
  
  void updateNode(Node n){
    this.startNode.removeContent();
    
    n.isEmpty = false;
    n.addContent(this);
    startNode = n;
  }
  
  void seeAhead() {
    ArrayList<Node> nodesAhead = sensor.returnNodesAhead();

    for (Node node : nodesAhead) {
      
      if (!path.containsKey(node)) {
        path.put(node, new ArrayList<Node>());
      }
  
      ArrayList<Node> orthogonalNodes = getOrthogonalNodes(node);
      for (Node orthogonalNode : orthogonalNodes) {
        if(!shouldGoHome 
            && !done
            && orthogonalNode.content() instanceof Tank 
            && team1.tanks.contains((Tank) orthogonalNode.content()))
        {
          shouldGoHome = true;
          pathHome = aStarSearch(this.node, GOAL_NODE);
          break;
        }
        if(!collision(orthogonalNode)){
          
          if (!path.containsKey(orthogonalNode)) {
            path.put(orthogonalNode, new ArrayList<Node>());
          }
          if (!path.get(node).contains(orthogonalNode)) {
            path.get(node).add(orthogonalNode);
          }
          if (!path.get(orthogonalNode).contains(node)) {
            path.get(orthogonalNode).add(node);
          }
        }
      }
    }
  } //<>//
    
  ArrayList<Node> getOrthogonalNodes(Node node) {
    ArrayList<Node> orthogonalNodes = new ArrayList<Node>();
    orthogonalNodes.add(grid.getNearestNode(new PVector(node.position.x + 50, node.position.y)));
    orthogonalNodes.add(grid.getNearestNode(new PVector(node.position.x - 50, node.position.y)));
    orthogonalNodes.add(grid.getNearestNode(new PVector(node.position.x, node.position.y + 50)));
    orthogonalNodes.add(grid.getNearestNode(new PVector(node.position.x, node.position.y - 50)));
    return orthogonalNodes;
  }  //<>//
  
//====================================== 
  void display() {
    fill(this.col);
    strokeWeight(1);
    
    pushMatrix();
    
      translate(this.position.x, this.position.y);
      
      imageMode(CENTER);
      drawTank(0, 0, direction);
      imageMode(CORNER);
      
      if(debugMode){
        strokeWeight(1);
        fill(230);
        rect(0+25, 0-25, 100, 40);
        fill(30);
        textSize(15);
        textAlign(LEFT);
        text(this.name +"\n( " + this.position.x + ", " + this.position.y + " )", 25+5, -5-5);
      }
    
    popMatrix();
  }
  
    void drawTank(float x, float y, String direction) {
    //Bas
    fill(this.col); 
    ellipse(x, y, 50, 50);
    
    //kanontornet
    ellipse(0, 0, 25, 25);
    strokeWeight(3);   
    float cannon_length = this.diameter/2;
    
    switch (direction){
      case "up":
        line(0, 0, 0, -cannon_length);
        break;
      case "down":
        line(0, 0, 0, cannon_length);
        break;
      case "left":
        line(0, 0, -cannon_length, 0);
        break;
      case "right":
        line(0, 0, cannon_length, 0);
        break;  
    }    
  }
  
  ArrayList<Node> aStarSearch(Node start, Node goal){
    PriorityQueue<Node> frontier = new PriorityQueue<>(); // Frontier i algoritmen
    HashMap<Node, Node> cameFrom = new HashMap<>();      // Håller koll på ev. korrekt väg hem
    HashMap<Node, Float> gScore = new HashMap<>();       // g(n) : avstånd från start
    HashMap<Node, Float> fScore = new HashMap<>();       // f(n) : g(n) + h(n)
    HashSet<Node> visitedNodes = new HashSet<>();    
    final int distanceBetweenNodes = 1;                  // Avståndet från nod till nod är alltid 1. 
    
    // Okänt värde på g(n) och f(n) för alla noder...
    for (ArrayList<Node> nodes : path.values()) {
      for (Node node : nodes) {
        gScore.put(node, Float.POSITIVE_INFINITY);
        fScore.put(node, Float.POSITIVE_INFINITY);
      }
    }

    // ...förrutom startnoden som har g(n) = 0, och f(n) = h(n) (eller manhattan avståndet)
    gScore.put(start, 0f);
    fScore.put(start, ManhattanDistance(start, goal));

    frontier.add(start);

    while (!frontier.isEmpty()) {
      Node current = getLowestFScoreNode(frontier, fScore);

      if (current.equals(goal)) 
        return reconstructPath(cameFrom, current); // Klar
      
      frontier.remove(current); // Ta bort från frontier
      visitedNodes.add(current); // Lägg till i visited

      // För varje ortogonalt ansluten node till current
      for (Node neighbor : path.get(current)) {
        if (visitedNodes.contains(neighbor))
          continue;  // Ignorera om redan kollat på noden

        float tentativeGScore = gScore.get(current) + distanceBetweenNodes; // för jämförelse

        if (!frontier.contains(neighbor))
          frontier.add(neighbor);
        else if (tentativeGScore >= gScore.get(neighbor)) 
          continue;  // Denna väg är dålig, ignorera

        // Bästa vägen så länge, registrera det
        cameFrom.put(neighbor, current);
        gScore.put(neighbor, tentativeGScore);
        fScore.put(neighbor, gScore.get(neighbor) + ManhattanDistance(neighbor, goal));
      }
    }

    // Frontier var tomt men algoritmen hittade aldrig mål noden
    return null;
  }

  // Passande eftersom det är grid-baserat spel
  float ManhattanDistance(Node n, Node goal) {
    return abs(n.x - goal.x) + abs(n.y - goal.y);  
  }
  
  Node getLowestFScoreNode(PriorityQueue<Node> frontier, HashMap<Node, Float> fScore) {
    Node lowestFScoreNode = null;
    float lowestFScore = Float.POSITIVE_INFINITY;

    for (Node node : frontier) {
      float nodeFScore = fScore.get(node);
      if (nodeFScore < lowestFScore) {
        lowestFScore = nodeFScore;
        lowestFScoreNode = node;
      }
    }

    return lowestFScoreNode;
  }

  ArrayList<Node> reconstructPath(HashMap<Node, Node> cameFrom, Node current) {
    ArrayList<Node> totalPath = new ArrayList<>();
    totalPath.add(current);

    while (cameFrom.containsKey(current)) {
      current = cameFrom.get(current);
      totalPath.add(0, current);  // Insert at the beginning
    }

    return totalPath;
  }
}
