class Message {
    public String text = "";
}

class Receiver implements Runnable {
    private Message message;
    public Receiver(Message msg) {
        this.message = msg;
    }
    public void run() {
        synchronized(message) {
            while(message.text.isEmpty()) {
                try {
                    message.wait();  // Wait for a notification
                } catch (InterruptedException e) { }
            }
        }
        System.out.println("Message Received at " + (System.currentTimeMillis()/1000));
        System.out.println(message.text);
    }
}

class Sender implements Runnable {
    private Message message;
    public Sender(Message msg) {
        this.message = msg;
    }
    public void run() {
        System.out.println("Message sent at " + (System.currentTimeMillis()/1000));
        synchronized(message) {
            message.text = "Hello World";
            message.notifyAll();  // Send notification
        }
    }
}

public class BusyWait {
    public static void main(String[] args) {
        Message msg = new Message();
        new Thread(new Receiver(msg)).start();
        new Thread(new Sender(msg)).start();
    }
}
