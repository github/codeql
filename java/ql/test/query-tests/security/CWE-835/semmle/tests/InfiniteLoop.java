class Test {
    public void bad() {
        for (int i=0; i<10; i++) {
            for (int j=0; i<10; j++) {
                // potentially infinite loop due to test on wrong variable
                if (shouldBreak()) break;
            }
        }
    }
    private boolean shouldBreak() {
        return Math.random() < 0.5;
    }
}
