

//===================================

void addData() {

	main.add(sub("This is a movie", 48));
	
	//------------------------
	// Shot 1: worms on beach
	Comp c = new Comp();
	main.add(c);
	c.add(0,0,still("beach.png")); // will stretch until end of worm-clip
	c.add(0,1,seq("worm"));
	c.add(10,2,seq(20,20,"worm"));
	c.add(24,3,seq(200,100,"worm"));
	c.add(48,4,seq(0,100,"frames", true));
	
	Track t = new Track(false);
	c.add(0,5,t);
	t.add(sub(0,200,"Look at the worms!",2*24));
	t.add(sub(0,200,"They are dancing :-)", 2*24));
	t.add(sub(0,200,"We can add the text here :-)", 2*24));	
	//-------------------
	// Shot 2: happy guy
	c = new Comp();
	main.add(c);
	c.add(0,0,still("flowers.png"));
	c.add(0,1, seq("person", true));
	c.add(0,2, sub(0,100,"Look at all this text :-)", 5*24));
	
}


//===================================

Clip seq(String folder) {
  return seq(0, 0, folder, false);
}

Clip seq(String folder, boolean repeat) {
  return seq(0, 0, folder, repeat);
}

Clip seq(float x, float y, String folder) {
  return new Imgseq(x, y, folder, false);
}

Clip seq(float x, float y, String folder, boolean repeat) {
  return new Imgseq(x, y, folder, repeat);
}

Clip sub(String text, int length) {
  return sub(0, 0, text, length);
}

Clip sub(float x, float y, String text, int length) {
  return new Sub(x, y, text, length);
}

Clip sub(String text) {
  return sub(0, 0, text, 0);
}

Clip sub(float x, float y, String text) {
  return new Sub(x, y, text,0);
}

Clip still(String file) {
  return still(0, 0, file, 0);
}

Clip still(float x, float y, String file) {
  return new Still(x, y, file, 0);
}

Clip still(String file, int length) {
  return still(0, 0, file, length);
}

Clip still(float x, float y, String file, int length) {
  return new Still(x, y, file, length);
}


//===================================
import java.io.File;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.LinkedList;
import java.util.Stack;
import java.util.Set;
import java.util.TreeSet;
import java.util.Collections;


Track main = new Track(true); // repeat

void setup() {
  size(640, 360);
  frameRate(24);

  addData();

  main.rewind();
} 

//===================================

void draw() { 
  background(125);

  main.draw();
  main.advance();
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

interface Clip {
  void draw();
  void rewind();
  void advance();
  boolean isDone();
  boolean solid(); // when time influencing
}

//-------------------------
class Track implements Clip {
  List<Clip> clips = new LinkedList<Clip>();
  Iterator<Clip> iter;
  Clip current = null;

  boolean repeat;

  public Track(boolean repeat) {		
    this.repeat = repeat;
  }
  
  void add(Clip c) {
	  clips.add(c);
  }

  public void rewind() {
    iter = clips.iterator();
    current = iter.next();
    current.rewind();
  }

  public void advance() {
    current.advance();
    if (current.isDone()) {
      if (iter.hasNext()) {
        current = iter.next();
        current.rewind();
      } else if (repeat) {
        // Restart
        iter = clips.iterator();
        current = iter.next();
        current.rewind();
      } else {
        current = null;
      }
    }
  }

  public void draw() {
    current.draw();
  }

  public boolean isDone() {
    if (repeat) {
      return true;
    } else if (current!=null) {
      return current.isDone();
    } else {
      return true;
    }
  }
  
  public boolean solid() {
	  // When at least one solid
	  boolean solid = false;
	  for(Clip c : clips) {
		  solid |= c.solid();
	  }
	  return solid;
  }
}

//-------------------------

class Sub implements Clip {
  String text;
  float x; 
  float y;
  int current = 0;
  int length;

  Sub(float x, float y, String text, int length) {		
    this.text =text;
    this.x = x;
    this.y = y;
    this.length = length;
    this.current = 0;
  }

  public void draw() {
    rectMode(CORNERS);
    fill(0);
    text(text, x, y, width-20, height-20);
    rectMode(CORNER);
  }
  public void rewind() {
    current = 0;
  }
  public void advance() {
    current += 1;
  }
  public boolean isDone() {
    return current >= length;
  }  
  public boolean solid() {
	return length > 0;
	}
  
}

//-------------------------

class Still implements Clip {
  PImage image;
  float x; 
  float y;
  int current;
  int length;

  Still(float x, float y, String dataFile, int length) {
    image = loadImage(dataFile);
    this.x = x;
    this.y = y;
    this.length = length;
  }

  public void draw() {
    image(image, x, y);
  }
  void rewind() {
	  current = 0;
  }
  void advance() {
	  current += 1;
  }
  boolean isDone() {
    return current >= length;
  }  
  
  public boolean solid() {
	return length > 0;
	}
}

//-------------------------
class CS implements Comparable<CS> { // clip settings
	Clip clip;
	int z;
	
	CS(Clip clip, int z){this.clip = clip; this.z = z;}
	
	int compareTo(CS cs) {
		return Integer.compare(this.z, cs.z);
	}
}

//-------------------------

class Comp implements Clip {

  SortedMap<Integer,List<CS>> map = new TreeMap<Integer,List<CS>>();

  int current;
  List<CS> active = new LinkedList<CS>();

  Comp() {
  }

  public void add(int start,  int z, Clip clip) {
	  if(!map.containsKey(start)) {
		  map.put(start,new LinkedList<CS>());
	  }
	  map.get(start).add(new CS(clip, z));
  }

  public void draw() {
	  
    for (CS cs : active ) {      
        cs.clip.draw();
    }
  }

  public void rewind() {
    current = 0;
    
    active = new LinkedList<CS>();
    collectActive();
  }
  
  public void collectActive() {
	  if(map.containsKey(current)) {
		for(CS cs : map.get(current)) {
			cs.clip.rewind();
			active.add(cs);
		}
	  }
	  
	  Collections.sort(active);
  }
  
  public void advance() {
	  current += 1;
	  
	  // Advance and remove current clips
	  Iterator<CS> iter = active.iterator();
	  while(iter.hasNext()) {
		  CS cs = iter.next();
		  cs.clip.advance();
		  if(cs.clip.solid() && cs.clip.isDone()) {
			  iter.remove();
		  }
	  }
	  
	  // See if more clips become active now
	  collectActive();    
  }
  
  public boolean isDone() {
	  // not done while at least one solid 
	  boolean done = false;
	  
	  boolean foundSolid = false;
	  for(CS cs : active) {
		  foundSolid |= cs.clip.solid();
	  }
	  
	  done = current > map.lastKey() && !foundSolid;
	  return done;
  }
  
  public boolean solid() {	  
	//When at least one solid
	boolean solid= false;
	for(List<CS> l : map.values()) {
		for(CS cs : l) {
			solid |= cs.clip.solid();
		}
	}
	return solid;
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
  //
  boolean repeat = false;

  Imgseq(float x, float y, String folder, boolean repeat) {
    this.x = x;
    this.y = y;
    this.repeat = repeat;

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
    current = 0;
  }
  public void advance() {
    current += 1;
    if(current == length() && repeat) {
		rewind();
	}
  }
  public boolean isDone() {
    return current > last;
  }

  public int length() {
    return last-first + 1;
  }
  
  public boolean solid() {  
	  return !repeat && length() > 0;
  }
}
