//semmle-extractor-options: --edg --target --edg win64

// A selection of tests from the SAMATE Juliet framework for rule CWE-78.

// library types, functions etc
#define NULL (0)
typedef unsigned long size_t;
size_t strlen(const char *s);
char *strncat(char *s1, const char *s2, size_t n);
char *getenv(const char *name);
int system(const char *string);
void exit(int status);

#define FULL_COMMAND "dir "
#define ENV_VARIABLE "ADD"
#define GETENV getenv
#define SYSTEM system

void printLine(const char *str);

// ----------

/* The static variable below is used to drive control flow in the source function */
static int badStatic = 0;

static char * badSource(char * data)
{
    if(badStatic)
    {
        {
            /* Append input from an environment variable to data */
            size_t dataLen = strlen(data);
            char * environment = GETENV(ENV_VARIABLE);
            /* If there is data in the environment variable */
            if (environment != NULL)
            {
                /* POTENTIAL FLAW: Read data from an environment variable */
                strncat(data+dataLen, environment, 100-dataLen-1);
            }
        }
    }
    return data;
}

void CWE78_OS_Command_Injection__char_environment_system_21_bad()
{
    char * data;
    char data_buf[100] = FULL_COMMAND;
    data = data_buf;
    badStatic = 1; /* true */
    data = badSource(data);
    /* POTENTIAL FLAW: Execute command in data possibly leading to command injection [NOT DETECTED] */
    if (SYSTEM(data) != 0)
    {
        printLine("command execution failed!");
        exit(1);
    }
}
