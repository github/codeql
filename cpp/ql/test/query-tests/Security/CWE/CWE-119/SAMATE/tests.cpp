// A sample of tests from the SAMATE Juliet framework for rule CWE-119.

// library types, functions etc
typedef unsigned long size_t;
void *malloc(size_t size);
void *alloca(size_t size);
void free(void *ptr);
#define ALLOCA alloca

void *memcpy(void *s1, const void *s2, size_t n);
void *memset(void *s, int c, size_t n);
char *strcpy(char *s1, const char *s2);
size_t strlen(const char *s);

void exit(int status);

typedef unsigned int DWORD;
DWORD GetCurrentDirectoryA(DWORD bufferLength, char *buffer);
bool PathAppendA(char *path, const char *more);
#define MAX_PATH 4096

void printLine(const char *str);
void printSizeTLine(size_t val);
void printIntLine(int val);

// ----------

#define SRC_STR "0123456789abcde0123"

typedef struct _charVoid
{
    char charFirst[16];
    void * voidSecond;
    void * voidThird;
} charVoid;

void CWE121_Stack_Based_Buffer_Overflow__char_type_overrun_memcpy_01_bad()
{
    {
        charVoid structCharVoid;
        structCharVoid.voidSecond = (void *)SRC_STR;
        /* Print the initial block pointed to by structCharVoid.voidSecond */
        printLine((char *)structCharVoid.voidSecond);
        /* FLAW: Use the sizeof(structCharVoid) which will overwrite the pointer voidSecond */
        memcpy(structCharVoid.charFirst, SRC_STR, sizeof(structCharVoid));
        structCharVoid.charFirst[(sizeof(structCharVoid.charFirst)/sizeof(char))-1] = '\0'; /* null terminate the string */
        printLine((char *)structCharVoid.charFirst);
        printLine((char *)structCharVoid.voidSecond);
    }
}

void CWE122_Heap_Based_Buffer_Overflow__char_type_overrun_memcpy_01_bad()
{
    {
        charVoid * structCharVoid = (charVoid *)malloc(sizeof(charVoid));
        structCharVoid->voidSecond = (void *)SRC_STR;
        /* Print the initial block pointed to by structCharVoid->voidSecond */
        printLine((char *)structCharVoid->voidSecond);
        /* FLAW: Use the sizeof(*structCharVoid) which will overwrite the pointer y */
        memcpy(structCharVoid->charFirst, SRC_STR, sizeof(*structCharVoid));
        structCharVoid->charFirst[(sizeof(structCharVoid->charFirst)/sizeof(char))-1] = '\0'; /* null terminate the string */
        printLine((char *)structCharVoid->charFirst);
        printLine((char *)structCharVoid->voidSecond);
        free(structCharVoid);
    }
}

void CWE124_Buffer_Underwrite__char_alloca_cpy_01_bad()
{
    char * data;
    char * dataBuffer = (char *)ALLOCA(100*sizeof(char));
    memset(dataBuffer, 'A', 100-1);
    dataBuffer[100-1] = '\0';
    /* FLAW: Set data pointer to before the allocated memory buffer */
    data = dataBuffer - 8;
    {
        char source[100];
        memset(source, 'C', 100-1); /* fill with 'C's */
        source[100-1] = '\0'; /* null terminate */
        /* POTENTIAL FLAW: Possibly copying data to memory before the destination buffer */
        strcpy(data, source); // [NOT DETECTED]
        printLine(data);
    }
}

void CWE126_Buffer_Overread__char_alloca_loop_01_bad()
{
    char * data;
    char * dataBadBuffer = (char *)ALLOCA(50*sizeof(char));
    char * dataGoodBuffer = (char *)ALLOCA(100*sizeof(char));
    memset(dataBadBuffer, 'A', 50-1); /* fill with 'A's */
    dataBadBuffer[50-1] = '\0'; /* null terminate */
    memset(dataGoodBuffer, 'A', 100-1); /* fill with 'A's */
    dataGoodBuffer[100-1] = '\0'; /* null terminate */
    /* FLAW: Set data pointer to a small buffer */
    data = dataBadBuffer;
    {
        size_t i, destLen;
        char dest[100];
        memset(dest, 'C', 100-1);
        dest[100-1] = '\0'; /* null terminate */
        destLen = strlen(dest);
        /* POTENTIAL FLAW: using length of the dest where data
         * could be smaller than dest causing buffer overread */
        for (i = 0; i < destLen; i++)
        {
            dest[i] = data[i]; // [NOT DETECTED]
        }
        dest[100-1] = '\0';
        printLine(dest);
    }
}

