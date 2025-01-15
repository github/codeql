SYSTEMTIME st;
FILETIME ft;
GetSystemTime(&st);

// Flawed logic may result in invalid date
st.wYear++;

// The following code may fail
SystemTimeToFileTime(&st, &ft);