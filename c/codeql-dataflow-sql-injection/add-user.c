#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include <sqlite3.h>
#include <time.h>

void write_log(const char* fmt, ...) {
    time_t t;
    char tstr[26];
    va_list args;

    va_start(args, fmt);
    t = time(NULL);
    ctime_r(&t, tstr);
    tstr[24] = 0; /* no \n */
    fprintf(stderr, "[%s] ", tstr);
    vfprintf(stderr, fmt, args);
    va_end(args);
    fflush(stderr);
}

void abort_on_error(int rc, sqlite3 *db) {
    if( rc ) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        fflush(stderr);
        abort();
    }
}

void abort_on_exec_error(int rc, sqlite3 *db, char* zErrMsg) {
    if( rc!=SQLITE_OK ){
        fprintf(stderr, "SQL error: %s\n", zErrMsg);
        sqlite3_free(zErrMsg);
        sqlite3_close(db);
        fflush(stderr);
        abort();
    }
}
    
char* get_user_info() {
#define BUFSIZE 1024
    char* buf = (char*) malloc(BUFSIZE * sizeof(char));
    if(buf==NULL) abort();
    int count;
    // Disable buffering to avoid need for fflush
    // after printf().
    setbuf( stdout, NULL );
    printf("*** Welcome to sql injection ***\n");
    printf("Please enter name: ");
    count = read(STDIN_FILENO, buf, BUFSIZE - 1);
    if (count <= 0) abort();
    // ensure the buffer is zero-terminated
    buf[count] = '\0';
    /* strip trailing whitespace */
    while (count && isspace(buf[count-1])) {
        buf[count-1] = 0; --count;
    }
    return buf;
}

int get_new_id() {
    int id = getpid();
    return id;
}

void write_info(int id, char* info) {
    sqlite3 *db;
    int rc;
    int bufsize = 1024;
    char *zErrMsg = 0;
    char query[bufsize];
    
    /* open db */
    rc = sqlite3_open("users.sqlite", &db);
    abort_on_error(rc, db);

    /* Format query */
    snprintf(query, bufsize, "INSERT INTO users VALUES (%d, '%s')", id, info);
    write_log("query: %s\n", query);

    /* Write info */
    rc = sqlite3_exec(db, query, NULL, 0, &zErrMsg);
    abort_on_exec_error(rc, db, zErrMsg);

    sqlite3_close(db);
}

int main(int argc, char* argv[]) {
    char* info;
    int id;
    info = get_user_info();
    id = get_new_id();
    write_info(id, info);
     free(info);
    /*
     * show_info(id);
     */
}
