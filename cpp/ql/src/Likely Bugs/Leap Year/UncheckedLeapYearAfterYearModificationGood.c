SYSTEMTIME st;
FILETIME ft;
GetSystemTime(&st);

// Flawed logic may result in invalid date
st.wYear++;

// Check for leap year, and adjust the date accordingly
bool isLeapYear = st.wYear % 4 == 0 && (st.wYear % 100 != 0 || st.wYear % 400 == 0);
st.wDay = st.wMonth == 2 && st.wDay == 29 && !isLeapYear ? 28 : st.wDay;

if (!SystemTimeToFileTime(&st, &ft))
{
	// handle error
}
