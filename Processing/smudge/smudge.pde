
float A = 0.03f; // acceleration range
float V_MAX = 1.0f; // velocity max
float V_MIN = -V_MAX; // velocity min
float CHARGE_SUB = 1.0f; 
float CHARGE_MAX = 255.0f;

class Fly {

  float x; // position x
  float y; // position y
  float vx; // velocity x
  float vy; // velocity y
  float ax; // acceleration x
  float ay; // acceleration y

  float charge = 0.0f; // amount of deposit

  Fly() {
    x = random(width);
    y = random(height);

    vx = random(0, 1.0f);
    vy = random(0, 1.0f);

    rand_acc();
  }

  void rand_acc() {
    int xmid = (int)mouseX; //width/2;
    int ymid = (int)mouseY; //height/2;

    float xsign;
    if (x <= xmid) {
      xsign = 1;
    } else {
      xsign = -1;
    }

    float ysign;
    if (y <= ymid) {
      ysign = 1;
    } else {
      ysign = -1;
    }

    ax = xsign * random(0, A);
    ay = ysign * random(0, A);
  }

  void update() {

    if (random(1.0f) < 0.2f) {
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

    charge = constrain(charge - CHARGE_SUB, 0, CHARGE_MAX);    
    color col = get((int)x, (int)y);
    if (red(col) > 250 && green(col) > 250 && blue(col) > 250) {
      charge = CHARGE_MAX; // charged      
    }
  }

  void draw() {        

    float v = max(abs(vx), abs(vy)); // velocity measure
    float r = map(v, 0, V_MAX, 3, 10); // radius

    // Trajectory
    fill(0, 255, 0);
    ellipse(x, y, 2, 2);

    // Color
    int alpha = (int)map(charge, 0, CHARGE_MAX, 0, 255);    
    fill(255, alpha);
    ellipse(x, y, r, r);
  }
}

//---------------------------------------

Fly []flies = new Fly[60];

void setup() {
  size(400, 400);

  for (int i = 0; i < flies.length; ++i) {
    flies[i] = new Fly();
  }
}


void draw() {

  // Fade previous frame a bit
  fill(0, 20);
  rect(0, 0, width, height);

  ellipseMode(CENTER);
  noStroke();

  if (mousePressed) {
    fill(255);
    ellipse(mouseX, mouseY, 60, 60);
  }


  for (int i = 0; i < flies.length; ++i) {
    Fly f = flies[i];
    f.update();
    f.draw();
  }
}