typedef unsigned short      WORD; 

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

int main()
{
    // BAD: Creation of tm stuct corresponding to the beginning of Heisei era
    tm *timeTm = new tm();
    timeTm->tm_year = 1989;
    timeTm->tm_mon = 1;
    timeTm->tm_mday = 8;


    // GOOD: Creation of tm stuct with different date
    tm *timeTm1 = new tm();
    timeTm1->tm_year = 1988;
    timeTm1->tm_mon = 1;
    timeTm1->tm_mday = 1;

    // BAD: Creation of SYSTEMTIME stuct corresponding to the beginning of Heisei era
    SYSTEMTIME st;
    st.wDay = 8;
    st.wMonth = 1;
    st.wYear = 1989;


    // GOOD: Creation of SYSTEMTIME stuct with a different date
    SYSTEMTIME st1;
    st1.wDay = 1;
    st1.wMonth = 1;
    st1.wYear = 1990;


    // BAD: Creation of SYSTEMTIME stuct corresponding to the beginning of Reiwa era
    SYSTEMTIME st2;
    st2.wDay = 1;
    st2.wMonth = 5;
    st2.wYear = 2019;

    return 0;
}

