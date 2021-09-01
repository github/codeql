// External test case from SAMATE's Juliet Test Suite for C/C++
// (http://samate.nist.gov/SRD/testsuite.php)
// Associated with CWE-134: Uncontrolled format string. http://cwe.mitre.org/data/definitions/134.html
// Examples amended to have all function declarations inlined.

/* TEMPLATE GENERATED TESTCASE FILE
Filename: CWE134_Uncontrolled_Format_String__char_environment_fprintf_01.c
Label Definition File: CWE134_Uncontrolled_Format_String.label.xml
Template File: sources-sinks-01.tmpl.c
*/
/*
 * @description
 * CWE: 134 Uncontrolled Format String
 * BadSource: environment Read input from an environment variable
 * GoodSource: Copy a fixed string into data
 * Sinks: fprintf
 *    GoodSink: fprintf with "%s" as the second argument and data as the third
 *    BadSink : fprintf with data as the second argument
 * Flow Variant: 01 Baseline
 *
 * */

// Replaced with inlined functions
//#include "std_testcase.h"
//
//#ifndef _WIN32
//# include <wchar.h>
//#endif
#define NULL 0
typedef struct {} FILE;
typedef unsigned long size_t;
extern FILE * stdout;
void srand(unsigned int seed);
size_t strlen(const char *s);
char *getenv(const char *name);
char *strcpy(char *s1, const char *s2);
char *strncat(char *s1, const char *s2, size_t n);
int fprintf(FILE *stream, const char *format, ...);

void printLine(char *);

#define ENV_VARIABLE "ADD"
#define GETENV getenv

#ifndef OMITBAD

void CWE134_Uncontrolled_Format_String__char_environment_fprintf_01_bad()
{
    char * data;
    char data_buf[100] = "";
    data = data_buf;
    {
        /* Append input from an environment variable to data */
        size_t data_len = strlen(data);
        char * environment = GETENV(ENV_VARIABLE);
        /* If there is data in the environment variable */
        if (environment != NULL)
        {
            /* POTENTIAL FLAW: Read data from an environment variable */
            strncat(data+data_len, environment, 100-data_len-1);
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
        /* Append input from an environment variable to data */
        size_t data_len = strlen(data);
        char * environment = GETENV(ENV_VARIABLE);
        /* If there is data in the environment variable */
        if (environment != NULL)
        {
            /* POTENTIAL FLAW: Read data from an environment variable */
            strncat(data+data_len, environment, 100-data_len-1);
        }
    }
    /* FIX: Specify the format disallowing a format string vulnerability */
    fprintf(stdout, "%s\n", data);
}

void CWE134_Uncontrolled_Format_String__char_environment_fprintf_01_good()
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
    CWE134_Uncontrolled_Format_String__char_environment_fprintf_01_good();
    printLine("Finished good()");
#endif /* OMITGOOD */
#ifndef OMITBAD
    printLine("Calling bad()...");
    CWE134_Uncontrolled_Format_String__char_environment_fprintf_01_bad();
    printLine("Finished bad()");
#endif /* OMITBAD */
    return 0;
}

#endif
