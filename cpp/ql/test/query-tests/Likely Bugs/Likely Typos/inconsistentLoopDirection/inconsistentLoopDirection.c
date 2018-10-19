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
    int i;
    for (i = 0; (200 - i) < 100; i--)
    {
        // code ...
    }
}

void NegativeTestCaseNested()
{
    int k;
    int i;

    for (k = 200; k < 300; k++)
    {
        for (i = 0; (k - i) < 100; i--)
        {
            // code ...
        }
    }
}
