class MyFrame extends JFrame {
    public MyFrame() {
        setSize(640, 480);
        setTitle("BrokenSwing");
    }
}

public class BrokenSwing {
    private static void doStuff(MyFrame frame) {
        // BAD: Direct call to a Swing component after it has been realized
        frame.setTitle("Title");
    }

    public static void main(String[] args) {
        MyFrame frame = new MyFrame();
        frame.setVisible(true);
        doStuff(frame);
    }
}