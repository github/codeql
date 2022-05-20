// Sample of SAMATE Juliet tests for CWE-772.

// --- library types, functions etc ---

#define NULL (0)
typedef unsigned long size_t;

void *malloc(size_t size);
void *realloc(void *ptr, size_t size);
void *alloca(size_t size);
#define ALLOCA alloca
void free(void *ptr);

typedef struct {} FILE;
FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);

char *strcpy(char *s1, const char *s2);

void printLine(const char *str);
void printIntLine(int val);

// --- open ---

typedef unsigned int mode_t;
int open(const char *path, int oflags, mode_t mode);
#define OPEN open
int close(int fd);
#define CLOSE close

#define O_RDWR (1)
#define O_CREAT (2)
#define S_IREAD (3)
#define S_IWRITE (4)

// --- Windows ---

typedef unsigned int HANDLE;
#define INVALID_HANDLE_VALUE (-1)
typedef const char *LPCTSTR;
typedef unsigned long DWORD;
typedef struct _SECURITY_ATTRIBUTES {} *LPSECURITY_ATTRIBUTES;
typedef bool BOOL;
HANDLE CreateFile(
	LPCTSTR lpFileName,
	DWORD dwDesiredAccess,
	DWORD dwShareMode,
	LPSECURITY_ATTRIBUTES lpSecurityAttributes,
	DWORD dwCreationDisposition,
	DWORD dwFlagsAndAttributes,
	HANDLE hTemplateFile);
BOOL CloseHandle(HANDLE hObject);

#define GENERIC_READ (1)
#define GENERIC_WRITE (2)
#define OPEN_ALWAYS (3)
#define FILE_ATTRIBUTE_NORMAL (4)

// --- test cases ---

namespace CWE401_Memory_Leak__new_int_17
{
    void bad()
    {
        int i,j;
        int * data;
        data = NULL;
        for(i = 0; i < 1; i++)
        {
            /* POTENTIAL FLAW: Allocate memory on the heap */
            data = new int; // BAD
            /* Initialize and make use of data */
            *data = 5;
            printIntLine(*data);
        }
        for(j = 0; j < 1; j++)
        {
            /* POTENTIAL FLAW: No deallocation */
            ; /* empty statement needed for some flow variants */
        }
    }

    /* goodB2G() - use badsource and goodsink in the for statements */
    static void goodB2G()
    {
        int i,k;
        int * data;
        data = NULL;
        for(i = 0; i < 1; i++)
        {
            /* POTENTIAL FLAW: Allocate memory on the heap */
            data = new int; // GOOD
            /* Initialize and make use of data */
            *data = 5;
            printIntLine(*data);
        }
        for(k = 0; k < 1; k++)
        {
            /* FIX: Deallocate memory */
            delete data;
        }
    }

    /* goodG2B() - use goodsource and badsink in the for statements */
    static void goodG2B()
    {
        int h,j;
        int * data;
        data = NULL;
        for(h = 0; h < 1; h++)
        {
            /* FIX: Use memory allocated on the stack */
            int dataGoodBuffer; // GOOD
            data = &dataGoodBuffer;
            /* Initialize and make use of data */
            *data = 5;
            printIntLine(*data);
        }
        for(j = 0; j < 1; j++)
        {
            /* POTENTIAL FLAW: No deallocation */
            ; /* empty statement needed for some flow variants */
        }
    }
} /* close namespace */

void CWE401_Memory_Leak__char_malloc_32_bad()
{
    char * data;
    char * *dataPtr1 = &data;
    char * *dataPtr2 = &data;
    data = NULL;
    {
        char * data = *dataPtr1;
        /* POTENTIAL FLAW: Allocate memory on the heap */
        data = (char *)malloc(100*sizeof(char)); // BAD
        /* Initialize and make use of data */
        strcpy(data, "A String");
        printLine(data);
        *dataPtr1 = data;
    }
    {
        char * data = *dataPtr2;
        /* POTENTIAL FLAW: No deallocation */
        ; /* empty statement needed for some flow variants */
    }
}

/* goodG2B() uses the GoodSource with the BadSink */
static void CWE401_Memory_Leak__char_malloc_32_goodG2B()
{
    char * data;
    char * *dataPtr1 = &data;
    char * *dataPtr2 = &data;
    data = NULL;
    {
        char * data = *dataPtr1;
        /* FIX: Use memory allocated on the stack with ALLOCA */
        data = (char *)ALLOCA(100*sizeof(char)); // GOOD
        /* Initialize and make use of data */
        strcpy(data, "A String");
        printLine(data);
        *dataPtr1 = data;
    }
    {
        char * data = *dataPtr2;
        /* POTENTIAL FLAW: No deallocation */
        ; /* empty statement needed for some flow variants */
    }
}

/* goodB2G() uses the BadSource with the GoodSink */
static void CWE401_Memory_Leak__char_malloc_32_goodB2G()
{
    char * data;
    char * *dataPtr1 = &data;
    char * *dataPtr2 = &data;
    data = NULL;
    {
        char * data = *dataPtr1;
        /* POTENTIAL FLAW: Allocate memory on the heap */
        data = (char *)malloc(100*sizeof(char)); // GOOD
        /* Initialize and make use of data */
        strcpy(data, "A String");
        printLine(data);
        *dataPtr1 = data;
    }
    {
        char * data = *dataPtr2;
        /* FIX: Deallocate memory */
        free(data);
    }
}

