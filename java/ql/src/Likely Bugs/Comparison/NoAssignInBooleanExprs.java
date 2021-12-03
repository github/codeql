public class ScreenView
{
    private static int BUF_SIZE = 1024;
    private Screen screen;

    public void notify(Change change) {
        boolean restart = false;
        if (change.equals(Change.MOVE)
            || v.equals(Change.REPAINT)
            || (restart = v.equals(Change.RESTART))  // AVOID: Confusing assignment in condition
            || v.equals(Change.FLIP))
        {
            if (restart)
                WindowManager.restart();
            screen.update();
        }
    }

    // ...

    public void readConfiguration(InputStream config) {
        byte[] buf = new byte[BUF_SIZE];
        int read;
        while ((read = config.read(buf)) > 0) {  // OK: Assignment whose result is compared to
                                                 // another value
            // ...
        }
        // ...
    }
}
