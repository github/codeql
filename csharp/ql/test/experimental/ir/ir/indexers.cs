class Indexers
{
    public class MyClass
    {
        private string[] address = new string[2];
        public string this[int index]
        {
            get
            {
                return address[index];
            }
            set
            {
                address[index] = value;
            }
        }
    }

    public static void Main()
    {
        MyClass inst = new MyClass();
        inst[0] = "str1";
        inst[1] = "str1";
        inst[1] = inst[0];
    }
}
