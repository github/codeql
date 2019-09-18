// semmle-extractor-options: --microsoft
#define NULL 0
#define FALSE 0
#define LOGON_WITH_PROFILE 0x00000001

int
CreateProcessA(
    const char* lpApplicationName,
    char* lpCommandLine,
    void* lpProcessAttributes,
    void* lpThreadAttributes,
    int bInheritHandles,
    unsigned long dwCreationFlags,
    void* lpEnvironment,
    const char* lpCurrentDirectory,
    void* lpStartupInfo,
    void* lpProcessInformation
);

int
CreateProcessW(
    const wchar_t* lpApplicationName,
    wchar_t* lpCommandLine,
    void* lpProcessAttributes,
    void* lpThreadAttributes,
    int bInheritHandles,
    unsigned long dwCreationFlags,
    void* lpEnvironment,
    const wchar_t* lpCurrentDirectory,
    void* lpStartupInfo,
    void* lpProcessInformation
);

#define CreateProcess  CreateProcessW

int
CreateProcessWithTokenW(
    void* hToken,
    unsigned long dwLogonFlags,
    const wchar_t* lpApplicationName,
    wchar_t* lpCommandLine,
    unsigned long dwCreationFlags,
    void* lpEnvironment,
    const wchar_t* lpCurrentDirectory,
    void* lpStartupInfo,
    void* lpProcessInformation
);

int
CreateProcessWithLogonW(
    const wchar_t* lpUsername,
    const wchar_t* lpDomain,
    const wchar_t* lpPassword,
    unsigned long dwLogonFlags,
    const wchar_t* lpApplicationName,
    wchar_t* lpCommandLine,
    unsigned long dwCreationFlags,
    void* lpEnvironment,
    const wchar_t* lpCurrentDirectory,
    void* lpStartupInfo,
    void* lpProcessInformation
);

int
CreateProcessAsUserA(
    void* hToken,
    const char* lpApplicationName,
    char* lpCommandLine,
    void* lpProcessAttributes,
    void* lpThreadAttributes,
    int bInheritHandles,
    unsigned long dwCreationFlags,
    void* lpEnvironment,
    const char* lpCurrentDirectory,
    void* lpStartupInfo,
    void* lpProcessInformation
);

int
CreateProcessAsUserW(
    void* hToken,
    const wchar_t* lpApplicationName,
    wchar_t* lpCommandLine,
    void* lpProcessAttributes,
    void* lpThreadAttributes,
    int bInheritHandles,
    unsigned long dwCreationFlags,
    void* lpEnvironment,
    const wchar_t* lpCurrentDirectory,
    void* lpStartupInfo,
    void* lpProcessInformation
);

#define CreateProcessAsUser  CreateProcessAsUserW

