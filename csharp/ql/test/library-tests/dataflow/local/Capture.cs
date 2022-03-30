using System;

public class Capture
{
    public void M()
    {
        int i = 0;

        void CapIn1()
        { // implicit `i` parameter
            Use(i);
        }
        CapIn1(); // implicit `i` argument

        void CapIn2()
        { // implicit `i` parameter
            void CapIn3()
            { // implicit `i` parameter
                Use(i);
            }
            CapIn3(); // implicit `i` argument
        }
        CapIn2(); // implicit `i` argument

        void CapIn4()
        { // implicit `i` parameter
            void CapIn5()
            { // implicit `i` parameter
                Use(i);
            }
            i = 1;
            CapIn5(); // implicit `i` argument
        }
        CapIn4(); // implicit `i` argument

        void CapOut1()
        {
            i = 0; // implicit `i` return
        }
        CapOut1(); // implicit `i` out
        Use(i);

        void CapOut2()
        {
            void CapOut3()
            {
                i = 0; // implicit `i` return
            }
            CapOut3(); // implicit `i` return + out
        }
        CapOut2(); // implicit `i` out
        Use(i);

        void CapOut4()
        {
            void CapOut5()
            {
                i = 1; // implicit `i` return
            }
            CapOut5();
            i = 1; // implicit `i` return
        }
        CapOut4(); // implicit `i` out
        Use(i);
    }

    static void Use<T>(T x) { }
}
