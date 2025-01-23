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

struct timespec
{
	time_t tv_sec;
	long tv_nsec;
};

/* Timestamps of log entries. */
struct logtime {
	struct tm       tm;
	long     usec;
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
void GetLocalTime(
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

struct tm *localtime_r( const time_t *timer, struct tm *buf );

/**
 * Negative Case
 * FileTimeToSystemTime is called and the return value is checked
*/
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

/**
 * Positive (Out of Scope) Bug Case
 * FileTimeToSystemTime is called but no check is conducted to verify the result of the operation
*/
void AntiPattern_FileTimeToSystemTime(const FILETIME* lpFileTime)
{
	SYSTEMTIME	systemTime;

	// (out-of-scope) GeneralBug
	FileTimeToSystemTime(lpFileTime, &systemTime);
}

/**
 * Negative Case
 * SystemTimeToTzSpecificLocalTime is called and the return value is verified
*/
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

/**
 * Positive (Out of Scope) Case
 * AntiPattern_SystemTimeToTzSpecificLocalTime is called but the return value is not validated
*/
void AntiPattern_SystemTimeToTzSpecificLocalTime(const TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpUniversalTime)
{
	SYSTEMTIME	localTime;

	// (out-of-scope) GeneralBug
	SystemTimeToTzSpecificLocalTime(lpTimeZoneInformation, lpUniversalTime, &localTime);
}

/**
 * Negative Case
 * SystemTimeToTzSpecificLocalTimeEx is called and the return value is validated
*/
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

/**
 * Positive Case
 * SystemTimeToTzSpecificLocalTimeEx is called but the return value is not validated
*/
void AntiPattern_SystemTimeToTzSpecificLocalTimeEx(const DYNAMIC_TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpUniversalTime)
{
	SYSTEMTIME	localTime;

	// (out-of-scope) GeneralBug
	SystemTimeToTzSpecificLocalTimeEx(lpTimeZoneInformation, lpUniversalTime, &localTime);
}

/**
 * Negative Case
 * Correct use of TzSpecificLocalTimeToSystemTime, function is called and the return value is validated.
*/
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

/**
 * Positive (Out of Scope) Case
 * TzSpecificLocalTimeToSystemTime is called however the return value is not validated
*/
void AntiPattern_TzSpecificLocalTimeToSystemTime(const TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpLocalTime)
{
	SYSTEMTIME	universalTime;

	// (out-of-scope) GeneralBug
	TzSpecificLocalTimeToSystemTime(lpTimeZoneInformation, lpLocalTime, &universalTime);
}

/**
 * Negative Case
 * TzSpecificLocalTimeToSystemTimeEx is called and the return value is correctly validated
*/
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

/**
 * Positive (Out of Scope) Case
 * TzSpecificLocalTimeToSystemTimeEx is called however the return value is not validated
*/
void AntiPattern_TzSpecificLocalTimeToSystemTimeEx(const DYNAMIC_TIME_ZONE_INFORMATION *lpTimeZoneInformation, const SYSTEMTIME *lpLocalTime)
{
	SYSTEMTIME	universalTime;

	// (out-of-scope) GeneralBug
	TzSpecificLocalTimeToSystemTimeEx(lpTimeZoneInformation, lpLocalTime, &universalTime);
}

/*************************************************
				 SYSTEMTIME Cases
*************************************************/

/**
 * Negative Case
 * SystemTimeToFileTime is called and the return value is validated in a guard
*/
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

/**
 * Positive (Out of Scope) Case
 * SystemTimeToFileTime is called but the return value is not validated in a guard
*/
void AntiPattern_unchecked_filetime_conversion(SYSTEMTIME& st)
{
	FILETIME ft;

	// (out-of-scope) GeneralBug: Unchecked call to SystemTimeToFileTime. this may have failed, but we didn't check the return value!
	SystemTimeToFileTime(&st, &ft);
}

/**
 * Positive (Out of Scope) Case
 * SystemTimeToFileTime is called but the return value is not validated in a guard
*/
void AntiPattern_unchecked_filetime_conversion2(SYSTEMTIME* st)
{
	FILETIME ft;

	if (st != NULL)
	{
		// (out-of-scope) GeneralBug: Unchecked call to SystemTimeToFileTime. this may have failed, but we didn't check the return value!
		SystemTimeToFileTime(st, &ft);
	}
}

/**
 * Positive (Out of Scope) 
 * SYSTEMTIME.wDay is incremented by one (and no guard exists)
*/
void AntiPattern_unchecked_filetime_conversion2()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	st.wDay++;

	// (out-of-scope) GeneralBug: Not checking is OK, no struct manipulation
	SystemTimeToFileTime(&st, &ft);
}

/**
 * Positive Cases
 * 	- Anti-pattern 1: [year ±n, month, day]
 * 	- Generic (Out of Scope) - UncheckedReturnValueForTimeFunctions
*/
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

/**
 * Positive Cases
 * 	- Anti-pattern 1: [year ±n, month, day]
 * 	- Generic (Out of Scope) - UncheckedReturnValueForTimeFunctions
*/
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

/**
 * Positive Cases
 * 	- Anti-pattern 1: [year ±n, month, day]
 * 	- Generic (Out of Scope) - UncheckedReturnValueForTimeFunctions
*/
void AntiPattern_unchecked_filetime_conversion2b(SYSTEMTIME* st)
{
	FILETIME ft;

	// BUG - UncheckedLeapYearAfterYearModification
	st->wYear++;

	// BUG - UncheckedReturnValueForTimeFunctions
	SystemTimeToFileTime(st, &ft);
}

/**
 * Positive Cases
 * 	- Anti-pattern 3: datetime.AddDays(±28)
 * 	- Generic (Out of Scope) - UncheckedReturnValueForTimeFunctions
*/
void AntiPattern_unchecked_filetime_conversion3()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	if (st.wMonth < 12)
	{
		// Anti-pattern 3: datetime.AddDays(±28)
		st.wMonth++;
	}
	else
	{
		// No check for leap year is required here, as the month is statically set to January.
		st.wMonth = 1;
		st.wYear++;
	}

