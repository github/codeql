unsigned long sizeArray;

// BAD: let's consider several values, taking ULONG_MAX =18446744073709551615
// sizeArray = 60; (sizeArray - 10) = 50; true
// sizeArray = 10; (sizeArray - 10) = 0; false
// sizeArray = 1; (sizeArray - 10) = 18446744073709551607; true
// sizeArray = 0; (sizeArray - 10) = 18446744073709551606; true
if (sizeArray - 10 > 0)

// GOOD: Prevent overflow by checking the input
if (sizeArray > 10)
