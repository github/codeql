#define FLAGS   0x4004
#define cap_valid(x) ((x) >= 0 && (x) <= 4)

void C6317_positive(int i)
{
    if (i & !FLAGS) // BUG 
    {
    }
}

void C6317_negative(int i)
{
    if (i & ~FLAGS)
    {
    }
}

void bitwiseAndUsage(unsigned int l, unsigned int r)
{
    unsigned int x;
    unsigned z = 0;

    x = l & !r;         //BUG
    x = !FLAGS & r;     //BUG
    x = !FLAGS & !!r;   //BUG

    x = !!l & r;        // Not a bug - double negation
    x = !!!l & r;       // Not a bug - double negation
    x = !!FLAGS & r;    // Not a bug - double negation

    x = !FLAGS && r;    // Not a bug - logical and
    x = !FLAGS && !!r;  // Not a bug - logical and
}

void bitwiseOrUsage(unsigned int l, unsigned int r)
{
    unsigned int x;

    x = l | !r;         //BUG
    x = !FLAGS | r;     //BUG
    x = !FLAGS | !!r;   //BUG

    x = !!l | r;        // Not a bug - double negation
    x = !!!l | r;       // Not a bug - double negation
    x = !!FLAGS | r;    // Not a bug - double negation

    x = !FLAGS || r;    // Not a bug - logical or
    x = !FLAGS || !!r;  // Not a bug - logical or
}

void bitwiseXorUsage(unsigned int l, unsigned int r)
{
    unsigned int x;

    x = l ^ !r;         //BUG
    x = !FLAGS ^ r;     //BUG
    x = !FLAGS ^ !!r;   //BUG

    x = !!l ^ r;        // Not a bug - double negation
    x = !!!l ^ r;       // Not a bug - double negation
    x = !!FLAGS ^ r;    // Not a bug - double negation
}

void shoftUsage(unsigned int val)
{
    unsigned int x;

    x = !val << 1;      //BUG
    x = !val >> 1;      //BUG

    x = !!val << 2;    // Not a bug - double negation
    x = !!val >> 2;    // Not a bug - double negation
}

unsigned int bitWiseShiftUsage(unsigned int val)
{
    return ((unsigned int)(!!val) << 4) + ((unsigned int)(!!val) >> 1);  // Not a bug (double negation)
}

void macroUsage(unsigned int arg1, unsigned int arg2)
{
    if (((!cap_valid(arg1)) | arg2)) {   // BUG

    }
}
