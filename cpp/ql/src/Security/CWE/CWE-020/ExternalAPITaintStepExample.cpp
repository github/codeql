#include <cstdio>

void do_get(FILE* request, FILE* response) {
  char user_id[1024];
  fgets(user_id, 1024, request);

  char buffer[1024];
  strcat(buffer, "SELECT * FROM user WHERE user_id='");
  strcat(buffer, user_id);
  strcat(buffer, "'");

  // ...
}