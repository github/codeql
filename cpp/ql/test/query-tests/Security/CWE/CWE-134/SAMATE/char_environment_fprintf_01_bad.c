// External test case from SAMATE's Juliet Test Suite for C/C++
// (http://samate.nist.gov/SRD/testsuite.php)
// Associated with CWE-134: Uncontrolled format string. http://cwe.mitre.org/data/definitions/134.html
// Examples amended to have all function declarations inlined.

#define NULL 0
typedef struct {} FILE;
typedef unsigned long size_t;
extern FILE * stdout;
size_t strlen(const char *s);
char *getenv(const char *name);
char *strcpy(char *s1, const char *s2);
char *strncat(char *s1, const char *s2, size_t n);
int fprintf(FILE *stream, const char *format, ...);

#define ENV_VARIABLE "ADD"
#define GETENV getenv

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
