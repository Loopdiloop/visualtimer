



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
float residualTimeSeconds;

IntList tButtonVal;
IntList tButtonX;
IntList tButtonY;
IntList tButtonSize;

IntDict resetButton;

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

  tButtonVal = new IntList( 1, 5, 15, 20 );
  tButtonSize = new IntList( 45, 25 );

  // x, y, dimX, dimY
  resetButton = new IntDict();
  resetButton.set("x",20);
  resetButton.set("y",20);
  resetButton.set("dimX", 70);
  resetButton.set("dimY",30);


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

  fill(40,40,40); //80
  noStroke(); // No outline
  ellipse(cx, cy, arcDiameter, arcDiameter);
  

  // Draw buttons for adding different times??

  float currentTime = millis()/1000.0;
  residualTime = countdownTime - (currentTime - startTime);

  if (residualTime > 1e-5) { //i.e. there is time left
    drawCountdownMinutes();
    drawCountdownSeconds();
  }

  else if ((startTime <1e-5) && (startTime>-1e-5)) { // Wait for added time/click.
    fill(72, 128, 166);
    textSize(48);//56);
    text("Add time to start", 0.5*cx, 70);
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
  fill(100,100,150);
  textSize(25);
  for (int i = 0; i <59; i=i+5) {
    float tick = map(i, 0, 60, -HALF_PI, TWO_PI-HALF_PI);
    arc(cx, cy, arcDiameter*1.11, arcDiameter*1.11, tick-1./180, tick+1./180); 
    text(i, cx+cos(tick)*arcDiameter*0.63-13, cy+sin(tick)*arcDiameter*0.63+15);
    }
}

void resetTimer() {
  countdownTime = 0;
  startTime = 0;
}

void drawCountdownMinutes() { // Draw timer countdown!

  float residualTimeMinutes = residualTime/60.;
  residualTimeSeconds = residualTime-int(residualTimeMinutes)*60;
  
  // minutes shadow
  fill(45, 45, 45);
  minOriginal = map(countdownTime/60., 0, 60, 0, TWO_PI);
  arc(cx, cy, arcDiameter, arcDiameter, -HALF_PI, minOriginal-HALF_PI);

  // minutes current
  fill(72, 128, 166);
  textSize(56);
  text(int(residualTimeMinutes)+":"+nf(int(residualTimeSeconds), 2), cx-35,70);
  minLeft = map(residualTime/60., 0, 60, 0, TWO_PI); // from min to rad
  //minLeft = map(int(residualTime/60.), 0, 60, 0, TWO_PI); 
  arc(cx, cy, arcDiameter, arcDiameter, -HALF_PI, minLeft-HALF_PI); // draw arc
}

void drawCountdownSeconds() {
  // seconds current
  float secLeft;
  strokeWeight(3);
  fill(72, 148, 186);
  secLeft = map(residualTimeSeconds, 0, 60, 0, TWO_PI); // from min to rad
  //arc(cx, cy, arcDiameter*0.5, arcDiameter*0.5, -HALF_PI, secLeft-HALF_PI); // draw arc
  line(cx, cy, cx + cos(secLeft) * arcDiameter*0.5, cy + sin(secLeft) * arcDiameter*0.5);
}





boolean overRect(int x, int y, int dimX, int dimY) {
  if (mouseX > x && mouseX < x+dimX && mouseY > y && mouseY < y+dimY){
    return true;
  } else {return false;}
}

void drawTimeButtons() {
  textSize(25);
  int dimX = tButtonSize.get(0);
  int dimY = tButtonSize.get(1);
  for (int i=0;i<tButtonVal.size();i=i+1){
    //drawRectButton(str(tButtonVal.get(i)), tButtonX.get(i), tButtonY.get(i), dimX, dimY);
    fill(110, 110, 110);
    rect(tButtonX.get(i), tButtonY.get(i), dimX, dimY, 5);
    fill(0,0,30);
    text("+"+tButtonVal.get(i), tButtonX.get(i)+(0.1*dimX), tButtonY.get(i)+(0.88*dimY));
  }
}

void drawResetButton(){
  int x = resetButton.get("x");
  int y = resetButton.get("y");
  int dimX = resetButton.get("dimX");
  int dimY = resetButton.get("dimY");
  textSize(25);
  fill(110, 110, 110);
  //rect(resetButton.get("x"), resetButton.get("y"), resetButton.get("dimX"), resetButton.get("dimY"));
  rect(x, y, dimX, dimY, 5);
  fill(0,0,30);
  text("Reset", x+(0.1*dimX), y+(0.88*dimY));
  //drawRectButton("Reset", 20,20,60,30);
}

void findTButtonXY() {
  //int l = tButtonVal.size();
  tButtonX = new IntList();
  tButtonY = new IntList();

  int x0 = int(620*0.9);
  int y0 = int(820*0.08);

  for (int i = 0; i < tButtonVal.size(); i = i+1) {
    tButtonX.append(x0);
    tButtonY.append(y0 + i*(tButtonSize.get(1) + 15));
  }
}










void drawRectButton(String buttonText, int x, int y, int dimX, int dimY) {
  fill(110, 110, 110);
  rect(x, y, dimX, dimY);
  textSize(25);
  fill(0,0,30);
  text(buttonText, x+(0.1*dimX), y+(0.9*dimY));
}