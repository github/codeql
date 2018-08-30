class MyFrame extends JFrame {
    public MyFrame() {
        setSize(640, 480);
        setTitle("BrokenSwing");
    }
}

public class GoodSwing {
    private static void doStuff(final MyFrame frame) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                // GOOD: Call to Swing component made via the
                // event-dispatching thread using 'invokeLater'
                frame.setTitle("Title");
            }
        });
    }

    public static void main(String[] args) {
        MyFrame frame = new MyFrame();
        frame.setVisible(true);
        doStuff(frame);
    }
}
