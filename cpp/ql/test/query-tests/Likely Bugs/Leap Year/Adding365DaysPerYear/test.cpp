typedef unsigned short      WORD;
typedef unsigned long       DWORD, HANDLE;
typedef int					BOOL, BOOLEAN, errno_t;
typedef char CHAR;
typedef short SHORT;
typedef long LONG;
typedef unsigned short WCHAR;    // wc,   16-bit UNICODE character
typedef long    __time64_t, time_t;
#define NULL 0

typedef long long LONGLONG;
typedef unsigned long long ULONGLONG;


typedef struct _SYSTEMTIME {
	WORD wYear;
	WORD wMonth;
	WORD wDayOfWeek;
	WORD wDay;
	WORD wHour;
	WORD wMinute;
	WORD wSecond;
	WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;

typedef struct _FILETIME {
	DWORD dwLowDateTime;
	DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;

typedef struct _TIME_ZONE_INFORMATION {
	LONG Bias;
	WCHAR StandardName[32];
	SYSTEMTIME StandardDate;
	LONG StandardBias;
	WCHAR DaylightName[32];
	SYSTEMTIME DaylightDate;
	LONG DaylightBias;
} TIME_ZONE_INFORMATION, *PTIME_ZONE_INFORMATION, *LPTIME_ZONE_INFORMATION;

typedef struct _TIME_DYNAMIC_ZONE_INFORMATION {
	LONG Bias;
	WCHAR StandardName[32];
	SYSTEMTIME StandardDate;
	LONG StandardBias;
	WCHAR DaylightName[32];
	SYSTEMTIME DaylightDate;
	LONG DaylightBias;
	WCHAR TimeZoneKeyName[128];
	BOOLEAN DynamicDaylightTimeDisabled;
} DYNAMIC_TIME_ZONE_INFORMATION, *PDYNAMIC_TIME_ZONE_INFORMATION;

struct tm
{
	int tm_sec;   // seconds after the minute - [0, 60] including leap second
	int tm_min;   // minutes after the hour - [0, 59]
	int tm_hour;  // hours since midnight - [0, 23]
	int tm_mday;  // day of the month - [1, 31]
	int tm_mon;   // months since January - [0, 11]
	int tm_year;  // years since 1900
	int tm_wday;  // days since Sunday - [0, 6]
	int tm_yday;  // days since January 1 - [0, 365]
	int tm_isdst; // daylight savings time flag
};

BOOL
SystemTimeToFileTime(
	const SYSTEMTIME* lpSystemTime,
	LPFILETIME lpFileTime
);

BOOL
FileTimeToSystemTime(
	const FILETIME* lpFileTime,
	LPSYSTEMTIME lpSystemTime
);

BOOL
SystemTimeToTzSpecificLocalTime(
	const TIME_ZONE_INFORMATION* lpTimeZoneInformation,
	const SYSTEMTIME* lpUniversalTime,
	LPSYSTEMTIME lpLocalTime
);

BOOL
SystemTimeToTzSpecificLocalTimeEx(
	const DYNAMIC_TIME_ZONE_INFORMATION* lpTimeZoneInformation,
	const SYSTEMTIME* lpUniversalTime,
	LPSYSTEMTIME lpLocalTime
);

BOOL
TzSpecificLocalTimeToSystemTime(
	const TIME_ZONE_INFORMATION* lpTimeZoneInformation,
	const SYSTEMTIME* lpLocalTime,
	LPSYSTEMTIME lpUniversalTime
);

BOOL
TzSpecificLocalTimeToSystemTimeEx(
	const DYNAMIC_TIME_ZONE_INFORMATION* lpTimeZoneInformation,
	const SYSTEMTIME* lpLocalTime,
	LPSYSTEMTIME lpUniversalTime
);

void GetSystemTime(
	LPSYSTEMTIME lpSystemTime
);

void GetSystemTimeAsFileTime(
	LPFILETIME lpSystemTimeAsFileTime
);

__time64_t _mkgmtime64(
	struct tm* _Tm
);

__time64_t _mkgmtime(
	struct tm* const _Tm
)
{
	return _mkgmtime64(_Tm);
}

__time64_t mktime(
	struct tm* const _Tm
)
{
	return _mkgmtime64(_Tm);
}

__time64_t _time64(
	__time64_t* _Time
);

__time64_t time(
	time_t* const _Time
)
{
	return _time64(_Time);
}

int gmtime_s(
	struct tm*        _Tm,
	__time64_t const* _Time
);

BOOL
GetFileTime(
	HANDLE hFile,
	LPFILETIME lpCreationTime,
	LPFILETIME lpLastAccessTime,
	LPFILETIME lpLastWriteTime
);


void antipattern2()
{
	// get the current time as a FILETIME
	SYSTEMTIME st; FILETIME ft;
	GetSystemTime(&st);
	SystemTimeToFileTime(&st, &ft);

	// convert to a quadword (64-bit integer) to do arithmetic
	ULONGLONG qwLongTime;
	qwLongTime = (((ULONGLONG)ft.dwHighDateTime) << 32) + ft.dwLowDateTime;

	// add a year by calculating the ticks in 365 days
	// (which may be incorrect when crossing a leap day)
	qwLongTime += 365 * 24 * 60 * 60 * 10000000LLU;

	// copy back to a FILETIME
	ft.dwLowDateTime = (DWORD)(qwLongTime & 0xFFFFFFFF); // BAD
	ft.dwHighDateTime = (DWORD)(qwLongTime >> 32); // BAD

	// convert back to SYSTEMTIME for display or other usage
	FileTimeToSystemTime(&ft, &st);
}

time_t mktime(struct tm *timeptr);
struct tm *gmtime(const time_t *timer);

time_t mkTime(int days)
{
	struct tm tm;
	time_t t;

	tm.tm_sec = 0;
	tm.tm_min = 0;
	tm.tm_hour = 0;
	tm.tm_mday = 0;
	tm.tm_mon = 0;
	tm.tm_year = days / 365; // BAD
	// ...

	t = mktime(&tm); // convert tm -> time_t

	return t;
}

void checkedExample()
{
	// get the current time as a FILETIME
	SYSTEMTIME st; FILETIME ft;
	GetSystemTime(&st);
	SystemTimeToFileTime(&st, &ft);

	// convert to a quadword (64-bit integer) to do arithmetic
	ULONGLONG qwLongTime;
	qwLongTime = (((ULONGLONG)ft.dwHighDateTime) << 32) + ft.dwLowDateTime;

	// add a year by calculating the ticks in 365 days
	// (which may be incorrect when crossing a leap day)
	qwLongTime += 365 * 24 * 60 * 60 * 10000000LLU;

	// copy back to a FILETIME
	ft.dwLowDateTime = (DWORD)(qwLongTime & 0xFFFFFFFF); // GOOD [FALSE POSITIVE]
	ft.dwHighDateTime = (DWORD)(qwLongTime >> 32); // GOOD [FALSE POSITIVE]

	// convert back to SYSTEMTIME for display or other usage
	if (FileTimeToSystemTime(&ft, &st) == 0)
	{
		// handle error...
	}
}
