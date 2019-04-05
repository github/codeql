// Semmle test case for rule PotentiallyDangerousFunction.ql
// Associated with CWE-676: Use of Potentially Dangerous Function. http://cwe.mitre.org/data/definitions/676.html

// Standard library definitions
#define NULL (0)

typedef unsigned long size_t;
typedef size_t time_t;

struct tm {
    int tm_sec; // seconds after the minute - [0, 60]
    int tm_min; // minutes after the hour - [0, 59]
    int tm_hour; // hours since midnight - [0, 23]
    int tm_mday; // day of the month - [1, 31]
    int tm_mon; // months since January - [0, 11]
    int tm_year; // years since 1900
    int tm_wday; // days since Sunday - [0, 6]
    int tm_yday; // days since January 1 - [0, 365]
    int tm_isdst; // Daylight Saving Time flag
};

struct tm *gmtime(const time_t *timer);
time_t time(time_t *timer);
struct tm *localtime(const time_t *timer);
char *ctime(const time_t *timer);
char *asctime(const struct tm *timeptr);

// Code under test

int is_morning() {
    struct tm *now = gmtime(time(NULL)); // BAD: gmtime uses shared state
    return (now->tm_hour < 12);
}

char *gets(char *s);

void testGets() {
	char buf1[1024];
	char buf2 = malloc(1024);
	char *s;

	gets(buf1); // BAD: use of gets
	s = gets(buf2); // BAD: use of gets
}

void testTime()
{
	struct tm *now = localtime(time(NULL)); // BAD: localtime uses shared state
	char *time_string = ctime(time(NULL)); // BAD: localtime uses shared state
	char *time_string2 = asctime(now); // BAD: localtime uses shared state
}
