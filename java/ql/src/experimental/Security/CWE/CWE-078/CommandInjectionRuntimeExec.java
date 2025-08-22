class Test {
    public static void main(String[] args) {
        String script = System.getenv("SCRIPTNAME");
        if (script != null) {
            // BAD: The script to be executed by /bin/sh is controlled by the user.
            Runtime.getRuntime().exec(new String[]{"/bin/sh", script});
        }
    }
}