typedef unsigned short      WORD; 
typedef unsigned long       DWORD, HANDLE;
typedef int					BOOL, BOOLEAN, errno_t;
typedef char CHAR;
typedef short SHORT;
typedef long LONG;
typedef unsigned short WCHAR;    // wc,   16-bit UNICODE character
typedef long    __time64_t, time_t;
#define NULL 0

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

void Correct_FileTimeToSystemTime(const FILETIME* lpFileTime)
{
	SYSTEMTIME	systemTime;

	if (!FileTimeToSystemTime(lpFileTime, &systemTime))
	{
		/// handle error
		return;
	}

	/// Normal usage
}

void AntiPattern_FileTimeToSystemTime(const FILETIME* lpFileTime)
{
	SYSTEMTIME	systemTime;

	// (out-of-scope) GeneralBug
	FileTimeToSystemTime(lpFileTime, &systemTime);
}

void Correct_SystemTimeToTzSpecificLocalTime(const TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpUniversalTime)
{
	SYSTEMTIME	localTime;

	if (!SystemTimeToTzSpecificLocalTime(lpTimeZoneInformation, lpUniversalTime, &localTime))
	{
		/// handle error
		return;
	}

	/// Normal usage
}

void AntiPattern_SystemTimeToTzSpecificLocalTime(const TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpUniversalTime)
{
	SYSTEMTIME	localTime;

	// (out-of-scope) GeneralBug
	SystemTimeToTzSpecificLocalTime(lpTimeZoneInformation, lpUniversalTime, &localTime);
}

void Correct_SystemTimeToTzSpecificLocalTimeEx(const DYNAMIC_TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpUniversalTime)
{
	SYSTEMTIME	localTime;

	if (!SystemTimeToTzSpecificLocalTimeEx(lpTimeZoneInformation, lpUniversalTime, &localTime))
	{
		/// handle error
		return;
	}

	/// Normal usage
}

void AntiPattern_SystemTimeToTzSpecificLocalTimeEx(const DYNAMIC_TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpUniversalTime)
{
	SYSTEMTIME	localTime;

	// (out-of-scope) GeneralBug
	SystemTimeToTzSpecificLocalTimeEx(lpTimeZoneInformation, lpUniversalTime, &localTime);
}

void Correct_TzSpecificLocalTimeToSystemTime(const TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpLocalTime)
{
	SYSTEMTIME	universalTime;

	if (!TzSpecificLocalTimeToSystemTime(lpTimeZoneInformation, lpLocalTime, &universalTime))
	{
		/// handle error
		return;
	}

	/// Normal usage
}

void AntiPattern_TzSpecificLocalTimeToSystemTime(const TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpLocalTime)
{
	SYSTEMTIME	universalTime;

	// (out-of-scope) GeneralBug
	TzSpecificLocalTimeToSystemTime(lpTimeZoneInformation, lpLocalTime, &universalTime);
}

void Correct_TzSpecificLocalTimeToSystemTimeEx(const DYNAMIC_TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpLocalTime)
{
	SYSTEMTIME	universalTime;

	if (!TzSpecificLocalTimeToSystemTimeEx(lpTimeZoneInformation, lpLocalTime, &universalTime))
	{
		/// handle error
		return;
	}

	/// Normal usage
}

void AntiPattern_TzSpecificLocalTimeToSystemTimeEx(const DYNAMIC_TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpLocalTime)
{
	SYSTEMTIME	universalTime;

	// (out-of-scope) GeneralBug
	TzSpecificLocalTimeToSystemTimeEx(lpTimeZoneInformation, lpLocalTime, &universalTime);
}

/*************************************************
				 SYSTEMTIME Cases
*************************************************/

void Correct_filetime_conversion_check(SYSTEMTIME& st)
{
	FILETIME ft;

	if (!SystemTimeToFileTime(&st, &ft))
	{
		/// Something failed, handle error
		return;
	}

	/// SystemTimeToFileTime succeeded
}

//////////////////////////////////////////////

void AntiPattern_unchecked_filetime_conversion(SYSTEMTIME& st)
{
	FILETIME ft;

	// (out-of-scope) GeneralBug: Unchecked call to SystemTimeToFileTime. this may have failed, but we didn't check the return value!
	SystemTimeToFileTime(&st, &ft);
}

void AntiPattern_unchecked_filetime_conversion2(SYSTEMTIME* st)
{
	FILETIME ft;

	if (st != NULL)
	{
		// (out-of-scope) GeneralBug: Unchecked call to SystemTimeToFileTime. this may have failed, but we didn't check the return value!
		SystemTimeToFileTime(st, &ft);
	}
}

void AntiPattern_unchecked_filetime_conversion2()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	st.wDay++;

	// (out-of-scope) GeneralBug: Not checking is OK, no struct manipulation
	SystemTimeToFileTime(&st, &ft);
}

void AntiPattern_unchecked_filetime_conversion2a()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear += 2;

	// BUG - UncheckedReturnValueForTimeFunctions
	SystemTimeToFileTime(&st, &ft);
}

