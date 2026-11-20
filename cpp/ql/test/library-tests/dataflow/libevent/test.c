// Compile/extract only. None of these library calls are executed.
#ifdef LIBEVENT_REAL_HEADERS
#include <event2/http.h>
#include <event2/buffer.h>
#else
#include "libevent.h"
#endif

void consume(const char *label, const char *data);
void consume_number(const char *label, long value);
const char *source_bytes(void);
#ifndef LIBEVENT_REAL_HEADERS
int recv(int, char *, int, int);
#endif

static const char *wrapped_uri(struct evhttp_request *req) {
  return evhttp_request_get_uri(req);
}

static void specific_handler(struct evhttp_request *req, void *context) {
  consume("server_uri", evhttp_request_get_uri(req)); // EXPECT: tracked
  consume("server_uri_wrapper", wrapped_uri(req)); // EXPECT: tracked
  consume("callback_context", (const char *)context); // EXPECT: untracked
}

static void generic_handler(struct evhttp_request *req, void *context) {
  struct evbuffer *input = evhttp_request_get_input_buffer(req);
  consume("server_pullup", (const char *)evbuffer_pullup(input, -1)); // EXPECT: tracked
  char destination[32];
  int removed = evbuffer_remove(input, destination, sizeof(destination));
  consume("server_remove", destination); // EXPECT: tracked
  consume_number("remove_count", removed); // EXPECT: untracked
  struct evbuffer *output = evhttp_request_get_output_buffer(req);
  evbuffer_add(output, "local response", 14);
  consume("server_output", (const char *)evbuffer_pullup(output, -1)); // EXPECT: untracked
  struct evbuffer *local = evbuffer_new();
  evbuffer_add(local, "local", 5);
  consume("local_in_handler", (const char *)evbuffer_pullup(local, -1)); // EXPECT: untracked
  consume("literal_in_handler", "literal"); // EXPECT: untracked
  evbuffer_free(local);
}

void install_handlers(struct evhttp *server) {
  evhttp_set_cb(server, "/path", specific_handler, 0);
  evhttp_set_gencb(server, generic_handler, 0);
}

static void unregistered_handler(struct evhttp_request *req, void *context) {
  consume("unregistered_uri", evhttp_request_get_uri(req)); // EXPECT: untracked
  consume("unregistered_body", (const char *)evbuffer_pullup(evhttp_request_get_input_buffer(req), -1)); // EXPECT: untracked
}

static void client_callback(struct evhttp_request *req, void *context) {
  // Client response callbacks are outside this initial server-source model.
  consume("client_callback_not_modeled", evhttp_request_get_uri(req)); // EXPECT: untracked
}

void local_request(void) {
  struct evhttp_request *req = evhttp_request_new(client_callback, 0);
  consume("local_request_uri", evhttp_request_get_uri(req)); // EXPECT: untracked
  consume("local_request_input", (const char *)evbuffer_pullup(evhttp_request_get_input_buffer(req), -1)); // EXPECT: untracked
  consume("local_request_output", (const char *)evbuffer_pullup(evhttp_request_get_output_buffer(req), -1)); // EXPECT: untracked
  evhttp_request_free(req);
}

void buffers(size_t size) {
  struct evbuffer *local = evbuffer_new();
  evbuffer_add(local, "constant", 8);
  char destination[32];
  evbuffer_remove(local, destination, sizeof(destination));
  consume("local_remove", destination); // EXPECT: untracked
  consume("local_pullup", (const char *)evbuffer_pullup(local, -1)); // EXPECT: untracked
  struct evbuffer *tainted = evbuffer_new();
  evbuffer_add(tainted, source_bytes(), size);
  consume("added_pullup", (const char *)evbuffer_pullup(tainted, -1)); // EXPECT: tracked
  char copy[32];
  evbuffer_remove(tainted, copy, sizeof(copy));
  consume("added_remove", copy); // EXPECT: tracked
  consume("separate_local_buffer", (const char *)evbuffer_pullup(local, -1)); // EXPECT: untracked
  evbuffer_free(local);
  evbuffer_free(tainted);
}

void controls(int socket) {
  char data[32];
  recv(socket, data, sizeof(data), 0);
  consume("recv_control", data); // EXPECT: tracked
  consume("source_control", source_bytes()); // EXPECT: tracked
  consume("literal_control", "constant"); // EXPECT: untracked
}
