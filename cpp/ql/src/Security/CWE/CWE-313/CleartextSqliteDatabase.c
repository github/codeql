
void bad(void) {
  char *password = "cleartext password";
  sqlite3 *credentialsDB;
  sqlite3_stmt *stmt;

  if (sqlite3_open("credentials.db", &credentialsDB) == SQLITE_OK) {
    // BAD: database opened without encryption being enabled
    sqlite3_exec(credentialsDB, "CREATE TABLE IF NOT EXISTS creds (password TEXT);", NULL, NULL, NULL);
    if (sqlite3_prepare_v2(credentialsDB, "INSERT INTO creds(password) VALUES(?)", -1, &stmt, NULL) == SQLITE_OK) {
      sqlite3_bind_text(stmt, 1, password, -1, SQLITE_TRANSIENT);
      sqlite3_step(stmt);
      sqlite3_finalize(stmt);
      sqlite3_close(credentialsDB);
    }
  }
}

void good(void) {
  char *password = "cleartext password";
  sqlite3 *credentialsDB;
  sqlite3_stmt *stmt;

  if (sqlite3_open("credentials.db", &credentialsDB) == SQLITE_OK) {
    // GOOD: database encryption enabled:
    sqlite3_exec(credentialsDB, "PRAGMA key = 'secretKey!'", NULL, NULL, NULL);
    sqlite3_exec(credentialsDB, "CREATE TABLE IF NOT EXISTS creds (password TEXT);", NULL, NULL, NULL);
    if (sqlite3_prepare_v2(credentialsDB, "INSERT INTO creds(password) VALUES(?)", -1, &stmt, NULL) == SQLITE_OK) {
      sqlite3_bind_text(stmt, 1, password, -1, SQLITE_TRANSIENT);
      sqlite3_step(stmt);
      sqlite3_finalize(stmt);
      sqlite3_close(credentialsDB);
    }
  }
}

