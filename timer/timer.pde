



// Global parameters
int cx, cy;
//int[] canvasSize;

float arcRadius;
float timerDiameter;

float startTime;
float countdownTime;

float minLeft;
float minOriginal;

float residualTime;

int[] timeButtonValues;
int[] timeButtonPlacementX;
int[] timeButtonPlacementY;
int[] timeButtonSize;

void setup() {
  //int[] canvasSize = {620, 820};
  size(620, 820);
  
  int radius = min(width, height) / 3;
  timerDiameter = radius * 2.0;
  arcRadius = radius * 1.8;
  
  // Position of clock (center)
  cx = width / 2;
  cy = height / 2;
  
  startTime = 0; //millis()/1000.0;
  countdownTime = 0; //20 * 1000.0;

  int[] timeButtonValues = { 1, 3, 5, 7 };
  int[] timeButtonSize = { 45, 25 };

  // Generate button placenements (future in a function??)
  int l = timeButtonValues.length;
  int[] timeButtonPlacementX = new int[l];
  int[] timeButtonPlacementY = new int[l];

  int x0 = int(620*0.8);
  int y0 = int(820*0.15);
  for (int i = 0; i < l; i = i+1) {
    timeButtonPlacementX[i] = x0;
    timeButtonPlacementY[i] = y0 + i*(timeButtonSize[1] + 20);
  }
  //generateButtonPlacement();


}


void draw() {
  // Background colour
  background(30, 30, 30);
  textSize(56);

  // Draw the clock/timer background
  fill(40,40,40); //80
  noStroke(); // No outline
  ellipse(cx, cy, timerDiameter, timerDiameter);
  
  drawTimeButtons();

  // Draw buttons for adding different times??

  float currentTime = millis()/1000.0;
  residualTime = countdownTime - (currentTime - startTime);

  if (residualTime > 1e-5) { //i.e. there is time left
    drawCountdown();
  }

  else if ((startTime <1e-5) && (startTime>-1e-5)) { // Wait for added time/click.
    fill(72, 128, 166);
    textSize(56);
    text("click to start", 0.5*cx, 70);
  }

  else { // If residual is negative, i.e. recently ran out.
    resetTimer();
  }
  endShape();
}

void mousePressed() { // if mousepressed, then reset start-time and add 5 min.
  // Check if its on a button.
  
  countdownTime += 0.2*60 ;
  if (startTime<1e-5) {
    startTime = millis()/1000.0;
  }
}

void resetTimer() {
  countdownTime = 0;
  startTime = 0;
}

void drawCountdown() { // Draw timer countdown!

  float residualTimeMinutes = residualTime/60.;
  float residualTimeSeconds = residualTime-int(residualTimeMinutes)*60;

  fill(45, 45, 45);
  minOriginal = map(countdownTime/60., 0, 60, 0, TWO_PI);
  arc(cx, cy, arcRadius, arcRadius, -HALF_PI, minOriginal-HALF_PI);
    
  fill(72, 128, 166);
  textSize(56);
  text(int(residualTimeMinutes)+":"+nf(int(residualTimeSeconds), 2), cx-15,70);
  minLeft = map(residualTime/60., 0, 60, 0, TWO_PI); // from min to rad
  arc(cx, cy, arcRadius, arcRadius, -HALF_PI, minLeft-HALF_PI); // draw arc
}



void button(int x, int y, int dimX, int dimY, String buttonText) {
  fill(110, 110, 110);
  rect(x, y, dimX, dimY);
  textSize(25);
  fill(0,0,30);
  text(buttonText, x+(0.1*dimX), y+(0.9*dimY));
}

boolean overRect(int x, int y, int dimX, int dimY) {
  if (mouseX > x && mouseX < x+dimX && mouseY > y && mouseY < y+dimY){
    return true;
  } else {return false;}
}

void drawTimeButtons() {
  //button(500,40, 40, 40, "hello");
  //int x = timeButtonPlacementX[0];
  //int y = timeButtonPlacementY[0];

  button(timeButtonPlacementX[0], timeButtonPlacementY[0], timeButtonPlacementX[0], timeButtonPlacementY[0], str(timeButtonValues[0]));
}


void generateButtonPlacement() {
  int l = timeButtonValues.length;
  int[] timeButtonPlacementX = new int[l];
  int[] timeButtonPlacementY = new int[l];

  int x0 = int(620*0.8);
  int y0 = int(820*0.15);

  for (int i = 0; i < l; i = i+1) {
    timeButtonPlacementX[i] = x0;
    timeButtonPlacementY[i] = y0 + i*(timeButtonSize[1] + 20);
  }

}