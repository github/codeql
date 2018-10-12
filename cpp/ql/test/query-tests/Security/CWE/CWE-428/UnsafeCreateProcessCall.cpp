// semmle-extractor-options: --microsoft
#define NULL 0
#define FALSE 0
#define far
#define LOGON_WITH_PROFILE 0x00000001

typedef char CHAR;
typedef unsigned short WCHAR;
typedef int BOOL;
#define CONST const
typedef CHAR *PCHAR, *LPCH, *PCH;
typedef CONST CHAR *LPCCH, *PCCH;
typedef CHAR *NPSTR, *LPSTR, *PSTR;
typedef CONST PSTR *PCZPSTR;
typedef CONST CHAR *LPCSTR, *PCSTR;
typedef WCHAR *PWCHAR, *LPWCH, *PWCH;
typedef CONST WCHAR *LPCWCH, *PCWCH;
typedef WCHAR *NWPSTR, *LPWSTR, *PWSTR;
typedef PWSTR *PZPWSTR;
typedef CONST PWSTR *PCZPWSTR;
typedef CONST WCHAR *LPCWSTR, *PCWSTR;
typedef unsigned long DWORD;
typedef void far *LPVOID;
typedef unsigned short WORD;
typedef unsigned char BYTE;
typedef BYTE far *LPBYTE;
typedef void *HANDLE;

typedef struct _SECURITY_ATTRIBUTES {
    DWORD nLength;
    LPVOID lpSecurityDescriptor;
    BOOL bInheritHandle;
} SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

typedef struct _PROCESS_INFORMATION {
    HANDLE hProcess;
    HANDLE hThread;
    DWORD dwProcessId;
    DWORD dwThreadId;
} PROCESS_INFORMATION, *PPROCESS_INFORMATION, *LPPROCESS_INFORMATION;

typedef struct _STARTUPINFOA {
    DWORD   cb;
    LPSTR   lpReserved;
    LPSTR   lpDesktop;
    LPSTR   lpTitle;
    DWORD   dwX;
    DWORD   dwY;
    DWORD   dwXSize;
    DWORD   dwYSize;
    DWORD   dwXCountChars;
    DWORD   dwYCountChars;
    DWORD   dwFillAttribute;
    DWORD   dwFlags;
    WORD    wShowWindow;
    WORD    cbReserved2;
    LPBYTE  lpReserved2;
    HANDLE  hStdInput;
    HANDLE  hStdOutput;
    HANDLE  hStdError;
} STARTUPINFOA, *LPSTARTUPINFOA;
typedef struct _STARTUPINFOW {
    DWORD   cb;
    LPWSTR  lpReserved;
    LPWSTR  lpDesktop;
    LPWSTR  lpTitle;
    DWORD   dwX;
    DWORD   dwY;
    DWORD   dwXSize;
    DWORD   dwYSize;
    DWORD   dwXCountChars;
    DWORD   dwYCountChars;
    DWORD   dwFillAttribute;
    DWORD   dwFlags;
    WORD    wShowWindow;
    WORD    cbReserved2;
    LPBYTE  lpReserved2;
    HANDLE  hStdInput;
    HANDLE  hStdOutput;
    HANDLE  hStdError;
} STARTUPINFOW, *LPSTARTUPINFOW;

typedef STARTUPINFOW STARTUPINFO;
typedef LPSTARTUPINFOW LPSTARTUPINFO;


BOOL
CreateProcessA(
    LPCSTR lpApplicationName,
    LPSTR lpCommandLine,
    LPSECURITY_ATTRIBUTES lpProcessAttributes,
    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    BOOL bInheritHandles,
    DWORD dwCreationFlags,
    LPVOID lpEnvironment,
    LPCSTR lpCurrentDirectory,
    LPSTARTUPINFOA lpStartupInfo,
    LPPROCESS_INFORMATION lpProcessInformation
);

BOOL
CreateProcessW(
    LPCWSTR lpApplicationName,
    LPWSTR lpCommandLine,
    LPSECURITY_ATTRIBUTES lpProcessAttributes,
    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    BOOL bInheritHandles,
    DWORD dwCreationFlags,
    LPVOID lpEnvironment,
    LPCWSTR lpCurrentDirectory,
    LPSTARTUPINFOW lpStartupInfo,
    LPPROCESS_INFORMATION lpProcessInformation
);

#define CreateProcess  CreateProcessW

BOOL
CreateProcessWithTokenW(
    HANDLE hToken,
    DWORD dwLogonFlags,
    LPCWSTR lpApplicationName,
    LPWSTR lpCommandLine,
    DWORD dwCreationFlags,
    LPVOID lpEnvironment,
    LPCWSTR lpCurrentDirectory,
    LPSTARTUPINFOW lpStartupInfo,
    LPPROCESS_INFORMATION lpProcessInformation
);

