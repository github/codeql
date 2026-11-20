// Minimal declarations from libevent 2.1.12-stable. See README.md for provenance.
typedef unsigned long size_t;
typedef long ev_ssize_t;

#ifdef __cplusplus
extern "C" {
#endif

struct evhttp;
struct evhttp_request;
struct evbuffer;
typedef void (*request_callback)(struct evhttp_request *, void *);
int evhttp_set_cb(struct evhttp *, const char *, request_callback, void *);
void evhttp_set_gencb(struct evhttp *, request_callback, void *);
struct evhttp_request *evhttp_request_new(request_callback, void *);
void evhttp_request_free(struct evhttp_request *);
const char *evhttp_request_get_uri(const struct evhttp_request *);
struct evbuffer *evhttp_request_get_input_buffer(struct evhttp_request *);
struct evbuffer *evhttp_request_get_output_buffer(struct evhttp_request *);
struct evbuffer *evbuffer_new(void);
void evbuffer_free(struct evbuffer *);
int evbuffer_add(struct evbuffer *, const void *, size_t);
unsigned char *evbuffer_pullup(struct evbuffer *, ev_ssize_t);
int evbuffer_remove(struct evbuffer *, void *, size_t);

#ifdef __cplusplus
}
#endif
