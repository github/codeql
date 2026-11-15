// Compile/extract only. Test C++ callback registration against the C API.
#ifdef LIBEVENT_REAL_HEADERS
#include <event2/http.h>
#include <event2/buffer.h>
#else
#include "libevent.h"
#endif

extern "C" void consume(const char *label, const char *data);
using Callback = void (*)(evhttp_request *, void *);

static const char *forwarded_uri(evhttp_request *req) {
  return evhttp_request_get_uri(req);
}

static void named_specific(evhttp_request *req, void *context) {
  consume("cpp_pointer_uri", evhttp_request_get_uri(req)); // EXPECT: tracked
  consume("cpp_pointer_context", static_cast<const char *>(context)); // EXPECT: untracked
}

static void named_generic(evhttp_request *req, void *) {
  evbuffer *input = evhttp_request_get_input_buffer(req);
  consume("cpp_pointer_pullup", reinterpret_cast<const char *>(evbuffer_pullup(input, -1))); // EXPECT: tracked
  char data[32];
  evbuffer_remove(input, data, sizeof(data));
  consume("cpp_pointer_remove", data); // EXPECT: tracked
  evbuffer *output = evhttp_request_get_output_buffer(req);
  evbuffer_add(output, "local", 5);
  consume("cpp_pointer_output", reinterpret_cast<const char *>(evbuffer_pullup(output, -1))); // EXPECT: untracked
}

static void unregistered_pointer_target(evhttp_request *, void *);

void install_cpp_function_pointers(evhttp *server) {
  Callback specific = &unregistered_pointer_target;
  specific = &named_specific; // The overwritten target must not become a server source.
  Callback alias = specific;
  evhttp_set_cb(server, "/pointer", alias, nullptr);
  auto generic = &named_generic;
  evhttp_set_gencb(server, generic, nullptr);
}

void install_cpp_direct_lambdas(evhttp *server) {
  evhttp_set_cb(server, "/lambda", [](evhttp_request *req, void *context) {
    consume("cpp_lambda_uri", evhttp_request_get_uri(req)); // EXPECT: tracked
    consume("cpp_lambda_forwarded_uri", forwarded_uri(req)); // EXPECT: tracked
    consume("cpp_lambda_context", static_cast<const char *>(context)); // EXPECT: untracked
    evhttp_request *local = evhttp_request_new(nullptr, nullptr);
    consume("cpp_lambda_local_request", evhttp_request_get_uri(local)); // EXPECT: untracked
    evhttp_request_free(local);
  }, nullptr);
  evhttp_set_gencb(server, [](evhttp_request *req, void *) {
    char data[32];
    evbuffer_remove(evhttp_request_get_input_buffer(req), data, sizeof(data));
    consume("cpp_lambda_remove", data); // EXPECT: tracked
    evbuffer *local = evbuffer_new();
    evbuffer_add(local, "constant", 8);
    consume("cpp_lambda_local_buffer", reinterpret_cast<const char *>(evbuffer_pullup(local, -1))); // EXPECT: untracked
    evbuffer_free(local);
  }, nullptr);
}

void install_cpp_lambda_pointer(evhttp *server) {
  Callback callback = +[](evhttp_request *req, void *) {
    consume("cpp_lambda_pointer_uri", evhttp_request_get_uri(req)); // EXPECT: tracked
    consume("cpp_lambda_pointer_pullup", reinterpret_cast<const char *>(evbuffer_pullup(evhttp_request_get_input_buffer(req), -1))); // EXPECT: tracked
  };
  Callback alias = callback;
  callback = nullptr; // The copied pointer still refers to the lambda.
  evhttp_set_cb(server, "/lambda-pointer", alias, nullptr);
}

static void unregistered_pointer_target(evhttp_request *req, void *) {
  consume("cpp_unregistered_pointer", evhttp_request_get_uri(req)); // EXPECT: untracked
}

void cpp_unregistered_callbacks(void) {
  evhttp_request *local = evhttp_request_new(nullptr, nullptr);
  auto callback = +[](evhttp_request *req, void *) {
    consume("cpp_unregistered_lambda", evhttp_request_get_uri(req)); // EXPECT: untracked
  };
  callback(local, nullptr);
  Callback pointer = &unregistered_pointer_target;
  pointer(local, nullptr);
  evhttp_request_free(local);
}

void cpp_client_callback(void) {
  evhttp_request *local = evhttp_request_new([](evhttp_request *req, void *) {
    consume("cpp_client_lambda_not_modeled", evhttp_request_get_uri(req)); // EXPECT: untracked
  }, nullptr);
  evhttp_request_free(local);
}
