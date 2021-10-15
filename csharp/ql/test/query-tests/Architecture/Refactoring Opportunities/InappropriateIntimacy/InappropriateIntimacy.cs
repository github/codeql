using System;

class InappropriateIntimacy
{
    class A
    {
        public int F1;
        public int F2;
        public int F3;
        public int F4;
        public int F5;
        public int F6;
        public int F7;
        public int F8;
        public int F9;
        public int F10;
        public int F11;
        public int F12;
        public int F13;
        public int F14;
        public int F15;
        public int F16;

        int M(B b) =>
          b.F1 + b.F2 + b.F3 + b.F4 + b.F5 + b.F6 + b.F7 + b.F8 + b.F9 + b.F10 + b.F11 + b.F12 + b.F13 + b.F14 + b.F15 + b.F16;
    }

    class B
    {
        public int F1;
        public int F2;
        public int F3;
        public int F4;
        public int F5;
        public int F6;
        public int F7;
        public int F8;
        public int F9;
        public int F10;
        public int F11;
        public int F12;
        public int F13;
        public int F14;
        public int F15;
        public int F16;

        int M(A a) =>
          a.F1 + a.F2 + a.F3 + a.F4 + a.F5 + a.F6 + a.F7 + a.F8 + a.F9 + a.F10 + a.F11 + a.F12 + a.F13 + a.F14 + a.F15 + a.F16;
    }
}
