#define SOMESTRUCT_ERRNO_THAT_MATTERS 0x8000000d

typedef struct {
	int a;
	bool b;
} SOMESTRUCT_THAT_MATTERS;

//bug, the code is using SOMESTRUCT_ERRNO_THAT_MATTERS by mistake instead of SOMESTRUCT_THAT_MATTERS
if (somedata.length >= sizeof(SOMESTRUCT_ERRNO_THAT_MATTERS)) 
{
	/// Do something
}