void AntiPattern_unchecked_filetime_conversion2b()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear++;

	// BUG - UncheckedReturnValueForTimeFunctions
	SystemTimeToFileTime(&st, &ft);
}

void AntiPattern_unchecked_filetime_conversion2b(SYSTEMTIME* st)
{
	FILETIME ft;

	// BUG - UncheckedLeapYearAfterYearModification
	st->wYear++;

	// BUG - UncheckedReturnValueForTimeFunctions
	SystemTimeToFileTime(st, &ft);
}

void AntiPattern_unchecked_filetime_conversion3()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	if (st.wMonth < 12)
	{
		st.wMonth++;
	}
	else
	{
		// Check for leap year, but...
		st.wMonth = 1;
		st.wYear++;
	}

	// (out-of-scope) GeneralBug: Not checking if newly generated date is valid for conversion
	SystemTimeToFileTime(&st, &ft);
}

//////////////////////////////////////////////
void CorrectPattern_check1()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	st.wYear++;

	// Guard
	if (st.wMonth == 2 && st.wDay == 29)
	{
		// move back a day when landing on Feb 29 in an non-leap year
		bool isLeapYear = st.wYear % 4 == 0 && (st.wYear % 100 != 0 || st.wYear % 400 == 0);
		if (!isLeapYear)
		{
			st.wDay = 28;
		}
	}

	// Safe to use
	AntiPattern_unchecked_filetime_conversion(st);
}

void CorrectPattern_check2(int yearsToAdd)
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	st.wYear += yearsToAdd;

	// Guard
	bool isLeapYear = st.wYear % 4 == 0 && (st.wYear % 100 != 0 || st.wYear % 400 == 0);
	st.wDay = st.wMonth == 2 && st.wDay == 29 && !isLeapYear ? 28 : st.wDay;

	// Safe to use
	AntiPattern_unchecked_filetime_conversion(st);
}

bool isLeapYear(SYSTEMTIME& st)
{
	return st.wYear % 4 == 0 && (st.wYear % 100 != 0 || st.wYear % 400 == 0);
}

void CorrectPattern_check3()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	st.wYear++;

	// Guard
	if (st.wMonth == 2 && st.wDay == 29 && isLeapYear(st))
	{
		// move back a day when landing on Feb 29 in an non-leap year
		st.wDay = 28;
	}

	// Safe to use
	AntiPattern_unchecked_filetime_conversion(st);
}

bool isLeapYear2(int year)
{
	return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

bool fixDate(int day, int month, int year)
{
	return (month == 2 && day == 29 && isLeapYear2(year));
}

void CorrectPattern_check4()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	///// FP
	st.wYear++;

	// Guard
	if (fixDate(st.wDay, st.wMonth, st.wYear))
	{
		// move back a day when landing on Feb 29 in an non-leap year
		st.wDay = 28; // GOOD [FALSE POSITIVE]
	}

	// Safe to use
	AntiPattern_unchecked_filetime_conversion(st);
}



void CorrectPattern_NotManipulated_DateFromAPI_0()
{
	SYSTEMTIME st;
	GetSystemTime(&st);
	FILETIME ft;

	// Not checking is OK, no struct manipulation
	SystemTimeToFileTime(&st, &ft);
}

void CorrectPattern_NotManipulated_DateFromAPI_1(HANDLE hWatchdog)
{
	SYSTEMTIME st;
	FILETIME ft;

	GetFileTime(hWatchdog, NULL, NULL, &ft);
	FileTimeToSystemTime(&ft, &st);
}

/////////////////////////////////////////////////////////////////

void AntiPattern_1_year_addition()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear++;

	// Usage of potentially invalid date
	Correct_filetime_conversion_check(st);
}

void AntiPattern_simple_addition(int yearAddition)
{
	SYSTEMTIME st;

	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear += yearAddition;

	// Usage of potentially invalid date
	Correct_filetime_conversion_check(st);
}

void AntiPattern_IncorrectGuard(int yearsToAdd)
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear += yearsToAdd;

	// Incorrect Guard
	if (st.wMonth == 2 && st.wDay == 29)
	{
		// Part of a different anti-pattern. 
		// Make sure the guard includes the proper check
		bool isLeapYear = st.wYear % 4 == 0;
		if (!isLeapYear)
		{
			st.wDay = 28;
		}
	}

	// Potentially Unsafe to use
	Correct_filetime_conversion_check(st);
}

/*************************************************
				struct tm Cases
*************************************************/

void CorrectUsageOf_mkgmtime(struct tm& timeinfo)
{
	if (_mkgmtime(&timeinfo) == -1)
	{
		/// Something failed, handle error
		return;
	}

	/// _mkgmtime succeeded
}

void AntiPattern_uncheckedUsageOf_mkgmtime(struct tm& timeinfo)
{
	// (out-of-scope) GeneralBug: Must check return value for _mkgmtime
	// QLNOTE: Include other related _mkgmtime* functions in the function name pattern
	_mkgmtime(&timeinfo);
	// _mktime64(&timeinfo);
	// _mktime32(&timeinfo);
}

