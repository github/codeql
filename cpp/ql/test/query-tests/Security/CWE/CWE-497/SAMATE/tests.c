// SAMATE Juliet test cases for rule CWE-497.

// library functions etc
typedef struct {} FILE;

// define stdout, stderr in a similar style to MinGW
FILE std_files[2];
#define stdin (&std_files[0])
#define stderr (&std_files[1])

typedef unsigned long size_t;
size_t strlen(const char *s);
int printf(const char *format, ...);
int fprintf(FILE *stream, const char *format, ...);
char *fgets(char *s, int n, FILE *stream);

typedef struct {} *HANDLE;
int LogonUserA(const char *lpszUserName, const char *lpszDomain, const char *lpszPassword, int dwLogonType, int dwLogonProvider, HANDLE *phToken);
void CloseHandle(HANDLE h);

#define NULL (0)
#define LOGON32_LOGON_NETWORK (1)
#define LOGON32_PROVIDER_DEFAULT (2)

void printLine(const char * line)
{
    if(line != NULL) 
    {
        printf("%s\n", line);
    }
}

void CWE535_Info_Exposure_Shell_Error__w32_char_01_bad()
{
    {
        char password[100] = "";
        size_t passwordLen = 0;
        HANDLE pHandle;
        char * username = "User";
        char * domain = "Domain";
        if (fgets(password, 100, stdin) == NULL)
        {
            printLine("fgets() failed");
            /* Restore NUL terminator if fgets fails */
            password[0] = '\0';
        }
        /* Remove the carriage return from the string that is inserted by fgets() */
        passwordLen = strlen(password);
        if (passwordLen > 0)
        {
            password[passwordLen-1] = '\0';
        }
        /* Use the password in LogonUser() to establish that it is "sensitive" */
        if (LogonUserA(
                    username,
                    domain,
                    password,
                    LOGON32_LOGON_NETWORK,
                    LOGON32_PROVIDER_DEFAULT,
                    &pHandle) != 0)
        {
            printLine("User logged in successfully.");
            CloseHandle(pHandle);
        }
        else
        {
            printLine("Unable to login.");
        }
        /* FLAW: Write sensitive data to stderr */
        fprintf(stderr, "User attempted access with password: %s\n", password);
    }
}
