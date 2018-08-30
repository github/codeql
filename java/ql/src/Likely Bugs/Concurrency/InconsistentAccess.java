class MultiThreadCounter {
    public int counter = 0;

    public void modifyCounter() {
        synchronized(this) {
            counter--;
        }
        synchronized(this) {
            counter--;
        }
        synchronized(this) {
            counter--;
        }
        counter = counter + 3;  // No synchronization
    }
}
