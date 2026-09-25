// Minimal declarations from the public Comdb2 C API:
// https://github.com/bloomberg/comdb2/blob/dfb15415b48cbe67220d76964243086051813676/cdb2api/cdb2api.h
typedef struct cdb2_hndl cdb2_hndl_tp;

enum { CDB2_CSTRING = 3 };

int cdb2_run_statement(cdb2_hndl_tp *hndl, const char *sql);
int cdb2_run_statement_typed(cdb2_hndl_tp *hndl, const char *sql, int ntypes, const int *types);
int cdb2_bind_param(cdb2_hndl_tp *hndl, const char *name, int type,
                    const void *varaddr, int length);

char *gets(char *s);
typedef unsigned long size_t;
size_t strlen(const char *s);

void comdb2Tests(cdb2_hndl_tp *hndl) {
  char userInput[1000];
  gets(userInput); // $ Source
  int types[] = {CDB2_CSTRING};

  // Both execution functions interpret user-controlled query text as SQL.
  cdb2_run_statement(hndl, userInput); // $ Alert
  cdb2_run_statement_typed(hndl, userInput, 1, types); // $ Alert

  cdb2_run_statement(hndl, "SELECT 1"); // GOOD
  cdb2_run_statement_typed(hndl, "SELECT 'constant'", 1, types); // GOOD

  // Bound values are data, not SQL text, even when controlled by the user.
  cdb2_bind_param(hndl, "value", CDB2_CSTRING, userInput, strlen(userInput) + 1); // GOOD
  cdb2_run_statement(hndl, "SELECT @value"); // GOOD
  cdb2_run_statement_typed(hndl, "SELECT @value", 1, types); // GOOD
}
