class Geeks {
    private int roll_no;

    public int Roll_no
    { 
        get 
        {
            return roll_no;
        }

        set 
        {
            roll_no = value;
        }
    }
}

class Prog {
    public static void Main() {
        Geeks obj = new Geeks();
        obj.Roll_no = 5;
        int x = obj.Roll_no;
    }
}
