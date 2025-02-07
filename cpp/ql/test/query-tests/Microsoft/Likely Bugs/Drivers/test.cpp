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


bool Test(const void* ptr)
{
	size_t t = RtlCompareMemory("test", ptr, 5); //OK

	if (t > 0 && RtlCompareMemory("test", ptr, 5)) //bug
	{
		t++;
	}

	if (!RtlCompareMemory("test", ptr, 4)) //bug
	{
		t--;
	}

	return (t == 5) && RtlCompareMemory("test", ptr, 5); //bug
}