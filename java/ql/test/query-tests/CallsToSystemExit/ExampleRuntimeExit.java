import java.io.FileOutputStream;
import java.io.IOException;

public class ExampleRuntimeExit {

    public static void main(String[] args) {
        Action action = new Action();
        try {
            action.run();
        } catch (Exception e) {
            printUsageAndExit(e.getMessage(), 1);
        }
        Runtime.getRuntime().exit(0); // COMPLIANT
    }

    static class Action {
        public void run() {
            try {
                FileOutputStream fos = new FileOutputStream("output.txt");
                fos.write("Hello, World!".getBytes());
                fos.close();
                Runtime.getRuntime().exit(0); // $ Alert
            } catch (IOException e) {
                e.printStackTrace();
                Runtime.getRuntime().exit(1); // $ Alert
            } catch (Exception e) {
                // re-throw the exception
                throw e;
            }
        }
    }

    protected static void printUsageAndExit(final String message, final int exitCode) {
        System.err.println("Usage: <example_cmd> <example_args> : " + message);
        Runtime.getRuntime().exit(exitCode); // COMPLIANT
    }
}
