
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

//===================================

void addData() {
	add("worm");
	add("frames");
}
 
//===================================

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

  if(current.isDone()) {
	  if(!iter.hasNext()){
		  iter = clips.iterator(); // restart
	  }
	  current = iter.next();
	  current.rewind();
  }
  
  current.draw();
  current.advance();
  
  
}

//===================================

void add(String folder) {
	clips.add(new Imgseq(folder));
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
}

//-------------------------

class Imgseq implements Clip {
  PImage[] images;
  int first;
  int last;
  int current;

  Imgseq(String folder) {
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
      image(images[current-first],0,0);
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
}