	// (out-of-scope) GeneralBug: Not checking if newly generated date is valid for conversion
	SystemTimeToFileTime(&st, &ft);
}

//////////////////////////////////////////////

/**
 * Negative Case - Anti-pattern 1: [year ±n, month, day]
 * Year is incremented and if we are on Feb the 29th, set to the 28th if the new year is a common year.
*/
void CorrectPattern_check1()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	st.wYear++;

	// Guard against February the 29th
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

/**
 * Negative Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer and then the leap year case is correctly guarded and handled.
*/
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

/**
 * Could give rise to AntiPattern 7: IsLeapYear (Conditional Logic)
*/
bool isLeapYear(SYSTEMTIME& st)
{
	return st.wYear % 4 == 0 && (st.wYear % 100 != 0 || st.wYear % 400 == 0);
}

/**
 * Negative Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer and then the leap year case is correctly guarded and handled.
*/
void CorrectPattern_check3()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	st.wYear++;

	// Guard
	/** Negative Case - Anti-pattern 7: IsLeapYear
 	* Body of conditional statement is safe recommended code
	*/
	if (st.wMonth == 2 && st.wDay == 29 && isLeapYear(st))
	{
		// move back a day when landing on Feb 29 in an non-leap year
		st.wDay = 28;
	}

	// Safe to use
	AntiPattern_unchecked_filetime_conversion(st);
}

/**
 * Could give rise to AntiPattern 7: IsLeapYear (Conditional Logic)
*/
bool isLeapYear2(int year)
{
	return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

bool fixDate(int day, int month, int year)
{
	return (month == 2 && day == 29 && isLeapYear2(year));
}

/**
 * Negative Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer and then the leap year case is correctly guarded and handled.
*/
void CorrectPattern_check4()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	///// FP
	st.wYear++;

	// Guard
	/** Negative Case - Anti-pattern 7: IsLeapYear
 	* Body of conditional statement is safe recommended code
	*/
	if (fixDate(st.wDay, st.wMonth, st.wYear))
	{
		// move back a day when landing on Feb 29 in an non-leap year
		st.wDay = 28; // GOOD [FALSE POSITIVE] Anti-pattern 7
	}

	// Safe to use
	AntiPattern_unchecked_filetime_conversion(st);
}

/**
 * Negative Case - Generic
 * No manipulation is conducted on struct populated from GetSystemTime.
*/
void CorrectPattern_NotManipulated_DateFromAPI_0()
{
	SYSTEMTIME st;
	GetSystemTime(&st);
	FILETIME ft;

	// Not checking is OK, no struct manipulation
	SystemTimeToFileTime(&st, &ft);
}

