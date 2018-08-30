class Super {
    Thread thread;
    public Super() {
        thread = new Thread() {
            public void run() {
                System.out.println(Super.this.toString());
            }
        };
    }

    public void start() {  // good
        thread.start();
    }
    
    public String toString() {
        return "hello";
    }
}

class Test extends Super {
    private String name;
    public Test(String nm) {
        this.name = nm;
    }

    public String toString() {
        return super.toString() + " " + name;
    }

    public static void main(String[] args) {
        Test t = new Test("my friend");
        t.start();
    }
}