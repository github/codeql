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

/**
 * Positive AntiPattern 5 - year % 4 == 0
*/
void antipattern5()
{
    int year = 1;
    bool isLeapYear = year % 4 == 0;

	// get the current time as a FILETIME
	SYSTEMTIME st; FILETIME ft;
	GetSystemTime(&st);
	SystemTimeToFileTime(&st, &ft);

    bool isLeapYear2 = st.wYear % 4 == 0;
}

/**
 * Negative AntiPattern 5 - year % 4 == 0
*/
void antipattern5_negative()
{
	SYSTEMTIME st; FILETIME ft;
	GetSystemTime(&st);
	SystemTimeToFileTime(&st, &ft);
	bool isLeapYear = st.wYear % 4 == 0 && (st.wYear % 100 != 0 || st.wYear % 400 == 0);

    int year = 1;
	bool isLeapYear2 = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

/**
* Negative - Valid Leap year check (logically equivalent) (#1035)
*/
bool ap5_negative_inverted_form(int year){
	return year % 400 == 0 || (year % 100 != 0 && year % 4 == 0);
}

/**
* Negative - Valid Leap Year check (#1035)
* Century subexpression component is inverted `!(year % 100 == 0)`
*/
bool ap5_negative_inverted_century_100(int year){
	return !((year % 4 == 0) && (!(year % 100 == 0) || (year % 400 == 0)));
}

class SomeResultClass{
  public:
    int GetYear() {
      return 2000;
    }
};

/**
 * Negative - Valid Leap Year Check (#1038)
 * Valid leap year check, but the expression is the result of a Call and thus breaks SSA.
*/
bool ap5_fp_expr_call(SomeResultClass result){
	if (result.GetYear() % 4 == 0 && (result.GetYear() % 100 != 0 || result.GetYear() % 400 == 0)){
		return true;
	}
	return false;
}

/**
* Positive - Invalid Leap Year check
* Components are split up and distributed across multiple if statements.
*/
bool tp_leap_year_multiple_if_statements(int year){
	if (year % 4 == 0) {
		if (year % 100 == 0) {
			if (year % 400 == 0) {
				return true;
			}
		}else{
			return true;
		}
	}
	return false;
}