BOOL
CreateProcessWithLogonW(
    LPCWSTR lpUsername,
    LPCWSTR lpDomain,
    LPCWSTR lpPassword,
    DWORD dwLogonFlags,
    LPCWSTR lpApplicationName,
    LPWSTR lpCommandLine,
    DWORD dwCreationFlags,
    LPVOID lpEnvironment,
    LPCWSTR lpCurrentDirectory,
    LPSTARTUPINFOW lpStartupInfo,
    LPPROCESS_INFORMATION lpProcessInformation
);

BOOL
CreateProcessAsUserA(
    HANDLE hToken,
    LPCSTR lpApplicationName,
    LPSTR lpCommandLine,
    LPSECURITY_ATTRIBUTES lpProcessAttributes,
    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    BOOL bInheritHandles,
    DWORD dwCreationFlags,
    LPVOID lpEnvironment,
    LPCSTR lpCurrentDirectory,
    LPSTARTUPINFOA lpStartupInfo,
    LPPROCESS_INFORMATION lpProcessInformation
);

BOOL
CreateProcessAsUserW(
    HANDLE hToken,
    LPCWSTR lpApplicationName,
    LPWSTR lpCommandLine,
    LPSECURITY_ATTRIBUTES lpProcessAttributes,
    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    BOOL bInheritHandles,
    DWORD dwCreationFlags,
    LPVOID lpEnvironment,
    LPCWSTR lpCurrentDirectory,
    LPSTARTUPINFOW lpStartupInfo,
    LPPROCESS_INFORMATION lpProcessInformation
);

#define CreateProcessAsUser  CreateProcessAsUserW

