void display(){
  displayTeams();
  displayTanks();
  displayTrees();
  displayGUI();
}

void displayGUI() {
    grid.lineDisplay();
    fill(#000000);
    textAlign(LEFT);
    textSize(18);
    text("Actions Left: " + actionCounter, 10, height-10);
  
  if(debugMode){
    grid.dotDisplay();
    
    for(Node[] nodeClump : grid.nodes){
      for(Node node : nodeClump){
        if (activeTank.path.containsKey(node)) {
          PVector v = node.position;
          
          fill(#0006FF); 
          ellipse(v.x, v.y, 10, 10);
          
          for(Node orth : activeTank.path.get(node)){
            fill(#000000);
            strokeWeight(1);   
            line(node.position.x, node.position.y, orth.position.x, orth.position.y);
          }
          
        }
      }
    }
    
    if(activeTank.shouldGoHome){
      for(Node node : pathHome){
          fill(#FEFF00); 
          ellipse(node.position.x, node.position.y, 20, 20);
      }
    }
  }
  
  if (pause) {
    fill(#D6D6D6);
    rect(width-615, height-650, 450, 400);
    fill(30);
    textAlign(CENTER);
    textSize(42);
    text("Main Menu", width/2, height/3);
    textSize(36);
    text("...Paused! \n(\'p\'-continues)", width/2, height/2);
  }
  
  if (gameOver) {
    fill(#D6D6D6);
    rect(width-615, height-650, 450, 400);
    fill(30);
    textAlign(CENTER);
    textSize(42);
    text("Main Menu", width/2, height/3);
    textSize(36);
    text("Game Over!", width/2, height/2);
  }  
}


void displayTanks() {
  for (Tank tank : allTanks) {
    tank.display();
  }
}

void displayTeams() {
  for (Team team : allTeams) {
    team.display();
  }  
}

void displayTrees() {
  for (Tree tree : allTrees) {
    tree.display();
  }
}

void displayTransition() {
    fill(#D6D6D6);
    quad(200, 275, 
         675, 275, 
         600, 425, 
         125, 425);
    fill(30);
    textAlign(CENTER);
    textSize(42);
    text("Next tanks turn! \n Tank: " + activeTankId, 400, 335);
    
    isTransitioning = true;
}

void displayHomeWait(){
    int time = 3 - (millis() - homeArrivalTime)/1000;
    fill(#D6D6D6);
    quad(200, 275, 
         675, 275, 
         600, 425, 
         125, 425);
    fill(30);
    textAlign(CENTER);
    textSize(36);
    text("Telling Teammates \nEnemy Location: " + time, 400, 335);
}

void fixTreeNodes(){
  for(Tree tree : allTrees){
    Node node = grid.getNearestNode(tree.position);
    
    node.addContent(tree);
    node.isEmpty = false;
    addOrthogonalNodesForTree(node, tree);
  }
}

void addOrthogonalNodesForTree(Node n, Tree t){
  Node north, south, west, east;
  north = grid.getNearestNode(new PVector(n.position.x, n.position.y - 50));
  south = grid.getNearestNode(new PVector(n.position.x, n.position.y + 50));
  east = grid.getNearestNode(new PVector(n.position.x + 50, n.position.y));
  west = grid.getNearestNode(new PVector(n.position.x - 50, n.position.y));
  
  north.addContent(t);
  north.isEmpty = false;
  south.addContent(t);
  south.isEmpty = false;
  east.addContent(t);
  east.isEmpty = false;
  west.addContent(t);
  west.isEmpty = false;
  
}
