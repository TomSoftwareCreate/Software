// 

import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Map;

import processing.sound.*;
SoundFile file;

int frame = 0;

int m;
int fps = 24;
int elapsed;
TreeMap<Integer, String> map;
TreeMap<String,PImage> images;

void setup() {
  size(400,400);
  read_file();
  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "process.aiff");
  file.play();

  m = millis();
}

void draw() {
  background(0);
  int m2 = millis();

  elapsed += (m2 - m);

  float second = elapsed/1000.0f;

  int frame = (int)(second * fps);

  Map.Entry<Integer, String> e = map.floorEntry(frame);

  if (e!=null) {
    //println(e.getValue());
    String str = e.getValue();
    PImage img = images.get(str);
     image(img,0,0);
  }

  m = m2;
}

void read_file() {

  map = new TreeMap<Integer, String>();
  images = new TreeMap<String,PImage>();

  String lines[] = loadStrings("process.txt");
  println("there are " + lines.length + " lines");
  for (int i = 0; i < lines.length; i++) {
    String []cols = lines[i].split("\\s");
    if (cols.length == 2) {
      println(lines[i]);
      map.put(Integer.parseInt(cols[0]), cols[1]);
      
      PImage img = loadImage(cols[1]+".jpg");
      images.put(cols[1],img);
    }
  }
}