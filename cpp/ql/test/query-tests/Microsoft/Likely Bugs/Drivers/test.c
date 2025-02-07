// semmle-extractor-options: --microsoft
typedef unsigned __int64 size_t;

size_t RtlCompareMemory(
	const void* Source1,
	const void* Source2,
	size_t Length
)
{
	return Length;
}


#define bool	_Bool
#define false	0
#define true	1

typedef unsigned char UCHAR;
typedef UCHAR BOOLEAN;           // winnt
#define FALSE   0
#define TRUE    1

int Test(const void* ptr)
{
	size_t t = RtlCompareMemory("test", ptr, 5); //OK
	bool x;
	BOOLEAN y;

	if (t > 0 && RtlCompareMemory("test", ptr, 5)) //bug
	{
		t++;
	}

	if (!RtlCompareMemory("test", ptr, 4)) //bug
	{
		t--;
	}

	if (RtlCompareMemory("test", ptr, 4)) //bug
	{
		t--;
	}

	if (6 == RtlCompareMemory("test", ptr, 4)) //OK
	{
		t++;
	}

	if (0 == RtlCompareMemory("test", ptr, 4)) // potentially a bug (lower precision)
	{
		t++;
	}

	if (6 == RtlCompareMemory("test", ptr, 4) + 1) //OK
	{
		t++;
	}

	if (0 == RtlCompareMemory("test", ptr, 4) + 1) // OK
	{
		t++;
	}

	switch (RtlCompareMemory("test", ptr, 4))
	{
	case 1:
		t--;
		break;
	default:
		t++;
	}

	/// _Bool

	x = RtlCompareMemory("test", ptr, 4); // bug

	if (false == RtlCompareMemory("test", ptr, 4)) // bug
	{
		t++;
	}

	// BOOLEAN

	y = RtlCompareMemory("test", ptr, 4); // bug

	if (TRUE == RtlCompareMemory("test", ptr, 4)) // bug
	{
		t++;
	}

	return (t == 5) && RtlCompareMemory("test", ptr, 5); //bug
}
