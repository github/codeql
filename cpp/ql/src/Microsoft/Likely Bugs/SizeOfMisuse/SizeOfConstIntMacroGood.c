#define SOMESTRUCT_ERRNO_THAT_MATTERS 0x8000000d

typedef struct {
	int a;
	bool b;
} SOMESTRUCT_THAT_MATTERS;

if (somedata.length >= sizeof(SOMESTRUCT_THAT_MATTERS)) 
{
	/// Do something
}