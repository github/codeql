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
        Rectangle r = a as Rectangle;
        if (r != null)
        {
            Console.WriteLine(r.height);
        }
    }
}
