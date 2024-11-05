class Tree extends Sprite {
  
  PVector position;
  String  name; 
  PImage  img;
  float   diameter;
  
  //**************************************************
  Tree(PImage _image, PVector p) {
    
    this.img       = _image;
    this.diameter  = this.img.width/2;
    this.name      = "tree";
    this.position  = p;
    
  }

  //**************************************************  
  void display() {
      displayTree();
  }
  
  // Följande bör ligga i klassen Tree
  void displayTree() {
    imageMode(CENTER);
    image(img, position.x, position.y);
  }
}
