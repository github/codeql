// Some SAMATE Juliet test cases for CWE-114.

typedef unsigned long size_t;
typedef unsigned int BOOL;
typedef const char *LPCSTR;
typedef void *HMODULE;
#define NULL (0)

size_t strlen(const char *s);
char *strncat(char *s1, const char *s2, size_t n);

HMODULE LoadLibraryA(LPCSTR libname);
BOOL FreeLibrary(HMODULE hModule);

char *getenv(const char *name);

#define GETENV getenv
#define ENV_VARIABLE "ADD"

void printLine(const char *msg);

// --- CWE114_Process_Control__w32_char_environment_82 ---

class CWE114_Process_Control__w32_char_environment_82_base
{
public:
    /* pure virtual function */
    virtual void action(char * data) = 0;
};

class CWE114_Process_Control__w32_char_environment_82_bad : public CWE114_Process_Control__w32_char_environment_82_base
{
public:
    void action(char * data);
};

void CWE114_Process_Control__w32_char_environment_82_bad::action(char * data)
{
    {
        HMODULE hModule;
        /* POTENTIAL FLAW: If the path to the library is not specified, an attacker may be able to
         * replace his own file with the intended library */
        hModule = LoadLibraryA(data);
        if (hModule != NULL)
        {
            FreeLibrary(hModule);
            printLine("Library loaded and freed successfully");
        }
        else
        {
            printLine("Unable to load library");
        }
    }
}

void bad()
{
    char * data;
    char dataBuffer[100] = "";
    data = dataBuffer;
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
    CWE114_Process_Control__w32_char_environment_82_base* baseObject = new CWE114_Process_Control__w32_char_environment_82_bad;
    baseObject->action(data);
    delete baseObject;
}

// --- CWE114_Process_Control__w32_char_console_33 ---

typedef struct {} FILE;
char *fgets(char *s, int n, FILE *stream);
FILE *stdin;

void CWE114_Process_Control__w32_char_console_33_bad()
{
    char * data;
    char * &dataRef = data;
    char dataBuffer[100] = "";
    data = dataBuffer;
    {
        /* Read input from the console */
        size_t dataLen = strlen(data);
        /* if there is room in data, read into it from the console */
        if (100-dataLen > 1)
        {
            /* POTENTIAL FLAW: Read data from the console [NOT DETECTED] */
            if (fgets(data+dataLen, (int)(100-dataLen), stdin) != NULL)
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
    {
        char * data = dataRef;
        {
            HMODULE hModule;
            /* POTENTIAL FLAW: If the path to the library is not specified, an attacker may be able to
             * replace his own file with the intended library */
            hModule = LoadLibraryA(data);
            if (hModule != NULL)
            {
                FreeLibrary(hModule);
                printLine("Library loaded and freed successfully");
            }
            else
            {
                printLine("Unable to load library");
            }
        }
    }
}
