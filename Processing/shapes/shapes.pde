class Point {
  int dx;
  int dy;

  public Point(int dx, int dy) {
    this.dx = dx;
    this.dy = dy;
  }

  int getDx() {
    return dx;
  }
  int getDy() {
    return dy;
  }
}

Point []offsets = new Point[]{
  new Point(-1, -1), 
  new Point(0, -1), 
  new Point(1, -1), 
  new Point(-1, 0), 
  new Point(1, 0), 
  new Point(-1, 1), 
  new Point(0, 1), 
  new Point(1, 1)
};

void setup() {
  size(400, 400); 

  background(0);
}

void keyReleased() {
  background(0);
}

void draw() {

  noStroke();
      
  for (int i = 0; i < 20; ++i) {
    int x = int(random(width));
    int y = int(random(height));
    color pix = get(x, y);

  
    if (brightness(pix) <255) {
      continue;
    }

    int len = (int)random(100);
    Point p = offsets[(int)random(offsets.length)];
    for (int j = 0; j < len; ++j) {
      float frac = ((len-j)*1.0f/len);     

      if (random(1.0f) < 0.1f) {
        int index = (int)random(offsets.length);      
        p = offsets[index];
      }
      x += p.getDx();
      y += p.getDy();      

      fill(255);
      int r = (int)(4 * frac);
      ellipse(x, y, r, r);
    }
  }


  if (mousePressed) {
    int r = 0;
    if (mouseButton == LEFT) {
      r = 5;    
      fill(255);
    } else { 
      r = 50;
      fill(0);
    }
    translate(mouseX, mouseY);
    ellipse(0, 0, r, r);
  }
}