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

typedef const wchar_t* LPCWSTR;

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

/*
 * Data structure representing a broken-down timestamp.
 *
 * CAUTION: the IANA timezone library (src/timezone/) follows the POSIX
 * convention that tm_mon counts from 0 and tm_year is relative to 1900.
 * However, Postgres' datetime functions generally treat tm_mon as counting
 * from 1 and tm_year as relative to 1 BC.  Be sure to make the appropriate
 * adjustments when moving from one code domain to the other.
 */
struct pg_tm
{
    int         tm_sec;
    int         tm_min;
    int         tm_hour;
    int         tm_mday;
    int         tm_mon;         /* see above */
    int         tm_year;        /* see above */
    int         tm_wday;
    int         tm_yday;
    int         tm_isdst;
    long int    tm_gmtoff;
    const char *tm_zone;
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

int _wtoi(
   const wchar_t *str
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
 * 	- Anti-pattern 1: [year +-n, month, day]
 * 	- Generic (Out of Scope) - UncheckedReturnValueForTimeFunctions
*/
void AntiPattern_unchecked_filetime_conversion2a()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear += 2; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// BUG - UncheckedReturnValueForTimeFunctions
	SystemTimeToFileTime(&st, &ft);
}

/**
 * Positive Cases
 * 	- Anti-pattern 1: [year +-n, month, day]
 * 	- Generic (Out of Scope) - UncheckedReturnValueForTimeFunctions
*/
void AntiPattern_unchecked_filetime_conversion2b()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear++; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// BUG - UncheckedReturnValueForTimeFunctions
	SystemTimeToFileTime(&st, &ft);
}

/**
 * Positive Cases
 * 	- Anti-pattern 1: [year +-n, month, day]
 * 	- Generic (Out of Scope) - UncheckedReturnValueForTimeFunctions
*/
void AntiPattern_unchecked_filetime_conversion2b(SYSTEMTIME* st)
{
	FILETIME ft;

	// BUG - UncheckedLeapYearAfterYearModification
	st->wYear++; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// BUG - UncheckedReturnValueForTimeFunctions
	SystemTimeToFileTime(st, &ft);
}

/**
 * Positive Cases
 * 	- Anti-pattern 3: datetime.AddDays(+-28)
 * 	- Generic (Out of Scope) - UncheckedReturnValueForTimeFunctions
*/
void AntiPattern_unchecked_filetime_conversion3()
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);

	if (st.wMonth < 12)
	{
		// Anti-pattern 3: datetime.AddDays(+-28)
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
 * Negative Case - Anti-pattern 1: [year +-n, month, day]
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
 * Negative Case - Anti-pattern 1: [year +-n, month, day]
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
 * Negative Case - Anti-pattern 1: [year +-n, month, day]
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
 * Negative Case - Anti-pattern 1: [year +-n, month, day]
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
 * Negative Case - Anti-pattern 1: [year +-n, month, day]
 * Year is incremented by some integer and checked through a conversion through an inter procedural function check
*/
void AntiPattern_1_year_addition()
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	// Safe, checked interprocedurally through Correct_filetime_conversion_check
	st.wYear++;

	// Usage of potentially invalid date
	Correct_filetime_conversion_check(st);
}



/**
 * Negative Case - Anti-pattern 1: [year +-n, month, day]
 * Years is incremented by some integer and checked through a conversion through an inter procedural function check
*/
void AntiPattern_simple_addition(int yearAddition)
{
	SYSTEMTIME st;

	GetSystemTime(&st);

	st.wYear += yearAddition;

	// Usage of potentially invalid date
	Correct_filetime_conversion_check(st);
}

