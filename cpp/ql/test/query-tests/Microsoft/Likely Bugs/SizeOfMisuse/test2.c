#define PAGESIZE 64
#define BAD_MACRO_CONST 5l
#define BAD_MACRO_CONST2 0x80005001
#define BAD_MACRO_OP1(VAR) strlen(#VAR)
#define BAD_MACRO_OP2(VAR) sizeof(VAR)/sizeof(int)

long strlen(const char* x) { return 5; }

#define ALIGN_UP_BY(length, sizeofType) length * sizeofType
#define ALIGN_UP(length, type) \
	ALIGN_UP_BY(length, sizeof(type))

#define SOME_SIZEOF_MACRO (sizeof(int) * 3)
#define SOME_SIZEOF_MACRO_CAST ((char)(sizeof(int) * 3))


#define SOME_SIZEOF_MACRO2 (sizeof(int))

typedef unsigned short WCHAR;    // wc,   16-bit UNICODE character

#define UNICODE_NULL1 ((WCHAR)0)

#define ASCII_NULL ((char)0)

#define UNICODE_STRING_SIG         L"xtra"
#define ASCII_STRING_SIG         "xtra"

#define UNICODE_SIG         L'x'

#define ACE_CONDITION_SIGNATURE1         'xtra'
#define ACE_CONDITION_SIGNATURE2         'xt'

#define ACE_CONDITION_SIGNATURE3(VAL)    #VAL

#define NULL (void *)0

#define EFI_FILEPATH_SEPARATOR_UNICODE L'\\'

const char* Test()
{
	return "foobar";
}

#define FUNCTION_MACRO_OP1 Test()

#define SOMESTRUCT_ERRNO_THAT_MATTERS 0x8000000d


char _RTL_CONSTANT_STRING_type_check(const void* s) {
	return ((char*)(s))[0];
}

#define RTL_CONSTANT_STRING(s) \
{ \
    sizeof( s ) - sizeof( (s)[0] ); \
    sizeof( s ) / sizeof(_RTL_CONSTANT_STRING_type_check(s)); \
}

typedef struct {
	int a;
	char b;
} SOMESTRUCT_THAT_MATTERS;

void Test01() {

	RTL_CONSTANT_STRING("hello");

	sizeof(NULL);
	sizeof(EFI_FILEPATH_SEPARATOR_UNICODE);

	int y = sizeof(SOMESTRUCT_THAT_MATTERS);
	y = sizeof(SOMESTRUCT_ERRNO_THAT_MATTERS); // BUG: SizeOfConstIntMacro

	const unsigned short* p = UNICODE_STRING_SIG;
	const char* p2 = ASCII_STRING_SIG;
	char p3 = 'xtra';
	unsigned short p4 = L'xtra';

	int a[10];
	int x = sizeof(BAD_MACRO_CONST); //BUG: SizeOfConstIntMacro
	x = sizeof(BAD_MACRO_CONST2); //BUG: SizeOfConstIntMacro

	x = sizeof(FUNCTION_MACRO_OP1); // GOOD

	x = sizeof(BAD_MACRO_OP1(a)); //BUG: ArgumentIsFunctionCall (Low Prec)
	x = sizeof(BAD_MACRO_OP2(a)); //BUG: ArgumentIsSizeofOrOperation

	x = 0;
	x += ALIGN_UP(sizeof(a), PAGESIZE); //BUG: SizeOfConstIntMacro
	x += ALIGN_UP_BY(sizeof(a), PAGESIZE); // GOOD

	x = SOME_SIZEOF_MACRO * 3; // GOOD
	x = sizeof(SOME_SIZEOF_MACRO) * 3; //BUG: ArgumentIsSizeofOrOperation

	x = sizeof(SOME_SIZEOF_MACRO_CAST) * 3; //BUG: ArgumentIsSizeofOrOperation

	x = SOME_SIZEOF_MACRO2; // GOOD
	x = sizeof(SOME_SIZEOF_MACRO2); //BUG: SizeOfConstIntMacro, ArgumentIsSizeofOrOperation

	x = sizeof(a) / sizeof(int); // GOOD

	x = sizeof(UNICODE_NULL1);

	x = sizeof(ASCII_NULL);

	x = sizeof(UNICODE_STRING_SIG);
	x = sizeof(ASCII_STRING_SIG);

	x = sizeof(UNICODE_SIG);

	x = sizeof(ACE_CONDITION_SIGNATURE1); // GOOD (special case)
	x = sizeof(ACE_CONDITION_SIGNATURE2); // BUG: SizeOfConstIntMacro

	x = sizeof(ACE_CONDITION_SIGNATURE3(xtra));

	x = sizeof(sizeof(int)); // BUG: ArgumentIsSizeofOrOperation
	x = sizeof(3 + 2); // BUg: ArgumentIsSizeofOrOperation
}
