/**
 * This test case is closely based on CWE23_Relative_Path_Traversal__char_console_fopen_11.cpp
 * from the SAMATE test suite.
 */

#define NULL (0)

typedef size_t time_t;
time_t time(time_t *timer);
void srand(unsigned int seed);

typedef struct {} FILE;
extern FILE *stdin;
FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);
#define FILENAME_MAX (4096)

typedef unsigned long size_t;
size_t strlen(const char *s);
char *strcat(char *s1, const char *s2);
char *fgets(char *s, int n, FILE *stream);

int globalReturnsTrue() 
{
    return 1;
}

int globalReturnsFalse() 
{
    return 0;
}

void printLine(const char *str);

#define BASEPATH "c:\\temp\\"
#define FOPEN fopen

namespace CWE23_Relative_Path_Traversal__char_console_fopen_11
{

void bad()
{
    char * data;
    char dataBuffer[FILENAME_MAX] = BASEPATH;
    data = dataBuffer;
    if(globalReturnsTrue())
    {
        {
            /* Read input from the console */
            size_t dataLen = strlen(data);
            /* if there is room in data, read into it from the console */
            if (FILENAME_MAX-dataLen > 1)
            {
                /* POTENTIAL FLAW: Read data from the console */
                if (fgets(data+dataLen, (int)(FILENAME_MAX-dataLen), stdin) != NULL)
                {
                    /* The next few lines remove the carriage return from the string that is
                     * inserted by fgets() */
                    dataLen = strlen(data);
                    if (dataLen > 0 && data[dataLen-1] == '\n')
                    {
                        data[dataLen-1] = '\0';
                    }
                }
                else
                {
                    printLine("fgets() failed");
                    /* Restore NUL terminator if fgets fails */
                    data[dataLen] = '\0';
                }
            }
        }
    }
    {
        FILE *pFile = NULL;
        /* POTENTIAL FLAW: Possibly opening a file without validating the file name or path */
        pFile = FOPEN(data, "wb+");
        if (pFile != NULL)
        {
            fclose(pFile);
        }
    }
}

/* goodG2B1() - use goodsource and badsink by changing the globalReturnsTrue() to globalReturnsFalse() */
static void goodG2B1()
{
    char * data;
    char dataBuffer[FILENAME_MAX] = BASEPATH;
    data = dataBuffer;
    if(globalReturnsFalse())
    {
        /* INCIDENTAL: CWE 561 Dead Code, the code below will never run */
        printLine("Benign, fixed string");
    }
    else
    {
        /* FIX: Use a fixed file name */
        strcat(data, "file.txt");
    }
    {
        FILE *pFile = NULL;
        /* POTENTIAL FLAW: Possibly opening a file without validating the file name or path */
        pFile = FOPEN(data, "wb+");
        if (pFile != NULL)
        {
            fclose(pFile);
        }
    }
}

/* goodG2B2() - use goodsource and badsink by reversing the blocks in the if statement */
static void goodG2B2()
{
    char * data;
    char dataBuffer[FILENAME_MAX] = BASEPATH;
    data = dataBuffer;
    if(globalReturnsTrue())
    {
        /* FIX: Use a fixed file name */
        strcat(data, "file.txt");
    }
    {
        FILE *pFile = NULL;
        /* POTENTIAL FLAW: Possibly opening a file without validating the file name or path */
        pFile = FOPEN(data, "wb+");
        if (pFile != NULL)
        {
            fclose(pFile);
        }
    }
}

void good()
{
    goodG2B1();
    goodG2B2();
}

} /* close namespace */

/* Below is the main(). It is only used when building this testcase on
   its own for testing or for building a binary to use in testing binary
   analysis tools. It is not used when compiling all the testcases as one
   application, which is how source code analysis tools are tested. */

using namespace CWE23_Relative_Path_Traversal__char_console_fopen_11; /* so that we can use good and bad easily */

int main(int argc, char * argv[])
{
    /* seed randomness */
    srand( (unsigned)time(NULL) );
#ifndef OMITGOOD
    printLine("Calling good()...");
    good();
    printLine("Finished good()");
#endif /* OMITGOOD */
#ifndef OMITBAD
    printLine("Calling bad()...");
    bad();
    printLine("Finished bad()");
#endif /* OMITBAD */
    return 0;
}
