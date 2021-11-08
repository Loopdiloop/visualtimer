



// Global parameters

int cx, cy; // Center of timer

float arcDiameter; // Diam?? of minute arc
float timerDiameter; // Diam?? of timer

IntDict colorTick; //randomise the color of tics
IntDict colorArc; //randomise the color of timer

float startT;
float countdownT;

//float minLeft; // Radian Minutes left to count.
//float minOriginal; // Radian Total countdown since reset.

float residualT; // Time left of countdown
float residualTSec; // Residual time, but only seconds.
float minLeft;

// Parameters for time-buttons. Values, coord xy, size.
IntList tButtonVal;
IntList tButtonX;
IntList tButtonY;
IntDict tButtonSize;

IntDict resetButton;

void setup() {

  size(620, 820);

  int radius = min(width, height) / 3;
  timerDiameter = radius * 2.0;
  arcDiameter = radius * 1.8;
  
  colorArc = new IntDict();
  colorTick = new IntDict();
  resetColors();

  // Position of clock (center)
  cx = width / 2;
  cy = height / 2;
  
  // Set init param of times
  startT = 0; //millis()/1000.0;
  countdownT = 0; //20 * 1000.0;

  // Parameters for reset-button
  resetButton = new IntDict();
  resetButton.set("x", 20);
  resetButton.set("y", 20);
  resetButton.set("dimX", 70);
  resetButton.set("dimY", 30);

  // Parameters for time-buttons + set placements
  tButtonVal = new IntList( 1, 5, 15, 20 );
  tButtonSize = new IntDict();
  tButtonSize.set("x", 45 );
  tButtonSize.set("y", 25 );
  findTButtonXY();

}

void draw() {
  // Background colour
  background(30, 30, 30);
  textSize(56);

  // Draw the clock/timer background
  fill(40,40,40);//colorTick.get("R"), colorTick.get("G"), colorTick.get("B"));
  noStroke(); // No outline
  ellipse(cx, cy, timerDiameter, timerDiameter);
  
  drawTimeButtons();
  drawResetButton();
  drawTicks();

  float currentTime = millis()/1000.0;
  residualT = countdownT - (currentTime - startT);

  if (residualT > 1e-5) { //i.e. there is time left
    drawCountdownMinutes();
    drawCountdownSeconds();
  }

  else if ((startT <1e-5) && (startT>-1e-5)) { // Wait for added time/click.
    fill(72, 128, 166);
    textSize(48);
    text("Add time to start", 0.5*cx, 70);
  }

  else { // If residual is negative, i.e. recently ran out.
    reset();
  }
  textSize(20);
  fill(40);
  text("Visualtimer by @loopdiloop", cx, 2*cy-30);
}

void mousePressed() { 
  // if mousepressed, check if its above a button.
  
  // Check time-buttons
  for (int i=0;i<tButtonVal.size();i=i+1) {
    if(overRect(tButtonX.get(i), tButtonY.get(i), tButtonSize.get("x"), tButtonSize.get("y"))){
      countdownT += tButtonVal.get(i)*60;
      if (startT<1e-5) {
        startT = millis()/1000.0;
  }}}

  // Check reset-buttons
  if (overRect(20,20,60,30)){
    reset();
  }

  // Check if it above dial or arc.
  if (overCirc(cx, cy, timerDiameter)){
    if (overArc(cx, cy, arcDiameter, minLeft)) {
      // Change color of arc/countdownoverArc
      colorArc.set("R", int(random(30,255)));
      colorArc.set("G", int(random(30,255)));
      colorArc.set("B", int(random(30,255)));
    } else { // Change the colour of the ticks
    colorTick.set("R", int(random(30,255)));
    colorTick.set("G", int(random(30,255)));
    colorTick.set("B", int(random(30,255)));
  }}
}

void drawTicks() {
  fill(100,100,150);
  textSize(25);
  for (int i = 0; i <59; i=i+5) {
    float tick = map(i, 0, 60, -HALF_PI, TWO_PI-HALF_PI);
    arc(cx, cy, arcDiameter*1.11, arcDiameter*1.11, tick-1./180, tick+1./180); 
    text(i, cx+cos(tick)*arcDiameter*0.63-13, cy+sin(tick)*arcDiameter*0.63+15);
  }
  // Remove inner parts
  fill(40,40,40); 
  noStroke(); // No outline
  ellipse(cx, cy, arcDiameter, arcDiameter);
}

