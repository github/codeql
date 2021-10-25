class Super {
    public Super() {
        new Thread() {
            public void run() {
                System.out.println(Super.this.toString());
            }
        }.start(); // BAD: The thread is started in the constructor of 'Super'.
    }

    public String toString() {
        return "hello";
    }
}

class Test extends Super {
    private String name;
    public Test(String nm) {
        // The thread is started before
        // this line is run
        this.name = nm;
    }

    public String toString() {
        return super.toString() + " " + name;
    }

    public static void main(String[] args) {
        new Test("my friend");
    }
}