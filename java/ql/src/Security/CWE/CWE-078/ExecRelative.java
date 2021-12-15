class Test {
    public static void main(String[] args) {
        // BAD: relative path
        Runtime.getRuntime().exec("make");
        
        // GOOD: absolute path
        Runtime.getRuntime().exec("/usr/bin/make");

        // GOOD: build an absolute path from known values
        Runtime.getRuntime().exec(Paths.MAKE_PREFIX + "/bin/make");
    }
}