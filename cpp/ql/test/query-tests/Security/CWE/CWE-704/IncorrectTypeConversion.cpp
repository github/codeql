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

HRESULT IncorrectHresultFunction()
{
	return BoolFunction(); // BUG
}

void IncorrectTypeConversionTest() {
	HRESULT hr = HresultFunction();
	if ((BOOL)hr) // BUG
	{
		// ...
	}
	if (SUCCEEDED(hr)) // Correct Usage
	{
		// ...
	}

	if (SUCCEEDED(BoolFunction())) // BUG
	{
		// ...
	}
	if (BoolFunction()) // Correct Usage
	{
		// ...
	}
	BOOL b = IncorrectHresultFunction(); // BUG

	hr = E_UNEXPECTED;
	if (!hr) // BUG
	{
		// ...
	}
	if (!FAILED(hr)) // Correct Usage
	{
		// ...
	}

	hr = S_FALSE;
	if (hr) // BUG
	{
		// ...
	}
	if (SUCCEEDED(hr)) // Correct Usage
	{
		// ...
	}
}