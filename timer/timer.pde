



// Global parameters
int cx, cy;
//int[] canvasSize;

float arcDiameter;
float timerDiameter;

float startTime;
float countdownTime;

float minLeft;
float minOriginal;

float residualTime;

IntList tButtonVal;
IntList tButtonX;
IntList tButtonY;
IntList tButtonSize;

void setup() {
  //int[] canvasSize = {620, 820};
  size(620, 820);
  
  int radius = min(width, height) / 3;
  timerDiameter = radius * 2.0;
  arcDiameter = radius * 1.8;
  
  // Position of clock (center)
  cx = width / 2;
  cy = height / 2;
  
  startTime = 0; //millis()/1000.0;
  countdownTime = 0; //20 * 1000.0;

  tButtonVal = new IntList( 1, 3, 5, 7 );
  tButtonSize = new IntList( 45, 25 );

  // Generate button placenements (future in a function??)
  //int l = tButtonVal.length;
  //int[] timeButtonPlacementX = new int[l];
  //int[] timeButtonPlacementY = new int[l];

  //int x0 = int(620*0.8);
  //int y0 = int(820*0.15);
  //for (int i = 0; i < l; i = i+1) {
  //  timeButtonPlacementX[i] = x0;
  //  timeButtonPlacementY[i] = y0 + i*(tButtonSize[1] + 20);
  //}
  findTButtonXY();


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
  drawResetButton();
  drawTicks();

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
  
  // Check if its on a time-button.
  for (int i=0;i<tButtonVal.size();i=i+1) {
    if(overRect(tButtonX.get(i), tButtonY.get(i), tButtonSize.get(0), tButtonSize.get(1))){
      countdownTime += tButtonVal.get(i)*60;
      if (startTime<1e-5) {
        startTime = millis()/1000.0;
      }
    }
  }
  
  // Check reset-button
  if (overRect(20,20,60,30)){
    resetTimer();
  }
}

void drawTicks() {
  beginShape(LINES);
  strokeWeight(4);
  fill(100,100,150);
  textSize(25);
  for (int i = 0; i <59; i=i+5) {
    float angle = map (i, 0, 60,-HALF_PI, TWO_PI-HALF_PI);
    float x = cx + cos(angle) * arcDiameter*0.7;
    float y = cy + sin(angle) * arcDiameter*0.7;
    vertex(x, y);
    
    text(i, x - 15, y + 13);
    }
  endShape();
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
  arc(cx, cy, arcDiameter, arcDiameter, -HALF_PI, minOriginal-HALF_PI);
    
  fill(72, 128, 166);
  textSize(56);
  text(int(residualTimeMinutes)+":"+nf(int(residualTimeSeconds), 2), cx-15,70);
  minLeft = map(residualTime/60., 0, 60, 0, TWO_PI); // from min to rad
  arc(cx, cy, arcDiameter, arcDiameter, -HALF_PI, minLeft-HALF_PI); // draw arc
}



void drawRectButton(String buttonText, int x, int y, int dimX, int dimY) {
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
  int dimX = tButtonSize.get(0);
  int dimY = tButtonSize.get(1);
  for (int i=0;i<tButtonVal.size();i=i+1){
    drawRectButton(str(tButtonVal.get(i)), tButtonX.get(i), tButtonY.get(i), dimX, dimY);
  }
}

void drawResetButton(){
  drawRectButton("Reset", 20,20,60,30);
}


void findTButtonXY() {
  //int l = tButtonVal.size();
  tButtonX = new IntList();
  tButtonY = new IntList();

  int x0 = int(620*0.8);
  int y0 = int(820*0.15);

  for (int i = 0; i < tButtonVal.size(); i = i+1) {
    tButtonX.append(x0);
    tButtonY.append(y0 + i*(tButtonSize.get(1) + 20));
  }
}