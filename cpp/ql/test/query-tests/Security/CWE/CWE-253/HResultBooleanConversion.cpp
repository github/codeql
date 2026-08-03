// semmle-extractor-options: --microsoft
// winnt.h
typedef long HRESULT;
#define SUCCEEDED(hr) (((HRESULT)(hr)) >= 0)
#define FAILED(hr) (((HRESULT)(hr)) < 0)

// minwindef.h
typedef int                 BOOL;
#ifndef FALSE
#define FALSE               0
#endif
#ifndef TRUE
#define TRUE                1
#endif

// winerror.h
#define S_OK                                   ((HRESULT)0L)
#define S_FALSE                                ((HRESULT)1L)
#define _HRESULT_TYPEDEF_(_sc) ((HRESULT)_sc)
#define E_UNEXPECTED                     _HRESULT_TYPEDEF_(0x8000FFFFL)

HRESULT HresultFunction()
{
    return S_OK;
}

BOOL BoolFunction()
{
    return FALSE;
}

bool BoolFunction2()
{
    return FALSE;
}

HRESULT IncorrectHresultFunction()
{
    return BoolFunction(); // $ Alert // BUG
}

HRESULT IncorrectHresultFunction2()
{
    return BoolFunction2(); // $ Alert // BUG
}

void IncorrectTypeConversionTest() {

    HRESULT hr = HresultFunction();
    if ((BOOL)hr) // $ Alert // BUG
    {
        // ...
    }
    if ((bool)hr) // $ Alert // BUG
    {
        // ...
    }
    if (SUCCEEDED(hr)) // Correct Usage
    {
        // ...
    }

    if (SUCCEEDED(BoolFunction())) // $ Alert // BUG
    {
        // ...
    }
    if (SUCCEEDED(BoolFunction2())) // $ Alert // BUG
    {
        // ...
    }
    if (BoolFunction()) // Correct Usage
    {
        // ...
    }
    BOOL b = IncorrectHresultFunction(); // $ Alert // BUG
    bool b2 = IncorrectHresultFunction(); // $ Alert // BUG

    hr = E_UNEXPECTED;
    if (!hr) // $ Alert // BUG
    {
        // ...
    }
    if (!FAILED(hr)) // Correct Usage
    {
        // ...
    }

    hr = S_FALSE;
    if (hr) // $ Alert // BUG
    {
        // ...
    }
    if (SUCCEEDED(hr)) // Correct Usage
    {
        // ...
    }

    if (HresultFunction() == S_FALSE) // Correct Usage
    {
        // ...
    }

    while (!HresultFunction()) {}; // $ Alert // BUG
    while (FAILED(HresultFunction())) {}; // Correct Usage

    switch(hr) // Correct Usage
    {
    case S_OK:
    case S_FALSE:
        {
            // ...
        } break;

    default:
        {
            // ...
        } break;
    }
}
