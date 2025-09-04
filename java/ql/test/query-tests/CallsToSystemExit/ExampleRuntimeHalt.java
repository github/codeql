import java.io.FileOutputStream;
import java.io.IOException;

public class ExampleRuntimeHalt {

    public static void main(String[] args) {
        Action action = new Action();
        action.run();
        Runtime.getRuntime().halt(0); // COMPLIANT
    }

    static class Action {
        public void run() {
            try {
                FileOutputStream fos = new FileOutputStream("output.txt");
                fos.write("Hello, World!".getBytes());
                fos.close();
                Runtime.getRuntime().halt(0); // $ Alert
            } catch (IOException e) {
                e.printStackTrace();
                Runtime.getRuntime().halt(1); // $ Alert
            }
        }
    }
}
