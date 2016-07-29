// 2D voxel grid

int x1 = 0, y1 = 0, x2 = 100, y2=100;
int trans_x, trans_y;
int voxsize = 20; // initial voxel voxsize 

void setup() {    
  size(400, 400);  
  trans_x = width/2;
  trans_y = height/2;
}

void mousePressed() {  
  x1 = mouseX - trans_x;
  y1 = mouseY - trans_y;
  
  x2 = x1;
  y2 = y1;
}

void mouseDragged() {    
  x2 = mouseX - trans_x;
  y2 = mouseY - trans_y;
}

void keyReleased() {
  if (key == 'j') {
    voxsize += 5;
  }
  if (key == 'k') {
    voxsize -= 5;
  }

  voxsize = min(100, max(5, voxsize));
}

int sign(float f) {
  if ( f < 0) {
    return -1;
  } else if (f > 0) {
    return 1;
  } else {
    return 0;
  }
}

boolean is_very_small(float f) {
  return abs(f) < 0.000000001f;
}

void paint_voxel(int u, int v, float value) {
  int sub = 100;
  int c = 100+(int)((200-100)*value);
  fill(c, c, 255);
  stroke(0);
  rect(u*voxsize + trans_x, v*voxsize + trans_y, voxsize, voxsize);
}

void draw() {
  trans_x = width/2;
  trans_y = height/2;

  draw_background();
  draw_voxels();
  draw_axes();
  draw_info();
}

void draw_background() {
  background(255,255,255);  
  stroke(0);

  // Draw some voxel grid
  stroke(150);
  int r = min(width, height)/voxsize;
  for (int i = 1; i <= r; i++) {
    int x = i*voxsize + trans_x;
    line(x, -height/2+trans_y, x, height/2+trans_y);
    
    x = -i*voxsize + trans_x;
    line(x, -height/2+trans_y, x, height/2+trans_y);
  }
  for (int i = 1; i <= r; i++) {    
    int y = i*voxsize + trans_y;
    line(-width/2+trans_x, y, +width/2+trans_x, y);
    
    y = -i*voxsize + trans_y;
    line(-width/2+trans_x, y, +width/2+trans_x, y);
  }
}

void draw_voxels() {
  
  // Initialize voxel column (u) and voxel row (v)
  int u, v;

  if (x1 >= 0) {
    u = (int)(x1 / voxsize);
  } else {
    u = (int)(x1 / voxsize) - 1;
  }

  if (y1 >= 0) {
    v = (int)(y1 / voxsize);
  } else {
    v = (int)(y1 /voxsize) - 1;
  }

  // If there is a second point then we draw
  // more voxels along the direction p1 -> p2
  if (x1 == x2 && y1 == y2) {
    return;
  }

  float dx = x2 - x1;
  float dy = y2 - y1;

  // Normalize the direction
  float m = max(abs(dx), abs(dy));

  if (m <= 0) {
    return;
  }

  dx = (dx / m)*voxsize;
  dy = (dy / m)*voxsize;

  float length = dist(x1, y1, x2, y2);

  boolean horizontal = is_very_small(dy);    
  boolean vertical = is_very_small(dx);

  if (horizontal) {        
    // Horizontal case    
    paint_voxel(u, v, 0); // first voxel
    int numsteps = (int)(length / mag(dx, dy));
    for (int i = 0; i < numsteps; ++i) {      
      u += sign(dx);
      paint_voxel(u, v, ((float)i)/numsteps);
    }
  } else if (vertical) {
    // Vertical case
    paint_voxel(u, v, 0); // first voxel
    int numsteps = (int)(length / mag(dx, dy));
    for (int i = 0; i < numsteps; ++i) {      
      v += sign(dy);
      paint_voxel(u, v, ((float)i)/numsteps);
    }
  } else {
    // General case

    if ((dx < 0) && (x1 <= u*voxsize)) {
      u -= 1;
    }
    if ((dy < 0) && (y1 <= v*voxsize)) {
      v -= 1;
    }

    float x = x1, y = y1;
    float d = dist(x1, y1, x, y);

    paint_voxel(u, v, 0); // first voxel
    while (d < length) {      

      float leftoverX = 0;
      float leftoverY = 0;
      if (dx > 0) {
        leftoverX = voxsize - (x-u*voxsize);
      } else {
        leftoverX = x - u*voxsize;
      }

      if (dy > 0) {
        leftoverY = voxsize - (y-v*voxsize);
      } else {
        leftoverY = y - v*voxsize;
      }

      if (leftoverX < 0) {
        println("leftoverX : " + leftoverX);
      }
      if (leftoverY < 0) { 
        println("leftoverY : " + leftoverY);
      }

      float timeX = abs(leftoverX / dx);
      float timeY = abs(leftoverY / dy);

      if (timeX <= timeY) {
        // X is faster
        if (dx > 0) {
          u += 1;
          x = u*voxsize;
        } else {
          x = u*voxsize;
          u -= 1;
        }

        y += timeX * dy;
      } else {
        // Y is faster
        x += timeY * dx;

        if (dy > 0) {
          v += 1;
          y = v*voxsize;
        } else {
          y = v*voxsize;
          v -= 1;
        }
      }      

      d = dist(x1, y1, x, y);
      if (d < length) {
        paint_voxel(u, v, d / length);
      }
    }
  }

  // Draw the user line  
  stroke(0);
  line(
    x1 + trans_x, y1 + trans_y, 
    x2 + trans_x, y2 + trans_y);
}

void draw_axes() {
  strokeWeight(3);
  stroke(0);

  // Draw Y-axis
  line(
    0+trans_x, -200 + trans_y, 
    0+trans_x, 200 + trans_y);

  // Draw X-axis
  line(
    -200+trans_x, 0 + trans_y, 
    200+trans_x, 0 + trans_y);

  strokeWeight(1);
}

void draw_info() {
  String s = "Click and drag. Press 'j' -> increase voxel voxsize. Press 'k' -> decrease voxel voxsize.";
  fill(255);
  rect(10, 10, width/2, 50);
  fill(50);    
  text(s, 10, 10, width/2, 50); // text in box
}