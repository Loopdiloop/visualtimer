

// Global parameters
int cx, cy;
float arcRadius;
float timerDiameter;

float startTime;
float countdownTime;

float minLeft;
float minOriginal;



void setup() {
  size(620, 820);
  
  int radius = min(width, height) / 3;
  timerDiameter = radius * 2.0;
  arcRadius = radius * 1.8;
  
  // Position of clock (center)
  cx = width / 2;
  cy = height / 2;
  
  startTime = 0; //millis()/1000.0;
  countdownTime = 0; //20 * 1000.0;
  
}



void draw() {
  // Background colour
  background(30, 30, 30);
  
  // Draw the clock/timer background
  fill(40,40,40); //80
  noStroke(); // No outline
  ellipse(cx, cy, timerDiameter, timerDiameter);
  
  // Draw buttons for adding different times??

  float currentTime = millis()/1000.0;
  float residualTime = countdownTime - (currentTime - startTime);
  float residualTimeMinutes = residualTime/60.;
  float residualTimeSeconds = residualTime-int(residualTimeMinutes)*60;
  textSize(56);

  if (residualTime > 1e-5) { //i.e. there is time left
    fill(45, 45, 45);
    minOriginal = map(countdownTime/60., 0, 60, 0, TWO_PI);
    arc(cx, cy, arcRadius, arcRadius, -HALF_PI, minOriginal-HALF_PI);
    
    fill(72, 128, 166);
    text(int(residualTimeMinutes)+":"+nf(int(residualTimeSeconds), 2), cx-15,70);
    minLeft = map(residualTime/60., 0, 60, 0, TWO_PI); // from min to rad
    arc(cx, cy, arcRadius, arcRadius, -HALF_PI, minLeft-HALF_PI); // draw arc
  }

  else { // Wait for added time/click.
    fill(72, 128, 166);
    text("click to start", cx-40, 70);
  }
  endShape();
}

void mousePressed() { // if mousepressed, then reset start-time and add 5 min.
  countdownTime += 5*60 ;
  if (startTime<1e-5) {
    startTime = millis()/1000.0;
  }
}
