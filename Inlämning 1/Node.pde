class Node implements Comparable<Node>{
  // A node object knows about its location in the grid 
  // as well as its size with the variables x,y,w,h
  float x,y;   // x,y location
  float w,h;   // width and height
  
  PVector position;
  int col, row;
  
  Sprite content;
  boolean isEmpty;
  
  //***************************************************
  // Node Constructor 
  // Denna används för temporära jämförelser mellan Node objekt.
  Node(float _posx, float _posy) {
    this.position = new PVector(_posx, _posy);
  }

  //***************************************************  
  // Används vid skapande av grid
  Node(int _id_col, int _id_row, float _posx, float _posy) {
    this.position = new PVector(_posx, _posy);
    this.col = _id_col;
    this.row = _id_row;
    
    this.content = null;
    this.isEmpty = true;
  } 

  //***************************************************  
  void addContent(Sprite s) {
    this.content = s;  
  }
  
    //***************************************************
  void removeContent() {
    this.content = null;
    this.isEmpty = true;
  }

  //***************************************************
  boolean empty() {
    return this.isEmpty;
  }
  
  //***************************************************
  Sprite content() {
    return this.content;
  }
  
  @Override
  public int compareTo(Node other) {
    if (this.position.x != other.position.x) {
      return Float.compare(this.position.x, other.position.x);
    } else {
      return Float.compare(this.position.y, other.position.y);
    }
  }
}