void positiveTestCases()
{
    LPCWSTR lpCommandLine = (LPCWSTR)L"C:\\Program Files\\MyApp";
    HANDLE h = 0;
    LPWSTR lpApplicationName = NULL;

    // CreatePorcessA
    CreateProcessA(                             //BUG
        NULL,
        (LPSTR)"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcessW
    CreateProcessW(                             //BUG
        NULL,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
    
    // CreatePorcess
    CreateProcess(                              //BUG
        NULL,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // lpCommandLine as hardcoded variable
    CreateProcess(                              //BUG
        NULL,
        (LPWSTR)lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessWithTokenW
    CreateProcessWithTokenW(                    //BUG
        h,
        LOGON_WITH_PROFILE,
        NULL,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessWithLogonW
    CreateProcessWithLogonW(                    //BUG
        (LPCWSTR)L"UserName",
        (LPCWSTR)L"CONTOSO",
        (LPCWSTR)L"<fake_password!>",
        LOGON_WITH_PROFILE,
        NULL,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserA
    CreateProcessAsUserA(                        //BUG
        h,
        NULL,
        (LPSTR)"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserW
    CreateProcessAsUserW(                        //BUG
        h,
        NULL,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUser
    CreateProcessAsUser(                        //BUG
        h,
        NULL,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess with a hardcoded variable for application Name (NULL)
    CreateProcess(                              //BUG
        lpApplicationName,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
}

void PositiveTestCasesWithCmdLineParameter(LPWSTR lpCommandLine)
{
    // lpCommandLine as variable
    CreateProcess(                              //BUG - Depends on the caller
        NULL,
        lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
}

void PositiveTestCasesWithCmdLineParameter_caller()
{
    PositiveTestCasesWithCmdLineParameter((LPWSTR)L"C:\\Program Files\\MyApp");
}

// NOTE: This function will not be flagged as having a bug by this rule.
//       but as it is, the function can still be misused
void FalseNegativeTestCasesWithCmdLineParameter(LPWSTR lpCommandLine)
{
    // lpCommandLine as variable
    CreateProcess(                              //Depends on the caller, this time the caller will quote
        NULL,
        lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
}

void FalseNegativeTestCasesWithCmdLineParameter_caller()
{
    // No bug - escaped command line
    // But compare with "PositiveTestCasesWithCmdLineParameter"
    FalseNegativeTestCasesWithCmdLineParameter((LPWSTR)L"\"C:\\Program Files\\MyApp\"");  
}

void PositiveTestCasesWithAppNameParameter(LPWSTR lpApplicationName)
{
    HANDLE h = 0;

    CreateProcessWithTokenW(                    //BUG - Depends on the caller. In this case the caller sends NULL
        h,
        LOGON_WITH_PROFILE,
        lpApplicationName,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);
}

void PositiveTestCasesWithAppNameParameter_caller()
{
    PositiveTestCasesWithAppNameParameter(NULL);
}

// NOTE: This function will not be flagged as having a bug by this rule.
//       but as it is, the function can still be misused
void FalseNegativeTestCasesWithAppNameParameter(LPWSTR lpApplicationName)
{
    HANDLE h = 0;

    CreateProcessWithTokenW(                    // Depends on the caller. In this case the caller sends an ApplicatioName
        h,
        LOGON_WITH_PROFILE,
        lpApplicationName,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);
}

void FalseNegativeTestCasesWithAppNameParameter_caller()
{
    // No bug - escaped command line
    // But compare with "PositiveTestCasesWithAppNameParameter"
    FalseNegativeTestCasesWithAppNameParameter((LPWSTR)L"MyApp.exe");
}

bool MayReturnFalse()
{
    // return ((rand() % 2) == 0);
    return true;
}

void TestCaseProbablyBug()
{
    LPCWSTR lpApplicationName = NULL;

    if (!MayReturnFalse())
    {
        lpApplicationName = (LPCWSTR)L"app.exe";
    }

    CreateProcessWithLogonW(                    // BUG (Probably - depends on a condition that may be false)
        (LPCWSTR)L"UserName",
        (LPCWSTR)L"CONTOSO",
        (LPCWSTR)L"<fake_password!>",
        LOGON_WITH_PROFILE,
        (LPWSTR)lpApplicationName,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    if (lpApplicationName)
    {
        delete[] lpApplicationName;
    }
}

void negativeTestCases_quotedCommandLine()
{
    LPCWSTR lpCommandLine = (LPCWSTR)L"\"C:\\Program Files\\MyApp\" with additional params";
    HANDLE h = 0;
    LPWSTR lpApplicationName = NULL;

    // CreatePorcessA
    CreateProcessA(
        NULL,
        (LPSTR)"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcessW
    CreateProcessW(
        NULL,
        (LPWSTR)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess
    CreateProcess( 
        NULL,
        (LPWSTR)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // lpCommandLine as hardcoded variable
    CreateProcess( 
        NULL,
        (LPWSTR)lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessWithTokenW
    CreateProcessWithTokenW(
        h,
        LOGON_WITH_PROFILE,
        NULL,
        (LPWSTR)L"\"C:\\Program Files\\MyApp\"",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessWithLogonW
    CreateProcessWithLogonW(
        (LPCWSTR)L"UserName",
        (LPCWSTR)L"CONTOSO",
        (LPCWSTR)L"<fake_password!>",
        LOGON_WITH_PROFILE,
        NULL,
        (LPWSTR)L"\"C:\\Program Files\\MyApp\"",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserA
    CreateProcessAsUserA(
        h,
        NULL,
        (LPSTR)"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserW
    CreateProcessAsUserW(
        h,
        NULL,
        (LPWSTR)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUser
    CreateProcessAsUser(
        h,
        NULL,
        (LPWSTR)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess with a hardcoded variable for application Name (NULL)
    CreateProcess( 
        lpApplicationName,
        (LPWSTR)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
}

void negativeTestCases_AppNameSet()
{
    LPCWSTR lpCommandLine = (LPCWSTR)L"C:\\Program Files\\MyApp";
    HANDLE h = 0;
    LPCWSTR lpApplicationName = (LPCWSTR)L"MyApp.exe";

    // CreatePorcessA
    CreateProcessA(
        (LPSTR)"MyApp.exe",
        (LPSTR)"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcessW
    CreateProcessW(
        (LPWSTR)L"MyApp.exe",
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess
    CreateProcess(
        (LPWSTR)L"MyApp.exe",
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // lpCommandLine as hardcoded variable
    CreateProcess(
        (LPWSTR)L"MyApp.exe",
        (LPWSTR)lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessWithTokenW
    CreateProcessWithTokenW(
        h,
        LOGON_WITH_PROFILE,
        (LPWSTR)L"MyApp.exe",
        (LPWSTR)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessWithLogonW
    CreateProcessWithLogonW(
        (LPCWSTR)L"UserName",
        (LPCWSTR)L"CONTOSO",
        (LPCWSTR)L"<fake_password!>",
        LOGON_WITH_PROFILE,
        (LPWSTR)L"MyApp.exe",
        (LPWSTR)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserA
    CreateProcessAsUserA(
        h,
        (LPSTR)"MyApp.exe",
        (LPSTR)"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserW
    CreateProcessAsUserW(
        h,
        (LPWSTR)L"MyApp.exe",
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUser
    CreateProcessAsUser(
        h,
        (LPWSTR)L"MyApp.exe",
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess with a hardcoded variable for application Name (NULL)
    CreateProcess(
        (LPWSTR)lpApplicationName,
        (LPWSTR)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
}