/**
 * Negative Case - Generic
 * No manipulation is conducted on struct populated from GetFileTime.
*/
void CorrectPattern_NotManipulated_DateFromAPI_1(HANDLE hWatchdog)
{
	SYSTEMTIME st;
	FILETIME ft;

	GetFileTime(hWatchdog, NULL, NULL, &ft);
	FileTimeToSystemTime(&ft, &st);
}

/////////////////////////////////////////////////////////////////

/**
 * Positive Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer but a leap year is not handled.
*/
void AntiPattern_1_year_addition()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification 
	st.wYear++; // BUg V2

	// Usage of potentially invalid date
	Correct_filetime_conversion_check(st);
}

/**
 * Positive Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer but a leap year is not handled.
*/
void AntiPattern_simple_addition(int yearAddition)
{
	SYSTEMTIME st;

	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear += yearAddition; // Bug V2

	// Usage of potentially invalid date
	Correct_filetime_conversion_check(st);
}

/**
 * Positive Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer but a leap year is not handled *correctly*.
*/
void AntiPattern_IncorrectGuard(int yearsToAdd)
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear += yearsToAdd;

	// Incorrect Guard
	if (st.wMonth == 2 && st.wDay == 29)
	{
		// Part of a different anti-pattern (AntiPattern 5). 
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

/**
 * Positive Case - General (Out of Scope)
 * Must Check for return value of _mkgmtime
*/
void AntiPattern_uncheckedUsageOf_mkgmtime(struct tm& timeinfo)
{
	// (out-of-scope) GeneralBug: Must check return value for _mkgmtime
	// QLNOTE: Include other related _mkgmtime* functions in the function name pattern
	_mkgmtime(&timeinfo);
	// _mktime64(&timeinfo);
	// _mktime32(&timeinfo);
}

//////////////////////////////////////////////////////////

/**
 * Negative Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer and leap year is not handled correctly.
*/
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

/**
 * Negative Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer and leap year is not handled correctly.
*/
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

/**
 * Negative Case - Anti-pattern 1: [year ±n, month, day]
 * Years is incremented by some integer and leap year is not handled correctly.
*/
void AntiPattern_year_addition_struct_tm()
{
	time_t rawtime;
	struct tm timeinfo;
	time(&rawtime);
	gmtime_s(&timeinfo, &rawtime);
	// BUG - UncheckedLeapYearAfterYearModification
	timeinfo.tm_year++; // Bug V2

	// Usage of potentially invalid date
	CorrectUsageOf_mkgmtime(timeinfo);
}

/////////////////////////////////////////////////////////

/**
 * Negative Case - Anti-pattern 1: [year ±n, month, day]
 * False positive: Years is initialized to or incremented by some integer (but never used).
*/
void FalsePositiveTests(int x)
{
	struct tm timeinfo;
	SYSTEMTIME st;

	timeinfo.tm_year = x;
	timeinfo.tm_year = 1970;

	st.wYear = x;
	st.wYear = 1900 + x;
}

/**
 * Positive Case - Anti-pattern 1: [year ±n, month, day]
 * False positive: Years is initialized to or incremented by some integer (but never used).
*/
void FalseNegativeTests(int x)
{
	struct tm timeinfo;
	SYSTEMTIME st;

	timeinfo.tm_year = x;

	// BUG - UncheckedLeapYearAfterYearModification
	// Positive Case - Anti-pattern 1: [year ±n, month, day]
	timeinfo.tm_year = x + timeinfo.tm_year;	// Bug V2
	// BUG - UncheckedLeapYearAfterYearModification
	// Positive Case - Anti-pattern 1: [year ±n, month, day]
	timeinfo.tm_year = 1970 + timeinfo.tm_year;  // Bug V2

	st.wYear = x;
	// BUG - UncheckedLeapYearAfterYearModification
	// Positive Case - Anti-pattern 1: [year ±n, month, day]
	st.wYear = x + st.wYear;  // Bug V2
	// BUG - UncheckedLeapYearAfterYearModification
	// Positive Case - Anti-pattern 1: [year ±n, month, day]
	st.wYear = (1986 + st.wYear) - 1; // Bug V2
}

/**
 * Positive AntiPattern 1
 * Year field is modified but via an intermediary variable.
*/
bool tp_intermediaryVar(struct timespec now, struct logtime &timestamp_remote)
{
	struct tm tm_parsed;
	bool timestamp_found = false;

	struct tm tm_now;
	time_t t_now;
	int year;

	timestamp_found = true;

	/*
	 * As the timestamp does not contain the year
	 * number, daylight saving time information, nor
	 * a time zone, attempt to infer it. Due to
	 * clock skews, the timestamp may even be part
	 * of the next year. Use the last year for which
	 * the timestamp is at most one week in the
	 * future.
	 *
	 * This loop can only run for at most three
	 * iterations before terminating.
	 */
	t_now = now.tv_sec;
	localtime_r(&t_now, &tm_now);

	timestamp_remote.tm = tm_parsed;
	timestamp_remote.tm.tm_isdst = -1;
	timestamp_remote.usec = now.tv_nsec * 0.001;
	for (year = tm_now.tm_year + 1;; --year)
	{
		// assert(year >= tm_now.tm_year - 1);
		timestamp_remote.tm.tm_year = year;
		if (mktime(&timestamp_remote.tm) < t_now + 7 * 24 * 60 * 60)
			break;
	}
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
		t.tm_mday = 1; // day of the month - [1, 31]
		t.tm_mon = 0;  // months since January - [0, 11]
		if (year >= 1900)
		{
			// 4-digit year
			t.tm_year = year - 1900; // GOOD
		}
		else if ((year >= 0) && (year < 100))
		{
			// 2-digit year assumed in the range 2000 - 2099
			t.tm_year = year + 100; // GOOD [FALSE POSITIVE]
		}
		else
		{
			// fail
		}
		// ...
	}

	/**
	 * Negative Case - Anti-pattern 1a: [a.year, b.month, b.day]
	 * False positive: No modification of SYSTEMTIME struct.
	 */
	void unmodified1()
	{
		SYSTEMTIME st;
		FILETIME ft;
		WORD w;

		GetSystemTime(&st);

		w = st.wYear;

		SystemTimeToFileTime(&st, &ft); // GOOD - no modification
	}

	/**
	 * Negative Case - Anti-pattern 1a: [a.year, b.month, b.day]
	 * False positive: No modification of SYSTEMTIME struct.
	 */
	void unmodified2()
	{
		SYSTEMTIME st;
		FILETIME ft;
		WORD *w_ptr;

		GetSystemTime(&st);

		w_ptr = &(st.wYear);

		SystemTimeToFileTime(&st, &ft); // GOOD - no modification
	}

	/**
	 * Positive Case - Anti-pattern 1: [year ±n, month, day]
	 * Modification of SYSTEMTIME struct adding to year but no leap year guard is conducted.
	 */
	void modified3()
	{
		SYSTEMTIME st;
		FILETIME ft;
		WORD *w_ptr;

		GetSystemTime(&st);

		st.wYear = st.wYear + 1; // BAD

		SystemTimeToFileTime(&st, &ft);
	}

	/**
	 * Positive Case - Anti-pattern 1: [year ±n, month, day]
	 * Modification of SYSTEMTIME struct adding to year but no leap year guard is conducted.
	 */
	void modified4()
	{
		SYSTEMTIME st;
		FILETIME ft;
		WORD *w_ptr;

		GetSystemTime(&st);

		st.wYear++; // BAD Positive Case - Anti-pattern 1: [year ±n, month, day]

		SystemTimeToFileTime(&st, &ft);
	}

	/**
	 * Negative Case - Anti-pattern 1: [year ±n, month, day]
	 * Modification of SYSTEMTIME struct adding to year but no leap year guard is conducted.
	 */
	void modified5()
	{
		SYSTEMTIME st;
		FILETIME ft;
		WORD *w_ptr;

		GetSystemTime(&st);

		st.wYear++; // Negative Case - Anti-pattern 1: [year ±n, month, day], guard condition below.

		if (SystemTimeToFileTime(&st, &ft))
		{
			///...
		}
	}

	struct tm ltime(void)
	{
		SYSTEMTIME st;
		struct tm tm;
		bool isLeapYear;

		GetLocalTime(&st);
		tm.tm_sec=st.wSecond;
		tm.tm_min=st.wMinute;
		tm.tm_hour=st.wHour;
		tm.tm_mday=st.wDay;
		tm.tm_mon=st.wMonth-1;
		tm.tm_year=(st.wYear>=1900?st.wYear-1900:0);

		// Check for leap year, and adjust the date accordingly
		isLeapYear = tm.tm_year % 4 == 0 && (tm.tm_year % 100 != 0 || tm.tm_year % 400 == 0);
		tm.tm_mday = tm.tm_mon == 2 && tm.tm_mday == 29 && !isLeapYear ? 28 : tm.tm_mday;
		return tm;
	}
