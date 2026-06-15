// Problem 1: Miss out cleanup code 
class FileOutput {
    boolean write(String[] s) {
        try {
            output.write(s.getBytes());
        } catch (IOException e) {
            System.exit(1); // BAD: Should handle or propagate error instead of exiting
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
        System.exit(0); // BAD: Should return status or throw exception
    }
    public static void main(String[] args) {
        new Action().run();
    }
}

// Good example: Proper error handling
class BetterAction {
    public int run() throws Exception {
        // ...
        // Perform tasks ...
        // ...
        return 0; // Return status instead of calling System.exit
    }
    
    public static void main(String[] args) {
        try {
            BetterAction action = new BetterAction();
            int exitCode = action.run();
            System.exit(exitCode); // GOOD: Exit from main method
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            System.exit(1); // GOOD: Exit from main method on error
        }
    }
}