void CWE401_Memory_Leak__malloc_realloc_char_01_bad()
{
    {
        char * data = (char *)malloc(100*sizeof(char)); // BAD
        /* Initialize and make use of data */
        strcpy(data, "A String");
        printLine(data);
        /* FLAW: If realloc() fails, the initial memory block will not be freed() */
        data = (char *)realloc(data, (130000)*sizeof(char));
        if (data != NULL)
        {
            /* Reinitialize and make use of data */
            strcpy(data, "New String");
            printLine(data);
            free(data);
        }
    }
}

void CWE775_Missing_Release_of_File_Descriptor_or_Handle__fopen_no_close_17_bad()
{
    int j;
    FILE * data;
    data = NULL;
    /* POTENTIAL FLAW: Open a file without closing it */
    data = fopen("BadSource_fopen.txt", "w+"); // BAD
    for(j = 0; j < 1; j++)
    {
        /* FLAW: No attempt to close the file */
        ; /* empty statement needed for some flow variants */
    }
}

/* goodB2G() - use the goodsink in the for statement */
static void CWE775_Missing_Release_of_File_Descriptor_or_Handle__fopen_no_close_17_goodB2G()
{
    int k;
    FILE * data;
    data = NULL;
    /* POTENTIAL FLAW: Open a file without closing it */
    data = fopen("BadSource_fopen.txt", "w+"); // GOOD
    for(k = 0; k < 1; k++)
    {
        /* FIX: If the file is still opened, close it */
        if (data != NULL)
        {
            fclose(data);
        }
    }
}

void CWE775_Missing_Release_of_File_Descriptor_or_Handle__open_no_close_01_bad()
{
    int data;
    /* Initialize data */
    data = -1;
    /* POTENTIAL FLAW: Open a file without closing it */
    data = OPEN("BadSource_open.txt", O_RDWR|O_CREAT, S_IREAD|S_IWRITE); // BAD
    /* FLAW: No attempt to close the file */
    ; /* empty statement needed for some flow variants */
}

/* goodB2G() uses the BadSource with the GoodSink */
static void CWE775_Missing_Release_of_File_Descriptor_or_Handle__open_no_close_01_goodB2G()
{
    int data;
    /* Initialize data */
    data = -1;
    /* POTENTIAL FLAW: Open a file without closing it */
    data = OPEN("BadSource_open.txt", O_RDWR|O_CREAT, S_IREAD|S_IWRITE); // GOOD
    /* FIX: If the file is still opened, close it */
    if (data != -1)
    {
        CLOSE(data);
    }
}

void CWE775_Missing_Release_of_File_Descriptor_or_Handle__w32CreateFile_no_close_01_bad()
{
    HANDLE data;
    /* Initialize data */
    data = INVALID_HANDLE_VALUE;
    /* POTENTIAL FLAW: Open a file without closing it */
    data = CreateFile("BadSource_w32CreateFile.txt", // BAD
                      (GENERIC_WRITE|GENERIC_READ),
                      0,
                      NULL,
                      OPEN_ALWAYS,
                      FILE_ATTRIBUTE_NORMAL,
                      NULL);
    /* FLAW: No attempt to close the file */
    ; /* empty statement needed for some flow variants */
}

/* goodB2G() uses the BadSource with the GoodSink */
static void CWE775_Missing_Release_of_File_Descriptor_or_Handle__w32CreateFile_no_close_01_goodB2G()
{
    HANDLE data;
    /* Initialize data */
    data = INVALID_HANDLE_VALUE;
    /* POTENTIAL FLAW: Open a file without closing it */
    data = CreateFile("BadSource_w32CreateFile.txt", // GOOD
                      (GENERIC_WRITE|GENERIC_READ),
                      0,
                      NULL,
                      OPEN_ALWAYS,
                      FILE_ATTRIBUTE_NORMAL,
                      NULL);
    /* FIX: If the file is still opened, close it */
    if (data != INVALID_HANDLE_VALUE)
    {
        CloseHandle(data);
    }
}

void exit(int status);

typedef struct _twoIntsStruct
{
    int intOne;
    int intTwo;
} twoIntsStruct;

void printStructLine(const twoIntsStruct * structTwoIntsStruct);

void CWE401_Memory_Leak__twoIntsStruct_realloc_01_bad()
{
    twoIntsStruct * data;
    data = NULL;
    /* POTENTIAL FLAW: Allocate memory on the heap */
    data = (twoIntsStruct *)realloc(data, 100*sizeof(twoIntsStruct));
    if (data == NULL) {exit(-1);}
    /* Initialize and make use of data */
    data[0].intOne = 0;
    data[0].intTwo = 0;
    printStructLine(&data[0]);
    /* POTENTIAL FLAW: No deallocation */
    ; /* empty statement needed for some flow variants */
}
