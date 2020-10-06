using System;

class C
{
    unsafe static void M1(int[] arr)
    {
        fixed (int* i1 = arr)
        {
        }

        fixed (int* i2 = &arr[0])
        {
            int* i3 = i2;
            i3 = i3 + 1;
            *i2 = *i2 + 1;
            void* v2 = i2;
        }

        int* i4 = null;

        int number = 1024;
        byte* p = (byte*)&number;

        var s = "some string";
        fixed (char* c1 = s)
        { }
    }
}
