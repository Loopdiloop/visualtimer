/* 
Visualtimer for everyday use.
Written in Processing v. 4.0b2
*/

import processing.sound.*;
SoundFile fileDone;
SoundFile fileClick;
SoundFile fileDing;
float volumeMod;
IntDict volumeButton;

int cx, cy; // Center of timer
float arcDiameter; // Diameter of minute arc
float timerDiameter; // Diameter of timer

IntDict colorTick; //randomise the color of tics
IntDict colorArc; //randomise the color of timer

float startT;
float countdownT;

float minLeft; // Radian Minutes left to count.
//float minOriginal; // Radian Total countdown since reset.

float residualT; // Time left of countdown
float residualTSec; // Residual time, but only seconds.

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

  defineSounds();

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
  drawVolumeButton();
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
    soundDone();
  }
  textSize(20);
  fill(45);
  text("Visualtimer by @loopdiloop", cx, 2*cy-30);
}

void mousePressed() { 
  // if mousepressed, check if its above a button.
  soundClick();
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

  // Check volume setting
  if (overRect(volumeButton.get("x"), volumeButton.get("y"), volumeButton.get("dimX"), volumeButton.get("dimY"))) {
    changeVolumeMod();
  }
}

void soundDone() {
  fileDone.play();
}

void soundClick() {
  fileClick.play();
}

void sound() {
  fileDing.play();
}

void changeVolumeMod() {
  int y = volumeButton.get("y");
  int dimY = volumeButton.get("dimY");
  volumeMod = map(mouseY, y, y+dimY, 1.0, -0.2);
  if (volumeMod<0){
    volumeMod=0;
  }
  fileDone.amp(0.5*volumeMod);
  fileClick.amp(0.1*volumeMod);
  fileDing.amp(0.5*volumeMod);
}