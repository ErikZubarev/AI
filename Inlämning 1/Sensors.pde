class Sensor{
  Tank tank;
  
  Sensor(Tank t){
    this.tank = t;
  }
  
  ArrayList<Node> returnNodesAhead(){
    return new SensorResult().addNodes();
  }
  
  private class SensorResult{
     
     ArrayList<Node> addNodes(){
       String direction = tank.direction;
       Node main = tank.node;

       int col = main.col;
       int row = main.row;
       int xMultiplier = 0;
       int yMultiplier = 0;

       ArrayList<Node> nodesAhead = new ArrayList<Node>();
        switch (direction) {
          case "up":
            yMultiplier = -1;
            break;
          case "down":  
            yMultiplier = 1;
            break;
          case "left":
            xMultiplier = -1;
            break;
          case "right":
            xMultiplier = 1;
            break;
        }
        
        for(int i = 0; i < 2; i++){
          int xAdd = (xMultiplier * i);
          int yAdd = (yMultiplier * i);
          if(col + xAdd > 0 && col + xAdd < 15)
            col = col + xAdd;
          if(row + yAdd > 0 && row + yAdd < 15)
            row = row + yAdd;
          
          Node node = grid.nodes[col][row];

          if(tank.collision(node))
            break;  // Stop adding nodes if a collision is detected
          
          nodesAhead.add(node); 
        }
        
        return nodesAhead;
     }
     
   }
}
