unsigned short CheckForInt16OverflowBadCode(unsigned short v, unsigned short b)
{
    if (v + b < v) // BUG: "v + b" will be promoted to 32 bits
    {
        // ... do something
    }

    return v + b;
}
