

//===================================

void addData() {

  begin();
  {
    set(0);
    still("beach.png");
    seq(0, 0, "worm");
    seq(0, 0, "frames");

    set(24);
    seq(0, 0, "person");
    
    set(48);
    seq(100, 100, "person");
  }
  end();
  seq("worm");
  begin(); 
  {
    still("beach.png");
    seq(100, 0, "worm");
  }
  end();
  begin(); 
  {
    still("beach.png");
    seq(100, 0, "worm");
  }
  end();
  

  //add("worm");
  //add("frames");

  //add(width/2, height/2, "worm");
  //add(width/2+100, height/2, "worm");
  //add("person");
}


//===================================

void seq(String folder) {
  seq(0, 0, folder);
}

void seq(float x, float y, String folder) {
  Clip c = new Imgseq(x, y, folder);
  if (comp != null) {    
    ClipSettings cs = new ClipSettings();
    cs.start = frame;
    cs.clip = c;
    comp.add(cs);
  } else {
    clips.add(c);
  }
}

void still(String file) {
  still(0, 0, file);
}

void still(float x, float y, String file) {
  Clip c = new Still(x, y, file);
  if (comp != null) {		
    ClipSettings cs = new ClipSettings();
    cs.start = frame;
    cs.clip = c;
    comp.add(cs);
  } else {
    clips.add(c);
  }
}

void begin() {
  comp = new Comp();
}

void end() {
  clips.add(comp);
  comp = null;
  frame = 0;
}

void set(int f) {
  frame = f;
}


//===================================
import java.io.File;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.LinkedList;


List<Clip> clips = new LinkedList<Clip>();
Iterator<Clip> iter;
Clip current = null;

Comp comp;
int frame;


class StackData {

  int frame;
}

void setup() {
  size(640, 360);
  frameRate(24);

  addData();

  iter = clips.iterator();
  current = iter.next();
  current.rewind();
} 

//===================================

void draw() { 
  background(125);

  if (current.isDone()) {
    if (!iter.hasNext()) {
      iter = clips.iterator(); // restart
    }
    current = iter.next();
    current.rewind();
  }

  current.draw();
  current.advance();
}

//===================================

String get_digits(String str) {
  StringBuilder strBuild = new StringBuilder();
  for (int i = 0; i < str.length(); ++i) { 
    char c = str.charAt(i);
    if (Character.isDigit(c)) {
      strBuild.append(c);
    }
  }
  return strBuild.toString();
}

//===================================


//-------------------------

interface Clip {
  void draw();
  void rewind();
  void advance();
  boolean isDone();
  int length();
}

//-------------------------

class Still implements Clip {
  PImage image;
  float x; 
  float y;

  Still(float x, float y, String dataFile) {		
    image = loadImage(dataFile);
    this.x = x;
    this.y = y;
  }

  public void draw() {
    image(image, x, y);
  }
  void rewind() {
  }
  void advance() {
  }
  boolean isDone() {
    return false;
  }
  int length() {
    return 1;
  }
}

//-------------------------
class ClipSettings {
  Clip clip;
  int start;
  int mode;

  public int endFrame() {
    return start + clip.length() - 1;
  }
}

//-------------------------

class Comp implements Clip {

  List<ClipSettings> clips = new LinkedList<ClipSettings>();

  int last;
  int current;

  Comp() {
  }

  public void add(ClipSettings cs) {
    clips.add(cs);
    last = max(last, cs.endFrame());
  }

  public void draw() {
    for (ClipSettings cs : clips ) {
      if (cs.start <= current) {
        cs.clip.draw();
      }
    }
  }

  public void rewind() {
    current = 0;
  }
  public void advance() {
    for (ClipSettings cs : clips) {
      if (cs.start <= current) {
        cs.clip.advance();
        if (cs.clip.isDone()) {
          cs.clip.rewind();
        }
      }
    }
    current += 1;
  }
  public boolean isDone() {
    return current > last;
  }

  public int length() {
    return last + 1;
  }
}


//-------------------------

class Imgseq implements Clip {
  PImage[] images;
  int first;
  int last;
  int current;
  //
  float x; 
  float y;

  Imgseq(float x, float y, String folder) {
    this.x = x;
    this.y = y;

    // Keep a map of frame number to filename
    SortedMap<Integer, String> map = new TreeMap<Integer, String>();

    File dir = new File(dataPath(folder));
    for (String filename : dir.list()) {            
      String str = get_digits(filename);
      int frame = Integer.parseInt(str);
      map.put(frame, filename);
    }

    first = map.firstKey();
    current = first;
    last = map.lastKey();
    images = new PImage[last-first+1];
    println(folder + ": " + first + " -- " + last);
    for (Map.Entry<Integer, String> e : map.entrySet()) {
      int frame = e.getKey();
      String file = e.getValue();
      images[frame - first] = loadImage(folder + "/" + file);
    }
  }

  public void draw() {
    if (first <= current && current <= last) {
      image(images[current-first], x, y);
    }
  }
  public void rewind() { 
    current = first;
  }
  public void advance() {
    current += 1;
  }
  public boolean isDone() {
    return current > last;
  }

  public int length() {
    return last-first + 1;
  }
}
