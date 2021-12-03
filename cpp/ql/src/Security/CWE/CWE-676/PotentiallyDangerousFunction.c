// BAD: using gmtime
int is_morning_bad() {
    const time_t now_seconds = time(NULL);
    struct tm *now = gmtime(&now_seconds);
    return (now->tm_hour < 12);
}

// GOOD: using gmtime_r
int is_morning_good() {
    const time_t now_seconds = time(NULL);
    struct tm now;
    gmtime_r(&now_seconds, &now);
    return (now.tm_hour < 12);
}
