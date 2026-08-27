// Test case for the PostgreSQL libpq SQL-injection sinks modeled in Postgres.model.yml.
// Associated with CWE-089: SQL injection.

typedef unsigned long size_t;
typedef unsigned int Oid;
typedef struct pg_conn PGconn;
typedef struct pg_result PGresult;

PGresult *PQexec(PGconn *conn, const char *query);
PGresult *PQexecParams(PGconn *conn, const char *command, int nParams,
                       const Oid *paramTypes, const char *const *paramValues,
                       const int *paramLengths, const int *paramFormats, int resultFormat);
PGresult *PQprepare(PGconn *conn, const char *stmtName, const char *query, int nParams,
                    const Oid *paramTypes);
int PQsendQuery(PGconn *conn, const char *query);
int PQsendQueryParams(PGconn *conn, const char *command, int nParams, const Oid *paramTypes,
                      const char *const *paramValues, const int *paramLengths,
                      const int *paramFormats, int resultFormat);
int PQsendPrepare(PGconn *conn, const char *stmtName, const char *query, int nParams,
                  const Oid *paramTypes);

char *gets(char *s);

void libpqTests(PGconn *conn) {
  char userInput[1000];
  gets(userInput); // $ Source

  // A user-controlled string is interpreted as SQL.
  PQexec(conn, userInput);                                // $ Alert
  PQexecParams(conn, userInput, 0, 0, 0, 0, 0, 0);        // $ Alert
  PQprepare(conn, "stmt", userInput, 0, 0);               // $ Alert
  PQsendQuery(conn, userInput);                           // $ Alert
  PQsendQueryParams(conn, userInput, 0, 0, 0, 0, 0, 0);   // $ Alert
  PQsendPrepare(conn, "stmt", userInput, 0, 0);           // $ Alert

  // A constant query is safe.
  PQexec(conn, "SELECT 1");                               // GOOD
}