void CWE127_Buffer_Underread__char_alloca_cpy_01_bad()
{
    char * data;
    char * dataBuffer = (char *)ALLOCA(100*sizeof(char));
    memset(dataBuffer, 'A', 100-1);
    dataBuffer[100-1] = '\0';
    /* FLAW: Set data pointer to before the allocated memory buffer */
    data = dataBuffer - 8;
    {
        char dest[100*2];
        memset(dest, 'C', 100*2-1); /* fill with 'C's */
        dest[100*2-1] = '\0'; /* null terminate */
        /* POTENTIAL FLAW: Possibly copy from a memory location located before the source buffer */
        strcpy(dest, data); // [NOT DETECTED]
        printLine(dest);
    }
}

#define BAD_PATH_SIZE (MAX_PATH / 2) /* maintenance note: must be < MAX_PATH in order for 'bad' to be 'bad' */

void CWE785_Path_Manipulation_Function_Without_Max_Sized_Buffer__w32_01_bad()
{
    {
        char path[BAD_PATH_SIZE];
        DWORD length;
        length = GetCurrentDirectoryA(BAD_PATH_SIZE, path);
        if (length == 0 || length >= BAD_PATH_SIZE) /* failure conditions for this API call */
        {
            exit(1);
        }
        /* FLAW: PathAppend assumes the 'path' parameter is MAX_PATH */
        /* INCIDENTAL: CWE 121 stack based buffer overflow, which is intrinsic to
         * this example identified on the CWE webpage */
        if (!PathAppendA(path, "AAAAAAAAAAAA")) // [NOT DETECTED]
        {
            exit(1);
        }
        printSizeTLine(strlen(path));
        printIntLine(BAD_PATH_SIZE);
        printLine(path);
    }
}

#define NULL (0)

void CWE122_Heap_Based_Buffer_Overflow__c_CWE805_char_memcpy_01_bad()
{
    char * data;
    data = NULL;
    /* FLAW: Allocate and point data to a small buffer that is smaller than the large buffer used in the sinks */
    data = (char *)malloc(50*sizeof(char));
    data[0] = '\0'; /* null terminate */
    {
        char source[100];
        memset(source, 'C', 100-1); /* fill with 'C's */
        source[100-1] = '\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if source is larger than data */
        memcpy(data, source, 100*sizeof(char));
        data[100-1] = '\0'; /* Ensure the destination buffer is null terminated */
        printLine(data);
        free(data);
    }
}

void CWE121_Stack_Based_Buffer_Overflow__CWE805_char_declare_memcpy_01_bad()
{
    char * data;
    char dataBadBuffer[50];
    char dataGoodBuffer[100];
    /* FLAW: Set a pointer to a "small" buffer. This buffer will be used in the sinks as a destination
     * buffer in various memory copying functions using a "large" source buffer. */
    data = dataBadBuffer;
    data[0] = '\0'; /* null terminate */
    {
        char source[100];
        memset(source, 'C', 100-1); /* fill with 'C's */
        source[100-1] = '\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if the size of data is less than the length of source */
        memcpy(data, source, 100*sizeof(char));
        data[100-1] = '\0'; /* Ensure the destination buffer is null terminated */
        printLine(data);
    }
}

