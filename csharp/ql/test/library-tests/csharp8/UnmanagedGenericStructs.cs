using System;

struct S<T, U> where T: unmanaged
{
    int id;
    T value1;
    U value2;
}
