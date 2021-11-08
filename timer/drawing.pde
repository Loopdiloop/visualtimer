/*
Functions for drawing to window.
Everything from countdown, ticks, and buttons.
*/

void drawTicks() {
  fill(100,100,100);
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

void drawCountdownSeconds() {
  // seconds current
  float secLeft;
  strokeWeight(3);
  fill(colorArc.get("R")-25, colorArc.get("G")-25, colorArc.get("B")-25,50);
  secLeft = map(residualTSec, 0, 60, 0, TWO_PI); // from min to rad
  line(cx, cy, cx + cos(secLeft) * arcDiameter*0.5, cy + sin(secLeft) * arcDiameter*0.5);
}

void drawVolumeButton(){
  int x = volumeButton.get("x");
  int y = volumeButton.get("y");
  int dimX = volumeButton.get("dimX");
  int dimY = volumeButton.get("dimY");
  
  int colorR = colorArc.get("R");
  int colorG = colorArc.get("G");
  int colorB = colorArc.get("B");

  noStroke();
  for (int i = x; i < x+dimX; i=i+4) {
    for (int j = y; j < y+dimY; j=j+4) {
      fill(colorR-(j-y)*1.5, colorG-(j-y)*1.5, colorB-(j-y)*1.5);
      circle(i,j,3);
    }
  }
  fill(colorR, colorG, colorB);
  text("volume",x-10,y-20);
}