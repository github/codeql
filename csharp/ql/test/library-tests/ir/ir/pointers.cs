class Pointers 
{
    unsafe static void addone(int[] arr) 
    {
        int length = arr.Length;
        fixed (int* b = arr) 
        {
            int* p = b;
            for(int i = 0; i < length; i++)
                *p++ += 1;
        }
    }

    class MyClass 
    {
        public int fld1;
        public int fld2;
    }

    struct MyStruct 
    {
        public int fld;
    }

    static void Main() {
        MyClass o = new MyClass();
        MyStruct s = new MyStruct();
        unsafe 
        {
            fixed(int* p = &o.fld1, q = &o.fld2) 
            {
                *p = 0;
                *q = 0;
                MyStruct* r = &s;
                (*r).fld = 0;
            }
        }

        int[] arr = {1, 2, 3};
        addone(arr);
    }
}
