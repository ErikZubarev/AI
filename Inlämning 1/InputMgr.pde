//======================================
boolean left, right, up, down;

void checkForInput() {
  if (!pause && !gameOver) {
    if(up){
      activeTank.state = 1;
    }
    if(down){
      activeTank.state = 2;
    }
    if(left){
      activeTank.state = 3;
    }
    if(right){
      activeTank.state = 4;
    }
  }
}

//======================================
void keyPressed() {

    if (key == CODED) {
      switch(keyCode) {
      case LEFT:
        left = true;
        break;
      case RIGHT:
        right = true;
        break;
      case UP:
        up = true;
        break;
      case DOWN:
        down = true;
        break;
      }
    }

}

void keyReleased() {
    if (key == CODED) {
      switch(keyCode) {
      case LEFT:
        left = false;
        break;
      case RIGHT:
        right = false;
        break;
      case UP:
        up = false;
        break;
      case DOWN:
        down = false;
        break;
      }
      tank0.state = 0;
    }
    
    if (key == 'p') {
      pause = !pause;
    }
    if(key == 'd') {
      debugMode = !debugMode; 
    }
}

/*
// Mousebuttons
void mousePressed() {
  println("---------------------------------------------------------");
  println("*** mousePressed() - Musknappen har tryckts ned.");
  
  mouse_pressed = true;
  
}
*/
