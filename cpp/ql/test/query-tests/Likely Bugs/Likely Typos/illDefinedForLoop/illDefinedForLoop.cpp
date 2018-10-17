void Signed()
{
    signed char i;

    for (i = 0; i < 100; i--)   //BUG
    {
    }

    for (i = 0; i < 100; i++)
    {
    }

    for (i = 100; i >= 0; i++)   //BUG
    {
    }

    for (i = 100; i >= 0; i--)
    {
    }

}

void Unsigned()
{
    unsigned long i;

    for (i = 0; i < 100; i--)   //BUG
    {
    }

    for (i = 0; i < 100; i++)
    {
    }

    for (i = 100; i >= 0; i++)   //BUG
    {
    }

    for (i = 100; i >= 0; i--)
    {
    }
}

void DeclarationInLoop()
{
    for (signed char i = 0; i < 100; i--)   //BUG
    {
    }

    for (signed char i = 0; i < 100; i++)
    {
    }

    for (unsigned char i = 100; i >= 0; i++)   //BUG
    {
    }

    for (unsigned char i = 100; i >= 0; i--)
    {
    }
}

void SignedWithVariables()
{
    signed char i;
    signed char min = 0;
    signed char max = 100;

    for (i = min; i < max; i--)   //BUG
    {
    }

    for (i = min; i < max; i++)
    {
    }

    for (i = max; i >= min; i++)   //BUG
    {
    }

    for (i = max; i >= min; i--)
    {
    }

}

void InitializationOutsideLoop()
{
    signed char i = 0;

    for (; i < 100; i--)   //BUG
    {
    }

    i = 0;
    for (; i < 100; i++)
    {
    }

    i = 100;
    for (; i >= 0; i++)   //BUG
    {
    }

    i = 100;
    for (; i >= 0; i--)
    {
    }
}

void NegativeTestCase()
{
    for (int i = 0; (200 - i) < 100; i--)
    {
        // code ...
    }
}

void NegativeTestCaseNested()
{
    for (int k = 200; k < 300; k++)
    {
        for (int i = 0; (k - i) < 100; i--)
        {
            // code ...
        }
    }
}
