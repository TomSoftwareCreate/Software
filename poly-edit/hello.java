import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Stroke;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.awt.geom.AffineTransform;
import java.awt.geom.Line2D;
import java.awt.geom.NoninvertibleTransformException;
import java.awt.geom.Point2D;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

import javax.swing.JFrame;
import javax.swing.JPanel;

public class hello extends JFrame implements MouseListener, MouseMotionListener, WindowListener, KeyListener {

	interface Paintable {
		public void paintIt(Graphics2D g);
	}

	// ==============================================
	class Painter extends JPanel {
		@Override
		public void paint(Graphics gg) {
			Graphics2D g = (Graphics2D) gg;

			g.setColor(Color.LIGHT_GRAY);
			g.fillRect(0, 0, getWidth(), getHeight());

//			g.setColor(Color.BLUE);
//			g.drawRect(updaterect.x, updaterect.y, updaterect.width, updaterect.height);
			
			g.setTransform(transform);
			// Faces
			g.setColor(Color.WHITE);
			for (Face f : faces) {
				f.paintIt(g);
			}

			// Edges

			g.setStroke(edgeStroke);
			for (Edge e : edges) {
				g.setColor(Color.BLACK);
				if (selEdges.contains(e)) {
					g.setColor(Color.RED);
				}
				e.paintIt(g);
			}
			
			
		}
	}

	// ==============================================

	class Face implements Comparable<Face>, Paintable {
		int v1, v2, v3;

		public Face(int v1, int v2, int v3) {

			List<Integer> list = new ArrayList<Integer>();
			list.add(v1);
			list.add(v2);
			list.add(v3);
			Collections.sort(list);

			this.v1 = list.get(0);
			this.v2 = list.get(1);
			this.v3 = list.get(2);
		}

		@Override
		public int compareTo(Face f) {
			int comp = 0;

			comp = Integer.compare(this.v1, f.v1);
			if (comp == 0) {
				comp = Integer.compare(this.v2, f.v2);
			}
			if (comp == 0) {
				comp = Integer.compare(this.v3, f.v3);
			}

			return comp;
		}

		@Override
		public String toString() {
			return "[" + v1 + "," + v2 + "," + v3 + "]";
		}

		@Override
		public void paintIt(Graphics2D g) {
			Point p1 = vertices.get(v1);
			Point p2 = vertices.get(v2);
			Point p3 = vertices.get(v3);

			xPoints[0] = p1.x;
			xPoints[1] = p2.x;
			xPoints[2] = p3.x;
			yPoints[0] = p1.y;
			yPoints[1] = p2.y;
			yPoints[2] = p3.y;

			g.fillPolygon(xPoints, yPoints, 3);
		}

	}

	class Edge implements Comparable<Edge>, Paintable {
		int v1;
		int v2;

		public Edge(int v1, int v2) {
			// Store sorted.
			this.v1 = Math.min(v1, v2);
			this.v2 = Math.max(v1, v2);
		}

		@Override
		public int compareTo(Edge e) {
			int comp = 0;

			comp = Integer.compare(this.v1, e.v1);

			if (comp == 0) {
				comp = Integer.compare(this.v2, e.v2);
			}

			return comp;
		}

		@Override
		public String toString() {
			return "[" + v1 + "," + v2 + "]";
		}

		@Override
		public void paintIt(Graphics2D g) {
			Point p1 = vertices.get(v1);
			Point p2 = vertices.get(v2);

			xPoints[0] = p1.x;
			xPoints[1] = p2.x;
			yPoints[0] = p1.y;
			yPoints[1] = p2.y;

			g.drawPolygon(xPoints, yPoints, 2);
		}
	}
	// ==============================================

	float []data = new float[8]; // minX,minY,maxX,maxY,minX-t,minY-t,maxX-t,maxY-t
	Rectangle updaterect = new Rectangle();
	//
	Line2D.Float line = new Line2D.Float();
	//
	Stroke edgeStroke = new BasicStroke(3);
	//
	int[] xPoints = new int[3];
	int[] yPoints = new int[3];
	//
	AffineTransform transform = new AffineTransform(); // initially identity
	//
	Map<Integer, Point> vertices = new TreeMap<>();
	Set<Edge> edges = new TreeSet<>();
	Set<Face> faces = new TreeSet<>();
	//
	Set<Edge> selEdges = new TreeSet<>(); // selected edges

