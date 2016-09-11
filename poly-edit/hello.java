import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

import javax.swing.JFrame;
import javax.swing.JPanel;

public class hello extends JFrame implements MouseListener, 
MouseMotionListener, WindowListener, 
KeyListener {

	// ==============================================
	class Painter extends JPanel {
		@Override
		public void paint(Graphics gg) {
			Graphics2D g = (Graphics2D) gg;

			g.setColor(Color.LIGHT_GRAY);
			g.fillRect(0, 0, getWidth(), getHeight());

		}
	}

	// ==============================================

	class Edge implements Comparable<Edge> {
		int v1;
		int v2;

		public Edge(int v1, int v2) {
			this.v1 = v1;
			this.v2 = v2;
		}

		@Override
		public int compareTo(Edge e) {
			// The order of the vertices does not matter
			int mi_this = Math.min(v1, v2);
			int ma_this = Math.max(v1, v2);

			int mi_e = Math.min(e.v1, e.v2);
			int ma_e = Math.max(e.v1, e.v2);

			// First compare minimum
			int comp = Integer.compare(mi_this, mi_e);

			if (comp == 0) {
				comp = Integer.compare(ma_this, ma_e);
			}

			return comp;
		}

		@Override
		public String toString() {
			return "[" + v1 + "]_[" + v2 + "]";
		}
	}
	// ==============================================

	Map<Integer, Point> vertices = new TreeMap<>();
	Set<Edge> edges = new TreeSet<>();

	public hello() {
		super("Hello graphics");

		vertex(100, 100); // 0
		vertex(200, 100); // 1
		vertex(200, 200); // 2
		vertex(100, 200); // 3
		edge(0, 1);
		edge(1, 2);
		edge(2, 3);
		edge(3, 0);

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
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub

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
		if(e.getKeyCode() == KeyEvent.VK_ESCAPE) {
			System.exit(0);
		}
		
	}

}
