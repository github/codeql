class ProducerConsumer {
    private static final int MAX_SIZE=3;
    private List<Object> buf = new ArrayList<Object>();

    public synchronized void produce(Object o) {
        while (buf.size()==MAX_SIZE) {
            try {
                wait();
            }
            catch (InterruptedException e) {
               ...
            }
        }
        buf.add(o);
        notifyAll();
    }

    public Object consume() {
        while (buf.size()==0) {
            try {
                wait();
            }
            catch (InterruptedException e) {
                ...
            }
        }
        Object o = buf.remove(0);
        notifyAll();
        return o;
    }
}
