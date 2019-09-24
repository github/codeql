class Events
{
    public delegate string MyDel(string str);

    event MyDel MyEvent;

    public Events() {
        this.MyEvent += new MyDel(this.WelcomeUser);
    }

    public string WelcomeUser(string username) {
        return "Welcome " + username;
    }
    
    static void Main(string[] args) {
        Events obj1 = new Events();
        string result = obj1.MyEvent("Tutorials Point");
    }
}
