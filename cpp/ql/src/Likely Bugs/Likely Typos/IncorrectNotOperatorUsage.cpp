#define FLAGS   0x4004

void f_warning(int i)
{
    // BAD: the usage of the logical not operator in this case is unlikely to be correct
    // as the output is being used as an operator for a bit-wise and operation
    if (i & !FLAGS)
    {
        // code
    }
}

void f_fixed(int i)
{
    if (i & ~FLAGS) // GOOD: Changing the logical not operator for the bit-wise not operator would fix this logic
    {
        // code
    }
}
