namespace TestNamespace
{
    public class SimpleClass
    {
        public void SimpleMethod()
        {
            var x = 5;
            if (x > 0)
            {
                Console.WriteLine("positive");
            }
            else
            {
                Console.WriteLine("negative");
            }
        }
        
        public void CallsOtherMethod()
        {
            SimpleMethod();
        }
        
        public int Add(int a, int b)
        {
            return a + b;
        }
        
        public void LoopExample()
        {
            for (int i = 0; i < 10; i++)
            {
                Console.WriteLine(i);
            }
        }
    }
}
