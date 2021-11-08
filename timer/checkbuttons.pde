/*
Booleans to check if mousepointer
is above a button or shape.
*/

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