//////////////////////////////////////////////////////////

void Correct_year_addition_struct_tm()
{
	time_t rawtime;
	struct tm timeinfo;
	time(&rawtime);
	// NOTE: Should ideally check return value for this function (not in scope)
	errno_t err = gmtime_s(&timeinfo, &rawtime);
	if (err)
	{
		/// handle error
		return;
	}

	// this is the potentially dangerous part, when not followed up with leap year checks
	timeinfo.tm_year++;

	// Guard
	// move back a day when landing on Feb 29 in an non-leap year 
	bool isLeapYear = timeinfo.tm_year % 4 == 0 && (timeinfo.tm_year % 100 != 0 || (timeinfo.tm_year + 1900) % 400 == 0);
	timeinfo.tm_mday = timeinfo.tm_mon == 1 && timeinfo.tm_mday == 29 && !isLeapYear ? 28 : timeinfo.tm_mday;

	// safe to use
	AntiPattern_uncheckedUsageOf_mkgmtime(timeinfo);
}

void Correct_LinuxPattern()
{
	time_t rawtime;
	struct tm timeinfo;
	time(&rawtime);
	// NOTE: Should ideally check return value for this function (not in scope)
	errno_t err = gmtime_s(&timeinfo, &rawtime);

	/* from 1900 -> from 1980 */
	timeinfo.tm_year -= 80;
	/* 0~11 -> 1~12 */
	timeinfo.tm_mon++;
	/* 0~59 -> 0~29(2sec counts) */
	timeinfo.tm_sec >>= 1;

	// safe to use
	AntiPattern_uncheckedUsageOf_mkgmtime(timeinfo);
}

//////////////////////////////////////////

void AntiPattern_year_addition_struct_tm()
{
	time_t rawtime;
	struct tm timeinfo;
	time(&rawtime);
	gmtime_s(&timeinfo, &rawtime);
	// BUG - UncheckedLeapYearAfterYearModification
	timeinfo.tm_year++;

	// Usage of potentially invalid date
	CorrectUsageOf_mkgmtime(timeinfo);
}

/////////////////////////////////////////////////////////

void FalsePositiveTests(int x)
{
	struct tm timeinfo;
	SYSTEMTIME st;

	timeinfo.tm_year = x;
	timeinfo.tm_year = 1970;

	st.wYear = x;
	st.wYear = 1900 + x;
}

void FalseNegativeTests(int x)
{
	struct tm timeinfo;
	SYSTEMTIME st;

	timeinfo.tm_year = x;

	// BUG - UncheckedLeapYearAfterYearModification
	timeinfo.tm_year = x + timeinfo.tm_year;
	// BUG - UncheckedLeapYearAfterYearModification
	timeinfo.tm_year = 1970 + timeinfo.tm_year;

	st.wYear = x;
	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear = x + st.wYear;
	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear = (1986 + st.wYear) - 1;
}

// False positive
inline void
IncrementMonth(LPSYSTEMTIME pst)
{
	if (pst->wMonth < 12)
	{
		pst->wMonth++;
	}
	else
	{
		pst->wMonth = 1;
		pst->wYear++;
	}
}

/////////////////////////////////////////////////////////

void mkDateTest(int year)
{
	struct tm t;

	t.tm_sec = 0;
	t.tm_min = 0;
	t.tm_hour = 0;
	t.tm_mday = 1;  // day of the month - [1, 31]
	t.tm_mon = 0;   // months since January - [0, 11]
	if (year >= 1900)
	{
		// 4-digit year
		t.tm_year = year - 1900; // GOOD
	} else if ((year >= 0) && (year < 100)) {
		// 2-digit year assumed in the range 2000 - 2099
		t.tm_year = year + 100; // GOOD [FALSE POSITIVE]
	} else {
		// fail
	}
	// ...
}

void unmodified1()
{
	SYSTEMTIME st;
	FILETIME ft;
	WORD w;

	GetSystemTime(&st);

	w = st.wYear;

	SystemTimeToFileTime(&st, &ft); // GOOD - no modification
}

void unmodified2()
{
	SYSTEMTIME st;
	FILETIME ft;
	WORD *w_ptr;

	GetSystemTime(&st);

	w_ptr = &(st.wYear);

	SystemTimeToFileTime(&st, &ft); // GOOD - no modification
}

void modified3()
{
	SYSTEMTIME st;
	FILETIME ft;
	WORD *w_ptr;

	GetSystemTime(&st);

	st.wYear = st.wYear + 1; // BAD

	SystemTimeToFileTime(&st, &ft);
}

void modified4()
{
	SYSTEMTIME st;
	FILETIME ft;
	WORD *w_ptr;

	GetSystemTime(&st);

	st.wYear++; // BAD
	st.wYear++; // BAD
	st.wYear++; // BAD

	SystemTimeToFileTime(&st, &ft);
}
