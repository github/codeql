class Events
{
    public delegate string MyDel(string str);
    public MyDel Inst;

    event MyDel MyEvent;

    public Events()
    {
        this.Inst = new MyDel(this.Fun);
    }

    public void AddEvent() 
    {
        this.MyEvent += this.Inst;
    }

    public void RemoveEvent()
    {
        this.MyEvent -= this.Inst;
    }

    public string Fun(string str) 
    {
        return str;
    }
    
    static void Main(string[] args) 
    {
        Events obj = new Events();
        obj.AddEvent();
        string result = obj.MyEvent("string");
        obj.RemoveEvent();
    }
}
