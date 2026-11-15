// Deliberately unsafe consumers for the production command-injection query.
// Compile/extract only; these functions must never be executed.
#ifdef LIBEVENT_REAL_HEADERS
#include <event2/http.h>
#include <event2/buffer.h>
#include <stdio.h>
#include <stdlib.h>
#else
#include "libevent.h"
int snprintf(char *, size_t, const char *, ...);
int system(const char *);
#endif

static void command_handler(struct evhttp_request *req, void *context) {
  char command[256];
  snprintf(command, sizeof(command), "tool %s", evhttp_request_get_uri(req));
  system(command); // $ Alert
  struct evbuffer *input = evhttp_request_get_input_buffer(req);
  snprintf(command, sizeof(command), "tool %s", evbuffer_pullup(input, -1));
  system(command); // $ Alert
  char body[32];
  evbuffer_remove(input, body, sizeof(body));
  snprintf(command, sizeof(command), "tool %s", body);
  system(command); // $ Alert
}

void install_command_handler(struct evhttp *server) {
  evhttp_set_cb(server, "/command", command_handler, 0);
}

void local_commands(void) {
  struct evhttp_request *req = evhttp_request_new(0, 0);
  char command[256];
  snprintf(command, sizeof(command), "tool %s", evhttp_request_get_uri(req));
  system(command); // local request: no remote source
  struct evbuffer *local = evbuffer_new();
  evbuffer_add(local, "constant", 8);
  snprintf(command, sizeof(command), "tool %s", evbuffer_pullup(local, -1));
  system(command); // local buffer: no remote source
  evbuffer_free(local);
  evhttp_request_free(req);
}
