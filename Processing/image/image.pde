
int numFrames = 24;  // The number of frames in the animation
int currentFrame = 0;
PImage[] images = new PImage[numFrames];
    
void setup() {
  size(640, 360);
  frameRate(24);
  
  for(int i= 0; i < numFrames; ++i) {
    images[i] = loadImage("frames/frame." + nf(i,4) + ".png");
  }
  
} 
 
void draw() { 
  background(125);
  currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  for (int x = -100; x < width; x += images[0].width) { 
    image(images[(currentFrame+offset) % numFrames], x, -20);
    offset+=2;
    image(images[(currentFrame+offset) % numFrames], x, height/2);
    offset+=2;
  }
}