void CWE121_Stack_Based_Buffer_Overflow__CWE805_char_alloca_memcpy_01_bad()
{
    char * data;
    char * dataBadBuffer = (char *)ALLOCA(50*sizeof(char));
    char * dataGoodBuffer = (char *)ALLOCA(100*sizeof(char));
    /* FLAW: Set a pointer to a "small" buffer. This buffer will be used in the sinks as a destination
     * buffer in various memory copying functions using a "large" source buffer. */
    data = dataBadBuffer;
    data[0] = '\0'; /* null terminate */
    {
        char source[100];
        memset(source, 'C', 100-1); /* fill with 'C's */
        source[100-1] = '\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if the size of data is less than the length of source */
        memcpy(data, source, 100*sizeof(char));
        data[100-1] = '\0'; /* Ensure the destination buffer is null terminated */
        printLine(data);
    }
}

void CWE121_Stack_Based_Buffer_Overflow__CWE805_char_alloca_loop_01_bad()
{
    char * data;
    char * dataBadBuffer = (char *)ALLOCA(50*sizeof(char));
    char * dataGoodBuffer = (char *)ALLOCA(100*sizeof(char));
    /* FLAW: Set a pointer to a "small" buffer. This buffer will be used in the sinks as a destination
     * buffer in various memory copying functions using a "large" source buffer. */
    data = dataBadBuffer;
    data[0] = '\0'; /* null terminate */
    {
        size_t i;
        char source[100];
        memset(source, 'C', 100-1); /* fill with 'C's */
        source[100-1] = '\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if the size of data is less than the length of source */
        for (i = 0; i < 100; i++)
        {
            data[i] = source[i];
        }
        data[100-1] = '\0'; /* Ensure the destination buffer is null terminated */
        printLine(data);
    }
}

void CWE121_Stack_Based_Buffer_Overflow__CWE805_char_declare_loop_01_bad()
{
    char * data;
    char dataBadBuffer[50];
    char dataGoodBuffer[100];
    /* FLAW: Set a pointer to a "small" buffer. This buffer will be used in the sinks as a destination
     * buffer in various memory copying functions using a "large" source buffer. */
    data = dataBadBuffer;
    data[0] = '\0'; /* null terminate */
    {
        size_t i;
        char source[100];
        memset(source, 'C', 100-1); /* fill with 'C's */
        source[100-1] = '\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if the size of data is less than the length of source */
        for (i = 0; i < 100; i++)
        {
            data[i] = source[i];
        }
        data[100-1] = '\0'; /* Ensure the destination buffer is null terminated */
        printLine(data);
    }
}

wchar_t *wcsncpy(wchar_t *destination, const wchar_t *source, size_t num);
size_t wcslen(const wchar_t *str);
char *strcat(char *destination, const char *source);
char *strncat(char *destination, const char *source, size_t num);

void *memmove(void *destination, const void *source, size_t num);

void printWLine(const wchar_t *line);

/* MAINTENANCE NOTE: The length of this string should equal the 10 */
#define SRC_STRING L"AAAAAAAAAA"

namespace CWE122_Heap_Based_Buffer_Overflow__cpp_CWE193_wchar_t_ncpy_01
{
    void bad()
    {
        wchar_t * data;
        data = NULL;
        /* FLAW: Did not leave space for a null terminator */
        data = new wchar_t[10];
        {
            wchar_t source[10+1] = SRC_STRING;
            /* Copy length + 1 to include NUL terminator from source */
            /* POTENTIAL FLAW: data may not have enough space to hold source */
            wcsncpy(data, source, wcslen(source) + 1);
            printWLine(data);
            delete [] data;
        }
    }
    
    static void goodG2B()
	{
		wchar_t * data;
		data = NULL;
		/* FIX: Allocate space for a null terminator */
		data = new wchar_t[10+1];
		{
			wchar_t source[10+1] = SRC_STRING;
			/* Copy length + 1 to include NUL terminator from source */
			/* POTENTIAL FLAW: data may not have enough space to hold source */
			wcsncpy(data, source, wcslen(source) + 1); // [FALSE POSITIVE RESULT] (debatable)
			printWLine(data);
			delete [] data;
		}
	}
} /* close namespace */