/**
 * Positive Case - Anti-pattern 1: [year +-n, month, day]
 * Years is incremented by some integer but a leap year is not handled *correctly*.
*/
void AntiPattern_IncorrectGuard(int yearsToAdd)
{
	SYSTEMTIME st;
	GetSystemTime(&st);

	// BUG - UncheckedLeapYearAfterYearModification
	st.wYear += yearsToAdd; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

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
 * Negative Case - Anti-pattern 1: [year +-n, month, day]
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
 * Positive Case - Anti-pattern 1: [year +-n, month, day]
 * Years is incremented by some integer and leap year is not handled correctly.
*/
void Incorrect_LinuxPattern()
{
	time_t rawtime;
	struct tm timeinfo;
	time(&rawtime);
	// NOTE: Should ideally check return value for this function (not in scope)
	errno_t err = gmtime_s(&timeinfo, &rawtime);

	/* from 1900 -> from 1980 */
	// BUG - UncheckedLeapYearAfterYearModification
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
 * Negative Case - Anti-pattern 1: [year +-n, month, day]
 * Years is incremented by some integer and leap year is assumed checked through
 * check of a conversion functions return value.
*/
void AntiPattern_year_addition_struct_tm()
{
	time_t rawtime;
	struct tm timeinfo;
	time(&rawtime);
	gmtime_s(&timeinfo, &rawtime);
	timeinfo.tm_year++;

	// mkgmtime result checked in nested call here, assume leap year conversion is potentially handled
	CorrectUsageOf_mkgmtime(timeinfo);
}

/////////////////////////////////////////////////////////


/**
 * Positive Case - Anti-pattern 1: [year +-n, month, day]
*/
void test(int x)
{
	struct tm timeinfo;
	SYSTEMTIME st;

	timeinfo.tm_year = x;

	// BUG - UncheckedLeapYearAfterYearModification
	// Positive Case - Anti-pattern 1: [year +-n, month, day]
	timeinfo.tm_year = x + timeinfo.tm_year;	// $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	st.wYear = x;
	// BUG - UncheckedLeapYearAfterYearModification
	// Positive Case - Anti-pattern 1: [year +-n, month, day]
	st.wYear = x + st.wYear;  // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

/**
 * Positive AntiPattern 1 NOTE: historically considered positive but mktime checks year validity, needs re-assessment
 * Year field is modified but via an intermediary variable.
*/
void tp_intermediaryVar(struct timespec now, struct logtime &timestamp_remote)
{
	struct tm tm_parsed;

	struct tm tm_now;
	time_t t_now;
	int year;

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
	 * Positive Case - Anti-pattern 1: [year +-n, month, day]
	 * Modification of SYSTEMTIME struct adding to year but no leap year guard is conducted.
	 */
	void modified3()
	{
		SYSTEMTIME st;
		FILETIME ft;
		WORD *w_ptr;

		GetSystemTime(&st);

		// BUG - UncheckedLeapYearAfterYearModification
		st.wYear = st.wYear + 1; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

		SystemTimeToFileTime(&st, &ft);
	}

	/**
	 * Positive Case - Anti-pattern 1: [year +-n, month, day]
	 * Modification of SYSTEMTIME struct adding to year but no leap year guard is conducted.
	 */
	void modified4()
	{
		SYSTEMTIME st;
		FILETIME ft;
		WORD *w_ptr;

		GetSystemTime(&st);

		// BUG - UncheckedLeapYearAfterYearModification
		st.wYear++; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

		SystemTimeToFileTime(&st, &ft);
	}

	/**
	 * Negative Case - Anti-pattern 1: [year +-n, month, day]
	 * Modification of SYSTEMTIME struct adding to year but value passed to a
	 * conversion function that can be checked for success, and the result is checked.
	 */
	void modified5()
	{
		SYSTEMTIME st;
		FILETIME ft;
		WORD *w_ptr;

		GetSystemTime(&st);

		st.wYear++;

		// Presumed safe usage, as if the conversion is incorrect, a user can handle the error.
		// NOTE: it doesn't mean the user actually does the correct conversion and it it also
		// doesn't mean it will error our in all cases that may be invalid.
		// For example, if a leap year and the date is 28, we may want 29 if the time is meant
		// to capture the end of the month, but 28 is still valid and will not error out.
		if (SystemTimeToFileTime(&st, &ft))
		{
			///...
		}
	}

/**
* Negative Case - Anti-pattern 1: [year +-n, month, day]
* Modification of SYSTEMTIME struct by copying from another struct, but no arithmetic is performed.
*/
bool
FMAPITimeToSysTimeW(LPCWSTR wszTime, SYSTEMTIME *psystime)
{
	// if (!wszTime || SafeIsBadReadPtr(wszTime, 1) || lstrlenW(wszTime) != cchMAPITime)
	// 	return false;
	// AssertTag(!SafeIsBadWritePtr(psystime, sizeof(SYSTEMTIME)), 0x0004289a /* tag_abc80 */);
	// memset(psystime, 0, sizeof(SYSTEMTIME));

	psystime->wYear = (WORD)_wtoi(wszTime);
	psystime->wMonth = (WORD)_wtoi(wszTime+5);
	psystime->wDay = (WORD)_wtoi(wszTime+8);
	psystime->wHour = (WORD)_wtoi(wszTime+11);
	psystime->wMinute = (WORD)_wtoi(wszTime+14);
	return true;
}

/**
* Negative Case - Anti-pattern 1: [year +-n, month, day]
* Modification of SYSTEMTIME struct by copying from another struct, but no arithmetic is performed.
*/
void fp_daymonth_guard(){
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);
    // FALSE POSITIVE: year is incremented but month is checked and day corrected
	// in a ternary operation. It may be possible to fix this with a more sophisticated
	// data flow analysis.
	st.wYear++; // $ SPURIOUS: Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	st.wDay = st.wMonth == 2 && st.wDay == 29 ? 28 : st.wDay;

	SystemTimeToFileTime(&st, &ft);
}

void increment_arg(WORD &x){
	x++; // $ Source
}

void increment_arg_by_pointer(WORD *x){
	(*x)++; // $ Source
}


void fn_year_set_through_out_arg(){
	SYSTEMTIME st;
	GetSystemTime(&st);
	// BAD, year incremented without check
	increment_arg(st.wYear); // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// GetSystemTime(&st);
	// Bad, year incremented without check
	increment_arg_by_pointer(&st.wYear); // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}


/* TODO: don't alert on simple copies from another struct where all three {year,month,day} are copied
void
GetEpochTime(struct pg_tm *tm)
{
	struct pg_tm *t0;
	pg_time_t	epoch = 0;

	t0 = pg_gmtime(&epoch);

	tm->tm_year = t0->tm_year;
	tm->tm_mon = t0->tm_mon;
	tm->tm_mday = t0->tm_mday;
	tm->tm_hour = t0->tm_hour;
	tm->tm_min = t0->tm_min;
	tm->tm_sec = t0->tm_sec;

	tm->tm_year += 1900;
	tm->tm_mon++;
} */

void
fp_guarded_by_month(struct pg_tm *tm){
	int woy = 52;
	int MONTHS_PER_YEAR = 12;
	/*
	* If it is week 52/53 and the month is January, then the
	* week must belong to the previous year. Also, some
	* December dates belong to the next year.
	*/
	if (woy >= 52 && tm->tm_mon == 1)
		--tm->tm_year; // Negative Test Case
	if (woy <= 1 && tm->tm_mon == MONTHS_PER_YEAR)
		++tm->tm_year; // Negative Test Case
}

typedef unsigned short CSHORT;

typedef struct _TIME_FIELDS {
  CSHORT Year;
  CSHORT Month;
  CSHORT Day;
  CSHORT Hour;
  CSHORT Minute;
  CSHORT Second;
  CSHORT Milliseconds;
  CSHORT Weekday;
} TIME_FIELDS, *PTIME_FIELDS;

void
tp_ptime(PTIME_FIELDS ptm){
	ptm->Year = ptm->Year - 1; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}


bool isLeapYearRaw(WORD year)
{
	return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

void leap_year_checked_raw_false_positive1(WORD year, WORD offset, WORD day){
	struct tm tmp;

	year += offset;

	if (isLeapYearRaw(year)){
		// in this simplified example, assume the logic of this function
		// can assume a day is 28 by default
		// this check is more to establish the leap year guard is present
		day += 1;
	}

	// Assume the check handled leap year correctly
	tmp.tm_year = year; // GOOD
	tmp.tm_mday = day;
}


void leap_year_checked_raw_false_positive2(WORD year, WORD offset, WORD day){
	struct tm tmp;

	year += offset;

	tmp.tm_year = year; // GOOD, check performed immediately after on raw year

	// Adding some additional checks to resemble cases observed in the wild
	if ( day > 0)
	{
		if (isLeapYearRaw(year)){
			// Assume logic that would adjust the day correctly
		}
	}
	else{
		if (isLeapYearRaw(year)){
			// Assume logic that would adjust the day correctly
		}
	}

	tmp.tm_mday = day;

	year += offset; // $ Source

	tmp.tm_year = year; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

}


bool isNotLeapYear(struct tm tm)
{
	return !(tm.tm_year % 4 == 0 && (tm.tm_year % 100 != 0 || tm.tm_year % 400 == 0));
}

bool isNotLeapYear2(struct tm tm)
{
	return (tm.tm_year % 4 != 0 || (tm.tm_year % 100 == 0 && tm.tm_year % 400 != 0));
}


void inverted_leap_year_check(WORD year, WORD offset, WORD day){
	struct tm tmp;

	tmp.tm_year = year + offset;

	if (isNotLeapYear(tmp)){
		day = 28;
	}

	tmp.tm_year = year + offset;

	if(isNotLeapYear2(tmp)){
		day = 28;
	}


	tmp.tm_year = year + offset;
	bool isNotLeapYear = (tmp.tm_year % 4 != 0 || (tmp.tm_year % 100 == 0 && tmp.tm_year % 400 != 0));

	if(isNotLeapYear){
		day = 28;
	}

	tmp.tm_year = year + offset; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}


void simplified_leap_year_check1(WORD year, WORD offset){
	struct tm tmp;

	tmp.tm_year = year + offset;  // OK

	bool isLeap = (!((tmp.tm_year + 1900) % 4)) && ((tmp.tm_year + 1900) % 100 || !((tmp.tm_year + 1900) % 400));
	if(isLeap){
		// do something
	}

	// Modified after check, could be dangerous
	tmp.tm_year = year + offset; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

void simplified_leap_year_check2(WORD year, WORD offset){
	struct tm tmp;

	tmp.tm_year = year + offset; // OK

	bool isNotLeap = ((tmp.tm_year + 1900) % 4) || (!((tmp.tm_year + 1900) % 100) && ((tmp.tm_year + 1900) % 400));
	if(isNotLeap){
		// do something
	}

	// Modified after check, could be dangerous
	tmp.tm_year = year + offset;  // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

void simplified_leap_year_check3(WORD year, WORD offset){
	SYSTEMTIME tmp;

	tmp.wYear = year + offset; // OK

	bool isLeap = (!(tmp.wYear % 4)) && (tmp.wYear % 100 || !(tmp.wYear% 400));
	if(isLeap){
		// do something
	}

	// Modified after check, could be dangerous
	tmp.wYear = year + offset; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

void simplified_leap_year_check4(WORD year, WORD offset){
	SYSTEMTIME tmp;

	tmp.wYear = year + offset; // OK

	bool isNotLeap = (tmp.wYear % 4) || (!(tmp.wYear % 100) && (tmp.wYear % 400));
	if(isNotLeap){
		// do something
	}

	// Modified after check, could be dangerous
	tmp.wYear = year + offset;  // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

void bad_simplified_leap_year_check1(WORD year, WORD offset){
	struct tm tmp;

	tmp.tm_year = year + offset; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// incorrect logic, should negate the %4 result
	bool isLeap = ((tmp.tm_year + 1900) % 4) && ((tmp.tm_year + 1900) % 100 || !((tmp.tm_year + 1900) % 400));
	if(isLeap){
		// do something
	}
}

void bad_simplified_leap_year_check2(WORD year, WORD offset){
	struct tm tmp;

	tmp.tm_year = year + offset; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]


	// incorrect logic, should not negate the %4 result
	bool isNotLeap = (!((tmp.tm_year + 1900) % 4)) || (!((tmp.tm_year + 1900) % 100) && ((tmp.tm_year + 1900) % 400));
	if(isNotLeap){
		// do something
	}
}

void bad_simplified_leap_year_check3(WORD year, WORD offset){
	SYSTEMTIME tmp;

	tmp.wYear = year + offset; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// incorrect logic, should negate the %4 result
	bool isLeap = (tmp.wYear % 4) && (tmp.wYear % 100 || !(tmp.wYear % 400));
	if(isLeap){
		// do something
	}
}

void bad_simplified_leap_year_check4(WORD year, WORD offset){
	SYSTEMTIME tmp;

	tmp.wYear = year + offset; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]


	// incorrect logic, should not negate the %4 result
	bool isNotLeap = (!(tmp.wYear % 4)) || (!(tmp.wYear % 100) && (tmp.wYear % 400));
	if(isNotLeap){
		// do something
	}
}


void compound_leap_year_check(WORD year, WORD offset, WORD month, WORD day){
	struct tm tmp;

	tmp.tm_year = year + offset;

	bool isLeap = tmp.tm_year % 4 == 0 && (tmp.tm_year % 100 != 0 || tmp.tm_year % 400 == 0) && (month == 2 && day == 29);

	if(isLeap){
		// do something
	}
	tmp.tm_mday = day;
	tmp.tm_mon = month;
}

void indirect_time_conversion_check(WORD year, WORD offset){
	SYSTEMTIME tmp;

	tmp.wYear = year + offset;

	FILETIME ft;

	// (out-of-scope) GeneralBug: Unchecked call to SystemTimeToFileTime. this may have failed, but we didn't check the return value!
	BOOL res = SystemTimeToFileTime(&tmp, &ft);

	// Assume this check of the result is sufficient as an implicit leap year check.
	bool x = (res == 0) ? true : false;
}

void set_time(WORD year, WORD month, WORD day){
	SYSTEMTIME tmp;

	tmp.wYear = year; //$ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
	tmp.wMonth = month;
	tmp.wDay = day;
}

void constant_month_on_year_modification1(WORD year, WORD offset, WORD month){
	SYSTEMTIME tmp;

	if(month++ > 12){
		tmp.wMonth = 1;
		tmp.wYear = year + 1;// OK since the year is incremented with a known non-leap year month change
	}

	if(month++ > 12){

		set_time(year+1, 1, 31);// OK since the year is incremented with a known non-leap year month change
	}
}

void constant_month_on_year_modification2(WORD year, WORD offset, WORD month){
	SYSTEMTIME tmp;

	if(month++ > 12){
		tmp.wMonth = 1;
		tmp.wYear = year + 1;// OK since the year is incremented with a known non-leap year month change
	}


	if(month++ > 12){
		// some heuristics to detect a false positive here rely on variable names
		// which is often consistent in the wild.
		// This variant uses the variable names yeartmp and monthtmp
		WORD yeartmp;
		WORD monthtmp;
		yeartmp = year + 1;
		monthtmp = 1;
		set_time(yeartmp, monthtmp, 31);// OK since the year is incremented with a known non-leap year month change
	}
}

typedef struct parent_struct {
	SYSTEMTIME t;
} PARENT_STRUCT;



void nested_time_struct(WORD year, WORD offset){
	PARENT_STRUCT ps;

	ps.t.wYear = year + offset; // OK, checked below

	bool isLeap = isLeapYearRaw(ps.t.wYear);

	if(isLeap){
		// do something
	}
}

void intermediate_time_struct(WORD year, WORD offset){
	SYSTEMTIME tm, tm2;
	FILETIME ftTime;

	tm.wYear = year + offset;

	tm2.wYear = tm.wYear;


	while ( !SystemTimeToFileTime( &tm2, &ftTime ) )
	{
		/// handle error
	}

}

void constant_day_on_year_modification1(WORD year, WORD offset, WORD month){
	SYSTEMTIME tmp;

	if(month++ > 12){
		tmp.wDay = 1;
		tmp.wYear = year + 1;// OK since the year is incremented with a known non-leap year day
	}

	if(month++ > 12){

		set_time(year+1, month, 1);// OK since the year is incremented with a known non-leap year day
	}

	if(month++ > 12){

		// BAD, year incremented, month unknown in block, and date is set to 31
		// which is dangerous.
		set_time(year+1, month, 31);// $ Source
	}
}

void constant_day_on_year_modification2(WORD year, WORD month){
	SYSTEMTIME tmp;

	// FLASE POSITIVE SOURCE:
	// flowing into set_time, the set time does pass a constant day
	// but the source here and the source of that constant month don't align
	// Current heuristics require the source of the constant day align with the
	// source and/or the sink of the year modification.
	// We could potentially improve this by checking the paths of both the year and day
	// flows, but this may be more complex than is warranted for now.
	year = year + 1; // $ SPURIOUS: Source

	if(month++ > 12){
		tmp.wDay = 1;
		tmp.wYear = year;// OK since the year is incremented with a known non-leap year day
	}

	if(month++ > 12){

		set_time(year, month, 1);// OK since the year is incremented with a known non-leap year day
	}

	year = year + 1; // $ Source

	if(month++ > 12){

		// BAD, year incremented, month unknown in block, and date is set to 31
		// which is dangerous.
		set_time(year, month, 31);
	}
}


void modification_after_conversion1(tm timeinfo){
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = timeinfo.tm_year + 1900;

	year += 1; // $ MISSING: Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

WORD get_civil_year(tm timeinfo){
	return timeinfo.tm_year + 1900;
}

void modification_after_conversion2(tm timeinfo){
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = get_civil_year(timeinfo);
	year += 1; // $ MISSING: Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

void modification_after_conversion_saved_to_other_time_struct1(tm timeinfo){
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = timeinfo.tm_year + 1900;

	year += 1; // $ MISSING: Source

	SYSTEMTIME s;
	// FALSE NEGATIVE: missing this because the conversion happens locally before
	// the year adjustment, which seems as though it is part of a conversion itself
	s.wYear = year; // $ MISSING: Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}



void modification_after_conversion_saved_to_other_time_struct2(tm timeinfo){
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = get_civil_year(timeinfo);

	year += 1; // $ Source

	SYSTEMTIME s;
	s.wYear = year; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

void modification_after_conversion_saved_to_other_time_struct3(tm timeinfo){
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = timeinfo.tm_year + 1900;

	year = year + 1; // $ MISSING: Source

	SYSTEMTIME s;
	// FALSE NEGATIVE: missing this because the conversion happens locally before
	// the year adjustment, which seems as though it is part of a conversion itself
	s.wYear = year; // $ MISSING: Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}


void year_saved_to_variable_then_modified1(tm timeinfo){
	// A modified year is not directly assigned to the year, rather, the year is
	// saved to a variable, modified, used, but never assigned back.
	WORD year = timeinfo.tm_year;

	// NOTE: should we even try to detect cases like this?
	// Our current rationale is that a year in a struct is more dangerous than a year in isolation
	// A year in isolation is harder to interpret
	year += 1; // MISSING: $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
}

void modification_before_conversion1(tm timeinfo){
	timeinfo.tm_year += 1; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = timeinfo.tm_year + 1900;
}

void modification_before_conversion2(tm timeinfo){
	timeinfo.tm_year += 1; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = get_civil_year(timeinfo);
}



void year_saved_to_variable_then_modified_with_leap_check1(tm timeinfo){
	// A modified year is not directly assigned to the year, rather, the year is
	// saved to a variable, modified, used, but never assigned back.
	WORD year = timeinfo.tm_year;

	year += 1;

	// performing a check is considered good enough, even if not used correctly
	bool b = (year+1900) % 4 == 0 && ((year+1900) % 100 != 0 || (year+1900) % 400 == 0);
}


void modification_after_conversion_with_leap_check1(tm timeinfo){
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = timeinfo.tm_year + 1900;

	year += 1;

	// performing a check is considered good enough, even if not used correctly
	bool b = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

void modification_after_conversion_with_leap_check2(tm timeinfo){
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = get_civil_year(timeinfo);

	year += 1;

	// performing a check is considered good enough, even if not used correctly
	bool b = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

void modification_before_conversion_with_leap_check1(tm timeinfo){
	timeinfo.tm_year += 1;
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = timeinfo.tm_year + 1900;

	// performing a check is considered good enough, even if not used correctly
	bool b = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

void modification_before_conversion_with_leap_check2(tm timeinfo){
	timeinfo.tm_year += 1;
	// convert a tm year into a civil year, then modify after conversion
	// This case shows a false negative where the year might be used and it is incorrectly modified,
	// and never reassigned to another struct.
	WORD year = get_civil_year(timeinfo);

	// performing a check is considered good enough, even if not used correctly
	bool b = (year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0);
}

void odd_leap_year_check1(tm timeinfo){
	timeinfo.tm_year += 1;


	// Using an odd sytle of checking divisible by 4 presumably as an optimization trick
	if(((timeinfo.tm_year+1900) & 3) == 0 && ((timeinfo.tm_year+1900) % 100 != 0 || (timeinfo.tm_year+1900) % 400 == 0))
	{
		// do something
	}
}

void odd_leap_year_check2(tm timeinfo){
	timeinfo.tm_year += 1; // $ SPURIOUS: Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// Using an odd sytle of checking divisible by 4 presumably as an optimization trick
	// but also check unrelated conditions on the year as an optimization to rule out irrelevant years
	// for gregorian leap years
	if(timeinfo.tm_mon == 2 && ((timeinfo.tm_year+1900) & 3) == 0 && ((timeinfo.tm_year+1900) <= 1582 || (timeinfo.tm_year+1900) % 100 != 0 || (timeinfo.tm_year+1900) % 400 == 0))
	{
		// do something
	}
}

void odd_leap_year_check3(tm timeinfo){
	timeinfo.tm_year += 1; // $ SPURIOUS: Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// Using an odd sytle of checking divisible by 4 presumably as an optimization trick
	// but also check unrelated conditions on the year as an optimization to rule out irrelevant years
	// for gregorian leap years
	if(timeinfo.tm_mon == 2 && ((timeinfo.tm_year+1900) % 4) == 0 && ((timeinfo.tm_year+1900) <= 1582 || (timeinfo.tm_year+1900) % 100 != 0 || (timeinfo.tm_year+1900) % 400 == 0))
	{
		// do something
	}
}

void odd_leap_year_check4(tm timeinfo){
	timeinfo.tm_year += 1;
	WORD year = timeinfo.tm_year + 1900;

	if( (year % 4 == 0) && (year % 100 > 0 || (year % 400 == 0)))
	{
		// do something
	}
}

void odd_leap_year_check5(tm timeinfo){
	timeinfo.tm_year += 1;
	WORD year = timeinfo.tm_year + 1900;

	if( (year % 4 > 0) || (year % 100 == 0 && (year % 400 > 0)))
	{
		// do something
	}
}


void date_adjusted_through_mkgmtime(tm timeinfo){
	timeinfo.tm_year += 1; // $ SPURIOUS: Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	// Using an odd sytle of checking divisible by 4 presumably as an optimization trick
	// but also check unrelated conditions on the year as an optimization to rule out irrelevant years
	// for gregorian leap years
	if(timeinfo.tm_mon == 2 && ((timeinfo.tm_year+1900) % 4) == 0 && ((timeinfo.tm_year+1900) <= 1582 || (timeinfo.tm_year+1900) % 100 != 0 || (timeinfo.tm_year+1900) % 400 == 0))
	{
		// do something
	}
}

bool data_killer(WORD *d){
	(*d) = 1;
	return true;
}

void interproc_data_killer1(tm timeinfo, WORD delta){
	WORD year = delta + 1;

	if(data_killer(&year)){
		timeinfo.tm_year = year;
	}
}


void leap_year_check_after_normalization(tm timeinfo, WORD delta){
	WORD year = delta + 1;

	if(data_killer(&year)){
		timeinfo.tm_year = year;
	}
}


void leap_year_check_call_on_conversion1(tm timeinfo){
	timeinfo.tm_year += 1;
	isLeapYearRaw(timeinfo.tm_year + 1900);
}

void leap_year_check_call_on_conversion2(tm timeinfo){
	timeinfo.tm_year += 1;
	WORD year = get_civil_year(timeinfo);
	isLeapYearRaw(year);
}

WORD getDaysInMonth(WORD year, WORD month){
	// simplified
	if(month == 2){
		return isLeapYearRaw(year) ? 29 : 28;
	}
	// else assume logic for every other month,
	// returning 30 for simplicity
	return 30;
}

WORD get_civil_year_raw(WORD year){
	return year + 1900;
}

void leap_year_check_call_on_conversion3(tm timeinfo, WORD year, WORD month, WORD delta){
	year += delta;
	WORD days = getDaysInMonth(get_civil_year_raw(year), month);
	timeinfo.tm_year = year;
}

void assumed_maketime_conversion1(tm timeinfo)
{
	//the docs of mktime suggest feb29 is handled, and conversion will occur automatically
	//no check required.
	timeinfo.tm_year += 1;

	mktime(&timeinfo);
}


void bad_leap_year_check_logic1(tm timeinfo){
	timeinfo.tm_year += 1; // $ Alert[cpp/leap-year/unchecked-after-arithmetic-year-modification]

	WORD year = get_civil_year(timeinfo);

	// expected logic:
	//(year % 4) && ((year % 100) || !(year % 400 )))
 	WORD days = (!(year % 4) && (!(year % 100) || (year % 400))) ? 366 : 365;
}
