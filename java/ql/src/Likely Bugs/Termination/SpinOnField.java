class Spin {
    public boolean done = false;

    public void spin() {
        while(!done){
        }
    }
}

class Spin { // optimized
    public boolean done = false;

    public void spin() {
        boolean cond = done;
        while(!cond){
        }
    }
}