namespace CWE122_Heap_Based_Buffer_Overflow__cpp_CWE193_wchar_t_memmove_31
{
    void bad()
    {
        wchar_t * data;
        data = NULL;
        /* FLAW: Did not leave space for a null terminator */
        data = new wchar_t[10];
        {
            wchar_t * dataCopy = data;
            wchar_t * data = dataCopy;
            {
                wchar_t source[10+1] = SRC_STRING;
                /* Copy length + 1 to include NUL terminator from source */
                /* POTENTIAL FLAW: data may not have enough space to hold source */
                memmove(data, source, (wcslen(source) + 1) * sizeof(wchar_t)); // [NOT DETECTED]
                printWLine(data);
                delete [] data;
            }
        }
    }
} /* close namespace */

namespace CWE122_Heap_Based_Buffer_Overflow__cpp_CWE805_char_ncat_01
{
    void bad()
    {
        char * data;
        data = NULL;
        /* FLAW: Allocate using new[] and point data to a small buffer that is smaller than the large buffer used in the sinks */
        data = new char[50];
        data[0] = '\0'; /* null terminate */
        {
            char source[100];
            memset(source, 'C', 100-1); /* fill with 'C's */
            source[100-1] = '\0'; /* null terminate */
            /* POTENTIAL FLAW: Possible buffer overflow if source is larger than sizeof(data)-strlen(data) */
            strncat(data, source, 100);
            printLine(data);
            delete [] data;
        }
    }
} /* close namespace */

void CWE122_Heap_Based_Buffer_Overflow__c_dest_char_cat_01_bad()
{
    char * data;
    data = NULL;
    /* FLAW: Allocate and point data to a small buffer that is smaller than the large buffer used in the sinks */
    data = (char *)malloc(50*sizeof(char));
    data[0] = '\0'; /* null terminate */
    {
        char source[100];
        memset(source, 'C', 100-1); /* fill with 'C's */
        source[100-1] = '\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if source is larger than sizeof(data)-strlen(data) */
        strcat(data, source); // [NOT DETECTED]
        printLine(data);
        free(data);
    }
}

void CWE121_Stack_Based_Buffer_Overflow__CWE131_memcpy_01_bad()
{
    int * data;
    data = NULL;
    /* FLAW: Allocate memory without using sizeof(int) */
    data = (int *)ALLOCA(10);
    {
        int source[10] = {0};
        /* POTENTIAL FLAW: Possible buffer overflow if data was not allocated correctly in the source */
        memcpy(data, source, 10*sizeof(int));
        printIntLine(data[0]);
    }
}

typedef long long int64_t;
wchar_t *wmemset(wchar_t *dest, wchar_t c, size_t count);
void* calloc(size_t num, size_t size);

void printLongLongLine(int64_t longLongIntNumber);
void printDoubleLine(double doubleNumber);

void CWE122_Heap_Based_Buffer_Overflow__cpp_CWE805_int64_t_loop_01_bad()
{
    int64_t * data;
    data = NULL;
    /* FLAW: Allocate using new[] and point data to a small buffer that is smaller than the large buffer used in the sinks */
    data = new int64_t[50];
    {
        int64_t source[100] = {0}; /* fill with 0's */
        {
            size_t i;
            /* POTENTIAL FLAW: Possible buffer overflow if data < 100 */
            for (i = 0; i < 100; i++)
            {
                data[i] = source[i]; // [NOT DETECTED]
            }
            printLongLongLine(data[0]);
            delete [] data;
        }
    }
}

void CWE122_Heap_Based_Buffer_Overflow__cpp_CWE805_wchar_t_loop_01_bad()
{
    wchar_t * data;
    data = NULL;
    /* FLAW: Allocate using new[] and point data to a small buffer that is smaller than the large buffer used in the sinks */
    data = new wchar_t[50];
    data[0] = L'\0'; /* null terminate */
    {
        size_t i;
        wchar_t source[100];
        wmemset(source, L'C', 100-1); /* fill with L'C's */
        source[100-1] = L'\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if source is larger than data */
        for (i = 0; i < 100; i++)
        {
            data[i] = source[i];
        }
        data[100-1] = L'\0'; /* Ensure the destination buffer is null terminated */
        printWLine(data);
        delete [] data;
    }
}

