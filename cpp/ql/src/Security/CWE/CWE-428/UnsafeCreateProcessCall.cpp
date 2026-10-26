STARTUPINFOW si;
PROCESS_INFORMATION pi;

// ... 

CreateProcessW(                           // BUG
    NULL,                                 // lpApplicationName
    (LPWSTR)L"C:\\Program Files\\MyApp",  // lpCommandLine
    NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);

// ...