void positiveTestCases()
{
    const wchar_t* lpCommandLine = (const wchar_t*)L"C:\\Program Files\\MyApp";
    void* h = 0;
    wchar_t* lpApplicationName = NULL;

    // CreatePorcessA
    CreateProcessA(                             //BUG
        NULL,
        (char*)"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcessW
    CreateProcessW(                             //BUG
        NULL,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
    
    // CreatePorcess
    CreateProcess(                              //BUG
        NULL,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // lpCommandLine as hardcoded variable
    CreateProcess(                              //BUG
        NULL,
        (wchar_t*)lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessWithTokenW
    CreateProcessWithTokenW(                    //BUG
        h,
        LOGON_WITH_PROFILE,
        NULL,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessWithLogonW
    CreateProcessWithLogonW(                    //BUG
        (const wchar_t*)L"UserName",
        (const wchar_t*)L"CONTOSO",
        (const wchar_t*)L"<fake_password!>",
        LOGON_WITH_PROFILE,
        NULL,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserA
    CreateProcessAsUserA(                        //BUG
        h,
        NULL,
        (char*)"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserW
    CreateProcessAsUserW(                        //BUG
        h,
        NULL,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUser
    CreateProcessAsUser(                        //BUG
        h,
        NULL,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess with a hardcoded variable for application Name (NULL)
    // Variation: tab instead of space
    CreateProcess(                              //BUG
        lpApplicationName,
        (wchar_t*)L"C:\\Program\tFiles\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
}

void PositiveTestCasesWithCmdLineParameter(wchar_t* lpCommandLine)
{
    // lpCommandLine as variable
    CreateProcess(                              //BUG - Depends on the caller
        NULL,
        lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
}

void PositiveTestCasesWithCmdLineParameter_caller()
{
    PositiveTestCasesWithCmdLineParameter((wchar_t*)L"C:\\Program Files\\MyApp");
}

// NOTE: This function will not be flagged as having a bug by this rule.
//       but as it is, the function can still be misused
void FalseNegativeTestCasesWithCmdLineParameter(wchar_t* lpCommandLine)
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
    FalseNegativeTestCasesWithCmdLineParameter((wchar_t*)L"\"C:\\Program Files\\MyApp\"");  
}

void PositiveTestCasesWithAppNameParameter(wchar_t* lpApplicationName)
{
    void* h = 0;

    CreateProcessWithTokenW(                    //BUG - Depends on the caller. In this case the caller sends NULL
        h,
        LOGON_WITH_PROFILE,
        lpApplicationName,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);
}

void PositiveTestCasesWithAppNameParameter_caller()
{
    PositiveTestCasesWithAppNameParameter(NULL);
}

// NOTE: This function will not be flagged as having a bug by this rule.
//       but as it is, the function can still be misused
void FalseNegativeTestCasesWithAppNameParameter(wchar_t* lpApplicationName)
{
    void* h = 0;

    CreateProcessWithTokenW(                    // Depends on the caller. In this case the caller sends an ApplicatioName
        h,
        LOGON_WITH_PROFILE,
        lpApplicationName,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);
}

void FalseNegativeTestCasesWithAppNameParameter_caller()
{
    // No bug - escaped command line
    // But compare with "PositiveTestCasesWithAppNameParameter"
    FalseNegativeTestCasesWithAppNameParameter((wchar_t*)L"MyApp.exe");
}

int MayReturnFalse()
{
    // return ((rand() % 2) == 0);
    return true;
}

void TestCaseProbablyBug()
{
    const wchar_t* lpApplicationName = NULL;

    if (!MayReturnFalse())
    {
        lpApplicationName = (const wchar_t*)L"app.exe";
    }

    CreateProcessWithLogonW(                    // BUG (Probably - depends on a condition that may be false)
        (const wchar_t*)L"UserName",
        (const wchar_t*)L"CONTOSO",
        (const wchar_t*)L"<fake_password!>",
        LOGON_WITH_PROFILE,
        (wchar_t*)lpApplicationName,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    if (lpApplicationName)
    {
        delete[] lpApplicationName;
    }
}

void negativeTestCases_quotedCommandLine()
{
    const wchar_t* lpCommandLine = (const wchar_t*)L"\"C:\\Program Files\\MyApp\" with additional params";
    void* h = 0;
    wchar_t* lpApplicationName = NULL;

    // CreatePorcessA
    CreateProcessA(
        NULL,
        (char*)"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcessW
    CreateProcessW(
        NULL,
        (wchar_t*)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess
    CreateProcess( 
        NULL,
        (wchar_t*)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // lpCommandLine as hardcoded variable
    CreateProcess( 
        NULL,
        (wchar_t*)lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessWithTokenW
    CreateProcessWithTokenW(
        h,
        LOGON_WITH_PROFILE,
        NULL,
        (wchar_t*)L"\"C:\\Program Files\\MyApp\"",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessWithLogonW
    CreateProcessWithLogonW(
        (const wchar_t*)L"UserName",
        (const wchar_t*)L"CONTOSO",
        (const wchar_t*)L"<fake_password!>",
        LOGON_WITH_PROFILE,
        NULL,
        (wchar_t*)L"\"C:\\Program Files\\MyApp\"",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserA
    CreateProcessAsUserA(
        h,
        NULL,
        (char*)"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserW
    CreateProcessAsUserW(
        h,
        NULL,
        (wchar_t*)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUser
    CreateProcessAsUser(
        h,
        NULL,
        (wchar_t*)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess with a hardcoded variable for application Name (NULL)
    CreateProcess( 
        lpApplicationName,
        (wchar_t*)L"\"C:\\Program Files\\MyApp\"",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // Null AppName, but lpComamndLine has no spaces/tabs
    CreateProcessA(
        NULL,
        (char*)"C:\\MyFolder\\MyApp.exe",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

}

void negativeTestCases_AppNameSet()
{
    const wchar_t* lpCommandLine = (const wchar_t*)L"C:\\Program Files\\MyApp";
    void* h = 0;
    const wchar_t* lpApplicationName = (const wchar_t*)L"MyApp.exe";

    // CreatePorcessA
    CreateProcessA(
        (char*)"MyApp.exe",
        (char*)"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcessW
    CreateProcessW(
        (wchar_t*)L"MyApp.exe",
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess
    CreateProcess(
        (wchar_t*)L"MyApp.exe",
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // lpCommandLine as hardcoded variable
    CreateProcess(
        (wchar_t*)L"MyApp.exe",
        (wchar_t*)lpCommandLine,
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessWithTokenW
    CreateProcessWithTokenW(
        h,
        LOGON_WITH_PROFILE,
        (wchar_t*)L"MyApp.exe",
        (wchar_t*)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessWithLogonW
    CreateProcessWithLogonW(
        (const wchar_t*)L"UserName",
        (const wchar_t*)L"CONTOSO",
        (const wchar_t*)L"<fake_password!>",
        LOGON_WITH_PROFILE,
        (wchar_t*)L"MyApp.exe",
        (wchar_t*)L"C:\\Program Files\\MyApp",
        0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserA
    CreateProcessAsUserA(
        h,
        (char*)"MyApp.exe",
        (char*)"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUserW
    CreateProcessAsUserW(
        h,
        (wchar_t*)L"MyApp.exe",
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreateProcessAsUser
    CreateProcessAsUser(
        h,
        (wchar_t*)L"MyApp.exe",
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);

    // CreatePorcess with a hardcoded variable for application Name (NULL)
    CreateProcess(
        (wchar_t*)lpApplicationName,
        (wchar_t*)L"C:\\Program Files\\MyApp",
        NULL, NULL, FALSE, 0, NULL, NULL, NULL, NULL);
}
