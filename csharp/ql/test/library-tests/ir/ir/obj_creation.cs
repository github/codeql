public class ObjCreation 
{
    public class MyClass 
    {
        public int x;

        public MyClass() 
        {
        }

        public MyClass(int _x) 
        {
            x = _x;
        }
    }

    public static void SomeFun(MyClass x) 
    {
    }
 
    public static void Main() 
    {
        MyClass obj = new MyClass(100);
        MyClass obj_initlist = new MyClass { x = 101 };
        int a = obj.x;

        SomeFun(new MyClass(100));
    }
}
