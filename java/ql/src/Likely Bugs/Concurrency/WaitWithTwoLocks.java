class WaitWithTwoLocks {

    private final Object idLock = new Object();
    private int id = 0;

    private final Object textLock = new Object();
    private String text = null;

    public void printText() {
        synchronized (idLock) {
            synchronized (textLock) {
                while(text == null)
                    try {
                        textLock.wait();  // The lock on "textLock" is released but not the
                                          // lock on "idLock".
                    }
                    catch (InterruptedException e) { ... }
                System.out.println(id + ":" + text);
                text = null;
                textLock.notifyAll();
            }
        }
    }

    public void setText(String mesg) {
        synchronized (idLock) { // "setText" needs a lock on "idLock" but "printText" already
                                // holds a lock on "idLock", leading to deadlock
            synchronized (textLock) {
                id++;
                text = mesg;
                idLock.notifyAll();
                textLock.notifyAll();
            }
        }
    }
 }
