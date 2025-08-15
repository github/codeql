typedef unsigned long size_t;
typedef size_t FILE;

char *strcat(char *s1, const char *s2);
char *fgets(char *s, int n, FILE *stream);
char *fputs(const char *s, FILE *stream);

void do_get(FILE* request, FILE* response) {
  char user_id[1024];
  fgets(user_id, 1024, request);

  char buffer[1024];
  strcat(buffer, "SELECT * FROM user WHERE user_id='");
  strcat(buffer, user_id);
  strcat(buffer, "'");

  fputs(buffer, response);
}