void CWE122_Heap_Based_Buffer_Overflow__cpp_CWE805_wchar_t_ncpy_01_bad()
{
    wchar_t * data;
    data = NULL;
    /* FLAW: Allocate using new[] and point data to a small buffer that is smaller than the large buffer used in the sinks */
    data = new wchar_t[50];
    data[0] = L'\0'; /* null terminate */
    {
        wchar_t source[100];
        wmemset(source, L'C', 100-1); /* fill with L'C's */
        source[100-1] = L'\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if source is larger than data */
        wcsncpy(data, source, 100-1);
        data[100-1] = L'\0'; /* Ensure the destination buffer is null terminated */
        printWLine(data);
        delete [] data;
    }
}

#ifdef _WIN32
int _snwprintf(wchar_t *buffer, size_t count, const wchar_t *format, ...);
#define SNPRINTF _snwprintf
#else 
int snprintf(char *s, size_t n, const char *format, ...);
int swprintf(wchar_t *wcs, size_t maxlen, const wchar_t *format, ...);
//#define SNPRINTF snprintf --- original code; using snprintf appears to be a mistake in samate?
#define SNPRINTF swprintf
#endif

void CWE122_Heap_Based_Buffer_Overflow__cpp_CWE805_wchar_t_snprintf_01_bad()
{
    wchar_t * data;
    data = NULL;
    /* FLAW: Allocate using new[] and point data to a small buffer that is smaller than the large buffer used in the sinks */
    data = new wchar_t[50];
    data[0] = L'\0'; /* null terminate */
    {
        wchar_t source[100];
        wmemset(source, L'C', 100-1); /* fill with L'C's */
        source[100-1] = L'\0'; /* null terminate */
        /* POTENTIAL FLAW: Possible buffer overflow if source is larger than data */
        SNPRINTF(data, 100, L"%s", source);
        printWLine(data);
        delete [] data;
    }
}

/* classes used in some test cases as a custom type */
class TwoIntsClass 
{
    public: // Needed to access variables from label files
        int intOne;
        int intTwo;
};

class OneIntClass 
{
    public: // Needed to access variables from label files
        int intOne;
};

void *operator new(size_t size, void *ptr) throw(); // placement new (from #include <new>)

void CWE122_Heap_Based_Buffer_Overflow__placement_new_01_bad()
{
    char * data;
    char * dataBadBuffer = (char *)malloc(sizeof(OneIntClass));
    char * dataGoodBuffer = (char *)malloc(sizeof(TwoIntsClass));
    /* POTENTIAL FLAW: Initialize data to a buffer small than the sizeof(TwoIntsClass) */
    data = dataBadBuffer;
    {
        /* The Visual C++ compiler generates a warning if you initialize the class with ().
         * This will cause the compile to default-initialize the object.
         * See http://msdn.microsoft.com/en-us/library/wewb47ee%28v=VS.100%29.aspx
         */
        /* POTENTIAL FLAW: data may not be large enough to hold a TwoIntsClass */
        TwoIntsClass * classTwo = new(data) TwoIntsClass; // [NOT DETECTED]
        /* Initialize and make use of the class */
        classTwo->intOne = 5;
        classTwo->intTwo = 10; /* POTENTIAL FLAW: If sizeof(data) < sizeof(TwoIntsClass) then this line will be a buffer overflow */
        printIntLine(classTwo->intOne);
        /* skip printing classTwo->intTwo since that could be a buffer overread */
        free(data);
    }
}

void CWE122_Heap_Based_Buffer_Overflow__sizeof_double_01_bad()
{
    double * data;
    /* Initialize data */
    data = NULL;
    /* INCIDENTAL: CWE-467 (Use of sizeof() on a pointer type) */
    /* FLAW: Using sizeof the pointer and not the data type in malloc() */
    data = (double *)malloc(sizeof(data)); // [NOT DETECTED]
    *data = 1.7E300;
    /* POTENTIAL FLAW: Attempt to use data, which may not have enough memory allocated */
    printDoubleLine(*data);
    free(data);
}

