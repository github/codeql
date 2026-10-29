namespace Unsafe
{
    unsafe class Test
    {
        public static unsafe void Main(string[] args)
        {
            int i = 42;
            int[] ia = new int[2];
            ia[0] = 0;
            ia[1] = 1;
            int* ip = &i;
            ip = ip + 1;
            ip = *ip + ip;
            ip = *ip + &i;
            int* ip42 = &i;
            ip++;
            ip = ip - 1;
            *ip42 = sizeof(System.Char*);
            long distance = ip - ip42;
        }

        unsafe void f(System.Char* p)
        {
            p->ToString();
            (*p).ToString();
            p[0].ToString();

        }

        void g() { }

        void h()
        {
            unsafe
            {
                var data = new int[10];
                fixed (int* p = data)
                {
                }
            }
        }
    }

    class SafeClass
    {
    }
}
