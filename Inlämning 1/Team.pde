class Team {
  ArrayList<Tank> tanks;
  color teamColor;
  int posX;
  int posY;
  
  Team(color c, int x, int y){
    this.teamColor = c;
    this.posX = x;
    this.posY = y;
    tanks = new ArrayList<Tank>();
  }
  
  void addTank(Tank t){
   tanks.add(t); 
  }
  
//======================================
void displayHomeBase() {
  strokeWeight(2);

  fill(teamColor, 100);
  rect(posX, posY, 150, 350);
}
  
  void display() {
    displayHomeBase();
  }
}
