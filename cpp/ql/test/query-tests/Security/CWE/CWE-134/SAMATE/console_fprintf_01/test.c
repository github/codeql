// External test case from SAMATE's Juliet Test Suite for C/C++
// (http://samate.nist.gov/SRD/testsuite.php)
// Associated with CWE-134: Uncontrolled format string. http://cwe.mitre.org/data/definitions/134.html
// Examples amended to have all function declarations inlined.

#define NULL 0
typedef unsigned long size_t;
typedef struct {} FILE;
extern FILE * stdin;
extern FILE * stdout;
size_t strlen(const char *s);
char *fgets(char *s, int n, FILE *stream);
int fprintf(FILE *stream, const char *format, ...);
char *strcpy(char *s1, const char *s2);
void srand(unsigned int seed);

void printLine(char *);

#ifndef OMITBAD

void CWE134_Uncontrolled_Format_String__char_console_fprintf_01_bad()
{
    char * data;
    char data_buf[100] = "";
    data = data_buf;
    {
        /* Read input from the console */
        size_t data_len = strlen(data);
        /* if there is room in data, read into it from the console */
        /* POTENTIAL FLAW: Read data from the console */
        if(100-data_len > 1)
        {
            if (fgets(data+data_len, (int)(100-data_len), stdin) != NULL)
            {
                /* The next 3 lines remove the carriage return from the string that is
                 * inserted by fgets() */
                data_len = strlen(data);
                if (data_len > 0 && data[data_len-1] == '\n')
                {
                    data[data_len-1] = '\0';
                }
            }
            else
            {
                printLine("fgets() failed");
                /* Restore NUL terminator if fgets fails */
                data[data_len] = '\0';
            }
        }
    }
    /* POTENTIAL FLAW: Do not specify the format allowing a possible format string vulnerability */
    fprintf(stdout, data);
}

#endif /* OMITBAD */

#ifndef OMITGOOD

/* goodG2B uses the GoodSource with the BadSink */
static void goodG2B()
{
    char * data;
    char data_buf[100] = "";
    data = data_buf;
    /* FIX: Use a fixed string that does not contain a format specifier */
    strcpy(data, "fixedstringtest");
    /* POTENTIAL FLAW: Do not specify the format allowing a possible format string vulnerability */
    fprintf(stdout, data);
}

/* goodB2G uses the BadSource with the GoodSink */
static void goodB2G()
{
    char * data;
    char data_buf[100] = "";
    data = data_buf;
    {
        /* Read input from the console */
        size_t data_len = strlen(data);
        /* if there is room in data, read into it from the console */
        /* POTENTIAL FLAW: Read data from the console */
        if(100-data_len > 1)
        {
            if (fgets(data+data_len, (int)(100-data_len), stdin) != NULL)
            {
                /* The next 3 lines remove the carriage return from the string that is
                 * inserted by fgets() */
                data_len = strlen(data);
                if (data_len > 0 && data[data_len-1] == '\n')
                {
                    data[data_len-1] = '\0';
                }
            }
            else
            {
                printLine("fgets() failed");
                /* Restore NUL terminator if fgets fails */
                data[data_len] = '\0';
            }
        }
    }
    /* FIX: Specify the format disallowing a format string vulnerability */
    fprintf(stdout, "%s\n", data);
}

void CWE134_Uncontrolled_Format_String__char_console_fprintf_01_good()
{
    goodG2B();
    goodB2G();
}

#endif /* OMITGOOD */

/* Below is the main(). It is only used when building this testcase on
   its own for testing or for building a binary to use in testing binary
   analysis tools. It is not used when compiling all the testcases as one
   application, which is how source code analysis tools are tested. */

#ifdef INCLUDEMAIN

int main(int argc, char * argv[])
{
    /* seed randomness */
    srand( (unsigned)time(NULL) );
#ifndef OMITGOOD
    printLine("Calling good()...");
    CWE134_Uncontrolled_Format_String__char_console_fprintf_01_good();
    printLine("Finished good()");
#endif /* OMITGOOD */
#ifndef OMITBAD
    printLine("Calling bad()...");
    CWE134_Uncontrolled_Format_String__char_console_fprintf_01_bad();
    printLine("Finished bad()");
#endif /* OMITBAD */
    return 0;
}

#endif