int rand(void);
#define RAND32() ((rand()<<30) ^ (rand()<<15) ^ rand())

void CWE122_Heap_Based_Buffer_Overflow__c_CWE129_rand_01_bad()
{
    int data;
    /* Initialize data */
    data = -1;
    /* POTENTIAL FLAW: Set data to a random value */
    data = RAND32();
    {
        int i;
        int * buffer = (int *)malloc(10 * sizeof(int));
        /* initialize buffer */
        for (i = 0; i < 10; i++)
        {
            buffer[i] = 0;
        }
        /* POTENTIAL FLAW: Attempt to write to an index of the array that is above the upper bound
         * This code does check to see if the array index is negative */
        if (data >= 0)
        {
            buffer[data] = 1; // [NOT DETECTED]
            /* Print the array values */
            for(i = 0; i < 10; i++)
            {
                printIntLine(buffer[i]);
            }
        }
        else
        {
            printLine("ERROR: Array index is negative.");
        }
        free(buffer);
    }
}

typedef struct FILE;
int fscanf(FILE *stream, const char *format, ...);
FILE *stdin;

void CWE122_Heap_Based_Buffer_Overflow__c_CWE129_fscanf_01_bad()
{
    int data;
    /* Initialize data */
    data = -1;
    /* POTENTIAL FLAW: Read data from the console using fscanf() */
    fscanf(stdin, "%d", &data);
    {
        int i;
        int * buffer = (int *)malloc(10 * sizeof(int));
        /* initialize buffer */
        for (i = 0; i < 10; i++)
        {
            buffer[i] = 0;
        }
        /* POTENTIAL FLAW: Attempt to write to an index of the array that is above the upper bound
         * This code does check to see if the array index is negative */
        if (data >= 0)
        {
            buffer[data] = 1; // [NOT DETECTED]
            /* Print the array values */
            for(i = 0; i < 10; i++)
            {
                printIntLine(buffer[i]);
            }
        }
        else
        {
            printLine("ERROR: Array index is negative.");
        }
        free(buffer);
    }
}

void CWE122_Heap_Based_Buffer_Overflow__cpp_CWE805_wchar_t_snprintf_31_bad()
{
    wchar_t * data;
    data = NULL;
    /* FLAW: Allocate using new[] and point data to a small buffer that is smaller than the large buffer used in the sinks */
    data = new wchar_t[50];
    data[0] = L'\0'; /* null terminate */
    {
        wchar_t * dataCopy = data;
        wchar_t * data = dataCopy;
        {
            wchar_t source[100];
            wmemset(source, L'C', 100-1); /* fill with L'C's */
            source[100-1] = L'\0'; /* null terminate */
            /* POTENTIAL FLAW: Possible buffer overflow if source is larger than data */
            SNPRINTF(data, 100, L"%s", source);
            printWLine(data);
            delete [] data;
        }
    }
}

int rand(void);

int globalReturnsTrueOrFalse() 
{
    return (rand() % 2);
}

#define SRC_STRING "AAAAAAAAAA"

void CWE121_Stack_Based_Buffer_Overflow__CWE193_char_declare_cpy_12_bad()
{
    char * data;
    char dataBadBuffer[10];
    char dataGoodBuffer[10+1];
    if(globalReturnsTrueOrFalse())
    {
        /* FLAW: Set a pointer to a buffer that does not leave room for a NULL terminator when performing
         * string copies in the sinks  */
        data = dataBadBuffer;
        data[0] = '\0'; /* null terminate */
    }
    else
    {
        /* FIX: Set a pointer to a buffer that leaves room for a NULL terminator when performing
         * string copies in the sinks  */
        data = dataGoodBuffer;
        data[0] = '\0'; /* null terminate */
    }
    {
        char source[10+1] = SRC_STRING;
        /* POTENTIAL FLAW: data may not have enough space to hold source */
        strcpy(data, source);
        printLine(data);
    }
}
