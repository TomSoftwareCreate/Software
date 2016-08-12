
float A = 0.2f; // acceleration range
float V_MAX = 2.5f; // velocity max
float V_MIN = -V_MAX; // velocity min


class Fly {

  float x; // position x
  float y; // position y
  float vx; // velocity x
  float vy; // velocity y
  float ax; // acceleration x
  float ay; // acceleration y
  color color1; 
  color color2;

  Fly() {
    x = random(width);
    y = random(height);

    vx = random(0, 1.0f);
    vy = random(0, 1.0f);

    set_colors();

    rand_acc();
  }

  void set_colors() {
    if (random(1.0f) < 0.4f) {
      color1 = color(255, 0, 255);
      color2 = color(0, 255, 255);
    } else {
      color1 = color(255, 0, 0);
      color2 = color(255, 255, 0);
    }
  }

  void rand_acc() {
    ax = random(-A, A);
    ay = random(-A, A);
  }

  void update() {

    if (random(1.0f) < 0.15f) {
      rand_acc();
    }

    // Update velocity
    vx += ax;
    vy += ay;

    vx = constrain(vx, V_MIN, V_MAX);
    vy = constrain(vy, V_MIN, V_MAX);

    // Update position
    x += vx;
    y += vy;

    x = constrain(x, 0, width-1);
    y = constrain(y, 0, height-1);
  }

  void draw() {
    ellipseMode(CENTER); 
    fill(255);

    float v = max(abs(vx), abs(vy)); // velocity measure
    float r = map(v, 0, V_MAX, 1, 10); // radius

    // Color
    float j = map(v, 0, V_MAX, 0, 1.0f);
    color inter = lerpColor(color1, color2, j);

    int alpha = (int)map(v, 0, V_MAX, 20, 255);    
    fill(inter, alpha);
    ellipse(x, y, r, r);
  }
}

//---------------------------------------

Fly []flies = new Fly[30];

void setup() {
  size(400, 400);

  for (int i = 0; i < flies.length; ++i) {
    flies[i] = new Fly();
  }
}


void draw() {

  // Fade previous frame a bit
  fill(0, 10);
  rect(0, 0, width, height);

  noStroke();

  for (int i = 0; i < flies.length; ++i) {
    Fly f = flies[i];
    f.update();
    f.draw();
  }
}