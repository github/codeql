void Signed()
{
    signed char i;

    for (i = 0; i < 100; i--)   //BUG
    {
    } // $ Alert

    for (i = 0; i < 100; i++)
    {
    }

    for (i = 100; i >= 0; i++)   //BUG
    {
    } // $ Alert

    for (i = 100; i >= 0; i--)
    {
    }

}

void Unsigned()
{
    unsigned long i;

    for (i = 0; i < 100; i--)   //BUG
    {
    } // $ Alert

    for (i = 0; i < 100; i++)
    {
    }

    for (i = 100; i >= 0; i++)   //BUG
    {
    } // $ Alert

    for (i = 100; i >= 0; i--)
    {
    }
}

void DeclarationInLoop()
{
    for (signed char i = 0; i < 100; --i)   //BUG
    {
    } // $ Alert

    for (signed char i = 0; i < 100; ++i)
    {
    }

    for (unsigned char i = 100; i >= 0; ++i)   //BUG
    {
    } // $ Alert

    for (unsigned char i = 100; i >= 0; --i)
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
    } // $ Alert

    for (i = min; i < max; i++)
    {
    }

    for (i = max; i >= min; i++)   //BUG
    {
    } // $ Alert

    for (i = max; i >= min; i--)
    {
    }

}

void InitializationOutsideLoop()
{
    signed char i = 0;

    for (; i < 100; --i)   //BUG
    {
    } // $ Alert

    i = 0;
    for (; i < 100; ++i)
    {
    }

    i = 100;
    for (; i >= 0; ++i)   //BUG
    {
    } // $ Alert

    i = 100;
    for (; i >= 0; --i)
    {
    }
}


void InvalidCondition()
{
    signed char i;
    signed char min = 0;
    signed char max = 100;

    for (i = max; i < min; i--)   //BUG
    {
    } // $ Alert

    for (i = min; i > max; i++)   //BUG
    {
    } // $ Alert
}

void InvalidConditionUnsignedCornerCase()
{
    unsigned char i;
    unsigned char min = 0;
    unsigned char max = 100;

    for (i = 100; i < 0; i--)   //BUG
    {
    } // $ Alert

    // Limitation.
    // Currently odasa will not detect this for-loop condition as always true
    // The rule will still detect the mismatch iterator, but the error message may change in the future.
    for (i = 200; i >= 0; i++)   //BUG
    {
    } // $ Alert
}

void NegativeTestCase()
{
    for (int i = 0; (100 - i) < 200; i--)
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

//////////////////////////////////////
// Query limitation:
//
// The following test cases are bugs,
// but will not be found due to the itearion expression
// not being a prefix or postfix increment/decrement
//
void FalseNegativeTestCases()
{
    for (int i = 0; i < 10; i = i - 1) {}
    // For comparison
    for (int i = 0; i < 10; i-- ) {} // $ Alert // BUG

    for (int i = 100; i > 0; i += 2) {}
    // For comparison
    for (int i = 100; i > 0; i ++ ) {}  // $ Alert // BUG
}

void IntendedOverflow(unsigned char p)
{
    const unsigned char m = 10;
    unsigned char i;
    signed char s;

    for (i = 63; i < 64; i--) {} // GOOD (legitimate way to count down with an unsigned)
    for (i = 63; i < 128; i--) {} // DUBIOUS (could still be a typo?)
    for (i = 63; i < 255; i--) {} // GOOD

    for (i = m - 1; i < m; i--) {} // GOOD
    for (i = m - 2; i < m; i--) {} // DUBIOUS
    for (i = m; i < m + 1; i--) {} // GOOD

    for (s = 63; s < 64; s--) {} // $ Alert // BAD (signed numbers don't wrap at 0 / at all)
    for (s = m + 1; s < m; s--) {} // $ Alert // BAD (never runs)

    for (i = p - 1; i < p; i--) {} // GOOD
    for (s = p - 1; s < p; s--) {} // $ MISSING: Alert // BAD [NOT DETECTED]

	{
		int n;

		n = 64;
		for (i = n - 1; i < n; i--) {} // GOOD
		n = 64;
		for (i = n - 1; i < 64; i--) {} // GOOD
		n = 64;
		for (i = 63; i < n; i--) {} // GOOD

		n = 64;
		for (s = n - 1; s < n; s--) {} // $ MISSING: Alert // BAD [NOT DETECTED]
		n = 64;
		for (s = n - 1; s < 64; s--) {} // $ Alert // BAD
		n = 64;
		for (s = 63; s < n; s--) {} // $ MISSING: Alert // BAD [NOT DETECTED]
	}
}
