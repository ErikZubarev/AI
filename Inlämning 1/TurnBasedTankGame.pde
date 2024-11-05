import java.util.HashSet;
import java.util.PriorityQueue;

// Mechanics ##################################
boolean gameOver = false;
boolean pause = false;
boolean debugMode = false;

Tree[] allTrees   = new Tree[3];
Tank[] allTanks   = new Tank[6];
Team[] allTeams   = new Team[2];

Grid grid;
Node GOAL_NODE;

ArrayList<Node> pathHome; 
boolean isWaitingAtHome = false;
int homeArrivalTime = 0;             // Home delay timer
int homeWaitTime = 3000;             // 3 second wait when at home

int transitionStartTime = 0;         // Action delay timer;
int turnTransitionWait = 1000;       // 1 second turn transition
int defaultActions = 20;             // Default number of actions per turn
int actionCounter;                   // Actions left
boolean isTransitioning = false;

//Obsticles ##################################
PImage tree_img;
PVector tree0_pos, tree1_pos, tree2_pos;
Tree tree0, tree1, tree2;

//Tanks ##################################
Tank activeTank;
int activeTankId = 0;

// Team0
Team team0;
color team0Color;
PVector team0_tank0_startpos;
PVector team0_tank1_startpos;
PVector team0_tank2_startpos;
Tank tank0, tank1, tank2;

// Team1
Team team1;
color team1Color;
PVector team1_tank0_startpos;
PVector team1_tank1_startpos;
PVector team1_tank2_startpos;
Tank tank3, tank4, tank5;

//======================================
void setup() 
{
  size(800, 800);
  
  int cols = 15;
  int rows = 15;
  int grid_size = 50;
  
  grid = new Grid(cols, rows, grid_size);
  GOAL_NODE = grid.nodes[0][0];
  
  // Trad
  tree_img = loadImage("tree01_v2.png");
  tree0_pos = new PVector(250, 600);
  tree1_pos = new PVector(250, 200);
  tree2_pos = new PVector(500, 500);
  
  tree0 = new Tree(tree_img, tree0_pos);
  tree1 = new Tree(tree_img, tree1_pos);
  tree2 = new Tree(tree_img, tree2_pos);

  int tank_size = 50;
  
  // Team0
  team0Color  = color(204, 50, 50);             // Base Team 0(red)
  
  team0_tank0_startpos  = new PVector(50, 50);
  team0_tank1_startpos  = new PVector(50, 150);
  team0_tank2_startpos  = new PVector(50, 250);
  
  tank0 = new Tank("tank0", team0_tank0_startpos,tank_size, team0Color );
  tank1 = new Tank("tank1", team0_tank1_startpos,tank_size, team0Color );
  tank2 = new Tank("tank2", team0_tank2_startpos,tank_size, team0Color );
  
  team0 = new Team(team0Color, 0, 0);
  team0.addTank(tank0);
  team0.addTank(tank1);
  team0.addTank(tank2);
  
  // Team1
  team1Color  = color(0, 150, 200);             // Base Team 1(blue)
  team1_tank0_startpos  = new PVector(width-50, height-250);
  team1_tank1_startpos  = new PVector(width-50, height-150);
  team1_tank2_startpos  = new PVector(width-50, height-50);
  
  tank3 = new Tank("tank3", team1_tank0_startpos,tank_size, team1Color );
  tank4 = new Tank("tank4", team1_tank1_startpos,tank_size, team1Color );
  tank5 = new Tank("tank5", team1_tank2_startpos,tank_size, team1Color );
  
  team1 = new Team(team1Color, width - 151, height - 351);
  team1.addTank(tank3);
  team1.addTank(tank4);
  team1.addTank(tank5);
  
  allTrees[0] = tree0;
  allTrees[1] = tree1;
  allTrees[2] = tree2;
  
  allTeams[0] = team0;
  allTeams[1] = team1;
  
  allTanks[0] = tank0;
  allTanks[1] = tank1;
  allTanks[2] = tank2;
  allTanks[3] = tank3;
  allTanks[4] = tank4;
  allTanks[5] = tank5;
  
  actionCounter = defaultActions;
  
  fixTreeNodes();
  
  // Initializing tank stats
  activeTank = tank0;
  activeTankId = 0;
  activeTank.disabled = false;
  activeTank.node.removeContent(); // So that tank can walk on it's own node
  activeTank.seeAhead();
}

void draw()
{
  background(#B5E3BF);
  checkForInput();
  display();
  
  if (gameOver || pause)
    return;
  
  // Transition between different tanks' turns
  if(isTransitioning){
    if(millis() - transitionStartTime >= turnTransitionWait){ // If transition wait time (1 second) has passed
      isTransitioning = false;
      updateTanksLogic(); 
    }
    else displayTransition();
    
    return;
  }
  
  // Tank has arrived home after A* search and tells team-mates about enemy location
  if(isWaitingAtHome){
     if(millis() - homeArrivalTime >= homeWaitTime) // If home wait time (3 seconds) has passed
       isWaitingAtHome = false;
     
     displayHomeWait();
     return;
  }
  
  updateTanksLogic();  
}

//======================================
void updateTanksLogic() {
  if(actionCounter != 0 && !activeTank.disabled){
    activeTank.update();
  }
  else{
      println("Next Players turn");
      activeTank.updateNode(activeTank.node);
      transitionStartTime = millis();
      displayTransition();
     
     // Ugly implementation of which tanks turn is next
     if(activeTankId + 1 >= allTanks.length){
       println("Player 0 turn");
       activeTank = allTanks[0];
       activeTankId = 0;
     }
     else{
       activeTank = allTanks[activeTankId + 1];
       activeTankId ++;
       println("Player "+ activeTankId +  " turn");
     }
     
     // Make sure tank cant collide with its own node
     activeTank.startNode.removeContent();
     actionCounter = defaultActions;
   }
}
