typedef unsigned long size_t;
typedef struct sqlite3 sqlite3;
typedef struct sqlite3_stmt sqlite3_stmt;
typedef struct sqlite3_str sqlite3_str;

int snprintf(char *str, size_t size, const char *format, ...);
int sqlite3_open(const char *filename, sqlite3 **ppDb);
int sqlite3_close(sqlite3*);
int sqlite3_exec(sqlite3*, const char *sql, int (*callback)(void*,int,char**,char**), void *, char **errmsg);
int sqlite3_prepare_v2(sqlite3 *db, const char *zSql, int nByte, sqlite3_stmt **ppStmt, const char **pzTail);
int sqlite3_step(sqlite3_stmt*);
int sqlite3_finalize(sqlite3_stmt*);
int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int n, void(*)(void*));
sqlite3_str* sqlite3_str_new(sqlite3*);
void sqlite3_str_appendf(sqlite3_str*, const char *zFormat, ...);
char* sqlite3_str_finish(sqlite3_str*);

#define SQLITE_TRANSIENT ((void(*)(void*))-1)

// Simulate a sensitive value
const char* getSensitivePassword() {
    return "super_secret_password";
}

void storePasswordCleartext(sqlite3* db, const char* password) {
    // BAD: Storing sensitive data in cleartext
    char sql[256];
    // Unsafe: no escaping, for test purposes only
    snprintf(sql, sizeof(sql), "INSERT INTO users(password) VALUES('%s');", password); // $ Source
    char* errMsg = 0;
    sqlite3_exec(db, sql, 0, 0, &errMsg); // $ Alert
}

void storePasswordWithPrepare(sqlite3* db, const char* password) {
    // BAD: Storing sensitive data in cleartext using sqlite3_prepare
    char sql[256];
    snprintf(sql, sizeof(sql), "INSERT INTO users(password) VALUES('%s');", password); // $ Source
    sqlite3_stmt* stmt = 0;
    sqlite3_prepare_v2(db, sql, -1, &stmt, 0); // $ Alert
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

void storePasswordWithBind(sqlite3* db, const char* password) {
    // BAD: Storing sensitive data in cleartext using sqlite3_bind_text
    const char* sql = "INSERT INTO users(password) VALUES(?);";
    sqlite3_stmt* stmt = 0;
    sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    sqlite3_bind_text(stmt, 1, password, -1, SQLITE_TRANSIENT); // $ Alert
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

void storePasswordWithAppendf(sqlite3_str* pStr, const char* password) {
    // BAD: Storing sensitive data in cleartext using sqlite3_str_appendf
    sqlite3_str_appendf(pStr, "INSERT INTO users(password) VALUES('%s');", password); // $ Alert
}

// Example sanitizer: hashes the sensitive value before storage
void hashSensitiveValue(const char* input, char* output, size_t outSize) {
    // Dummy hash for illustration (not cryptographically secure)
    unsigned int hash = 5381;
    for (const char* p = input; *p; ++p)
        hash = ((hash << 5) + hash) + (unsigned char)(*p);
    snprintf(output, outSize, "%u", hash);
}

void storeSanitizedPasswordCleartext(sqlite3* db, const char* password) {
    // GOOD: Sanitizing sensitive data before storage
    char hashed[64];
    hashSensitiveValue(password, hashed, sizeof(hashed));
    char sql[256];
    snprintf(sql, sizeof(sql), "INSERT INTO users(password) VALUES('%s');", hashed);
    char* errMsg = 0;
    sqlite3_exec(db, sql, 0, 0, &errMsg);
}

void storeSanitizedPasswordWithBind(sqlite3* db, const char* password) {
    // GOOD: Sanitizing sensitive data before storage with bind
    char hashed[64];
    hashSensitiveValue(password, hashed, sizeof(hashed));
    const char* sql = "INSERT INTO users(password) VALUES(?);";
    sqlite3_stmt* stmt = 0;
    sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    sqlite3_bind_text(stmt, 1, hashed, -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

void storeSanitizedPasswordWithAppendf(sqlite3_str* pStr, const char* password) {
    // GOOD: Sanitizing sensitive data before storage with appendf
    char hashed[64];
    hashSensitiveValue(password, hashed, sizeof(hashed));
    sqlite3_str_appendf(pStr, "INSERT INTO users(password) VALUES('%s');", hashed);
}

int main() {
    sqlite3* db = 0;
    sqlite3_open(":memory:", &db);

    // Create table
    const char* createTableSQL = "CREATE TABLE users(id INTEGER PRIMARY KEY, password TEXT);";
    sqlite3_exec(db, createTableSQL, 0, 0, 0);

    const char* sensitive = getSensitivePassword();

    storePasswordCleartext(db, sensitive);
    storePasswordWithPrepare(db, sensitive);
    storePasswordWithBind(db, sensitive);
    storeSanitizedPasswordCleartext(db, sensitive);
    storeSanitizedPasswordWithBind(db, sensitive);

    // If sqlite3_str is available
    sqlite3_str* pStr = sqlite3_str_new(db);
    storePasswordWithAppendf(pStr, sensitive);
    storeSanitizedPasswordWithAppendf(pStr, sensitive);
    sqlite3_str_finish(pStr);

    sqlite3_close(db);
    return 0;
}
