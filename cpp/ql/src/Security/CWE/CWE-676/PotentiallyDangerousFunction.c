// BAD: using gmtime
int is_morning_bad() {
    struct tm *now = gmtime(time(NULL));
    return (now->tm_hour < 12);
}

// GOOD: using gmtime_r
int is_morning_good() {
    struct tm now;
    gmtime_r(time(NULL), &now);
    return (now.tm_hour < 12);
}