	public hello() {
		super("Hello graphics");

		vertex(100, 100); // 0
		vertex(200, 100); // 1
		vertex(300, 300); // 2
		vertex(100, 200); // 3
		vertex(400, 400); // 4
		vertex(400, 500); // 5
		vertex(300, 350); // 6

		edge(0, 1);
		edge(1, 2);
		edge(2, 3);
		edge(3, 0);
		face(0, 1, 2);
		face(2, 3, 0);

		edge(4, 5);
		edge(5, 6);
		face(4, 5, 6);

		print();

		setContentPane(new Painter());

		this.addMouseListener(this);
		this.addMouseMotionListener(this);
		this.addWindowListener(this);
		this.addKeyListener(this);

		setMinimumSize(new Dimension(800, 800));
		setVisible(true);
		setLocationRelativeTo(null);
	}

	// =================================================
	public void vertex(int x, int y) {
		vertices.put(vertices.size(), new Point(x, y));
	}

	public void edge(int v1, int v2) {
		edges.add(new Edge(v1, v2));
	}

	public void face(int v1, int v2, int v3) {
		faces.add(new Face(v1, v2, v3));
	}

	public void print() {
		System.out.println(data_string());
	}

	public String data_string() {
		StringBuilder str = new StringBuilder();
		// Vertices
		str.append("Vertices\n");
		for (Map.Entry<Integer, Point> e : vertices.entrySet()) { // sorted on
																	// id
			str.append("  " + e.getKey() + " = (" + e.getValue().x + "," + e.getValue().y + ")\n");
		}
		// Faces
		str.append("Faces\n");
		for (Face f : faces) { // also sorted
			str.append("  " + f.toString() + "\n");
		}
		// Edges
		str.append("Edges\n");
		for (Edge e : edges) { // also sorted
			str.append("  " + e.toString() + "\n");
		}

		return str.toString();
	}

	// =================================================

	public static void main(String[] args) {
		System.out.println("Hello world!!");

		new hello();
	}

	@Override
	public void windowOpened(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void windowClosing(WindowEvent e) {
		System.out.println("Closing");
		System.exit(0);

	}

	@Override
	public void windowClosed(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void windowIconified(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void windowDeiconified(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void windowActivated(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void windowDeactivated(WindowEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseDragged(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseMoved(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseReleased(MouseEvent event) {

		Point2D.Float mousePos = new Point2D.Float();
		try {
			transform.inverseTransform(event.getPoint(), mousePos);
		} catch (NoninvertibleTransformException ex) {
			System.err.println("mouse: Transform not invertible");
			return;
		}

		float buf = 10;

		selEdges.clear();
		
		for (Edge e : edges) {
			Point p1 = vertices.get(e.v1);
			Point p2 = vertices.get(e.v2);
			line.setLine(p1.x, p1.y, p2.x, p2.y);

			if (line.intersects(mousePos.x - buf, mousePos.y - buf, 2 * buf, 2 * buf)) {
				selEdges.add(e);
				System.out.println("Selected: " + e);
			}
		}
		
		// Repaint the involved region
//		data[0] = Float.MAX_VALUE;
//		data[1] = Float.MAX_VALUE;
//		data[2] = Float.MIN_VALUE;
//		data[3] = Float.MIN_VALUE;
//		for(Edge e : selEdges) {
//			Point p1 = vertices.get(e.v1);
//			Point p2 = vertices.get(e.v2);
//			data[0] = Math.min(data[0], Math.min(p1.x, p2.x)); // minX
//			data[1] = Math.min(data[1], Math.min(p1.y, p2.y)); // minY
//			data[2] = Math.max(data[2], Math.max(p1.x, p2.x)); // maxX
//			data[3] = Math.max(data[3], Math.max(p1.y, p2.y)); // maxY
//		}
//		transform.transform(data,0,data,4,2);
//		
//		updaterect.setBounds((int)data[4],(int)data[5],(int)(data[6]-data[4]),(int)(data[7]-data[5]));
//		repaint(updaterect.x,updaterect.y,updaterect.width,updaterect.height);
		repaint();
	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void keyPressed(KeyEvent e) {
		// TODO Auto-generated method stub

	}

	@Override
	public void keyReleased(KeyEvent e) {
		if (e.getKeyCode() == KeyEvent.VK_ESCAPE) {
			System.exit(0);
		}

	}

}
