// Problem 1: Miss out cleanup code 
class FileOutput {
    boolean write(String[] s) {
        try {
            output.write(s.getBytes());
        } catch (IOException e) {
            System.exit(1);
        }
        return true;
    }
}

// Problem 2: Make code reuse difficult
class Action {
    public void run() {
        // ...
        // Perform tasks ...
        // ...
        System.exit(0);
    }
    public static void main(String[] args) {
        new Action(args).run();
    }
}