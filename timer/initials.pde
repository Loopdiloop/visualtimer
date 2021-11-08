/*
Functions for initialising and resetting.
*/

void reset() {
  countdownT = 0;
  startT = 0;
  resetColors();
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

void defineSounds(){
  volumeButton = new IntDict();
  volumeButton.set("x", 20);
  volumeButton.set("y", 100);
  volumeButton.set("dimX", 40);
  volumeButton.set("dimY", 140);

  volumeMod = 0.8;
  fileDone = new SoundFile(this, "../soundeffects/Tada-sound.mp3");
  fileDone.amp(0.5*volumeMod);
  
  fileClick = new SoundFile(this, "../soundeffects/mixkit-positive-interface-click-1112.wav");
  fileClick.amp(0.1*volumeMod);

  fileDing = new SoundFile(this, "../soundeffects/mixkit-typewriter-soft-click-1125.wav");
  fileDing.amp(0.5*volumeMod);
}
