class UselessIsBeforeAs
{
    class Square
    {
        public int width;
    }
    class Rectangle : Square
    {
        public int height;
    }
    public static void Main(string[] args)
    {
        Square a = new Rectangle();
        if (a is Rectangle)
        {
            Rectangle r = a as Rectangle;
            Console.WriteLine(r.height);
        }
    }
}
