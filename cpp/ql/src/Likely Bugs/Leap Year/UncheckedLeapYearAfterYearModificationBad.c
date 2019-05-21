SYSTEMTIME st;
FILETIME ft;
GetSystemTime(&st);

// Flawed logic will result in invalid date
st.wYear++;

// The following code may fail
SystemTimeToFileTime(&st, &ft);