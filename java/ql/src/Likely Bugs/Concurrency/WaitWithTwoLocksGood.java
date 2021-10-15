class WaitWithTwoLocksGood {

    private static class Message {
        public int id = 0;
        public String text = null;
    }

    private final Message message = new Message();

    public void printText() {
        synchronized (message) {
            while(message.txt == null)
                try {
                    message.wait();
                }
                catch (InterruptedException e) { ... }
            System.out.println(message.id + ":" + message.text);
            message.text = null;
            message.notifyAll();
        }
    }

    public void setText(String mesg) {
        synchronized (message) {
            message.id++;
            message.text = mesg;
            message.notifyAll();
        }
    }
 }