void reset() {
  countdownT = 0;
  startT = 0;
  resetColors();
}

void drawCountdownMinutes() { // Draw timer countdown!
  //float minLeft;
  float minOriginal;
  
  float residualTMinutes = residualT/60.;
  residualTSec = residualT-int(residualTMinutes)*60;
  
  // minutes shadow
  fill(colorArc.get("R")-25, colorArc.get("G")-25, colorArc.get("B")-25, 50);
  minOriginal = map(countdownT/60., 0, 60, 0, TWO_PI);
  arc(cx, cy, arcDiameter, arcDiameter, -HALF_PI, minOriginal-HALF_PI);

  // minutes current
  fill(colorArc.get("R"), colorArc.get("G"), colorArc.get("B"));
  textSize(56);
  text(int(residualTMinutes)+":"+nf(int(residualTSec), 2), cx-35,70);
  minLeft = map(residualTMinutes, 0, 60, 0, TWO_PI); // from min to rad
  arc(cx, cy, arcDiameter, arcDiameter, -HALF_PI, minLeft-HALF_PI); // draw arc
}

void drawCountdownSeconds() {
  // seconds current
  float secLeft;
  strokeWeight(3);
  fill(colorArc.get("R")-25, colorArc.get("G")-25, colorArc.get("B")-25,50);
  secLeft = map(residualTSec, 0, 60, 0, TWO_PI); // from min to rad
  line(cx, cy, cx + cos(secLeft) * arcDiameter*0.5, cy + sin(secLeft) * arcDiameter*0.5);
}

boolean overRect(int x, int y, int dimX, int dimY) { 
  // Check mouseXY in rectangle
  if (mouseX > x && mouseX < x+dimX && mouseY > y && mouseY < y+dimY){
    return true;
  } else {return false;}
}

boolean overCirc(int x, int y, float diam) {
  // Check mouseXY in circle
  float distX = mouseX-x;
  float distY = mouseY-y;
  if (sqrt(sq(distX) + sq(distY)) < diam/2.){
    return true;
  } else {return false;}
}

boolean overArc(int x, int y, float diam, float angle) {
  // Check mouseXY in arc/partial circle
  float distX = x-mouseX;
  float distY = y-mouseY;

  float angleXY = atan(distY/distX)+HALF_PI;
  if (distX > 0){angleXY = angleXY + PI;}

  if (sqrt(sq(distX) + sq(distY)) < diam/2.){
    if (angleXY < angle) {
      return true;
    } else { return false;}
  } else {return false;}
}

void drawTimeButtons() {
  // Draw the time-buttons
  textSize(25);
  int dimX = tButtonSize.get("x");
  int dimY = tButtonSize.get("y");
  for (int i=0;i<tButtonVal.size();i=i+1){
    fill(110, 110, 110);
    rect(tButtonX.get(i), tButtonY.get(i), dimX, dimY, 5);
    fill(0,0,30);
    text("+"+tButtonVal.get(i), tButtonX.get(i)+(0.1*dimX), tButtonY.get(i)+(0.88*dimY));
  }
}

void drawResetButton(){
  // Draws reset-button
  int x = resetButton.get("x");
  int y = resetButton.get("y");
  int dimX = resetButton.get("dimX");
  int dimY = resetButton.get("dimY");
  textSize(25);
  fill(110, 110, 110);
  rect(x, y, dimX, dimY, 5);
  fill(0,0,30);
  text("Reset", x+(0.1*dimX), y+(0.88*dimY));
}

void findTButtonXY() {
  // Generate time-button placements
  tButtonX = new IntList();
  tButtonY = new IntList();

  int x0 = int(620*0.9);
  int y0 = int(820*0.08);

  for (int i = 0; i < tButtonVal.size(); i = i+1) {
    tButtonX.append(x0);
    tButtonY.append(y0 + i*(tButtonSize.get("y") + 15));
  }
}

void resetColors() {
  colorTick.set("R", 40); 
  colorTick.set("G", 40);
  colorTick.set("B", 40);

  colorArc.set("R", 72); 
  colorArc.set("G", 128);
  colorArc.set("B", 166);
}

