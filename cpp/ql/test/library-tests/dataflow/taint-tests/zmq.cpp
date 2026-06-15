
int source();
void sink(...);

// --- ZMC networking library ---

typedef unsigned long size_t;

struct zmq_msg_t {
  // ...
};
typedef void (*zmq_free_fn)();

int zmq_msg_init_data(zmq_msg_t *msg, void *data, size_t size, zmq_free_fn *ffn, void *hint);
void *zmq_msg_data(zmq_msg_t *msg);

void test_zmc(void *socket, char *message_data, size_t message_len) {
  zmq_msg_t message;

  if (zmq_msg_init_data(&message, message_data, message_len, 0, 0)) {
    sink(message); // $ SPURIOUS: ast
    sink(zmq_msg_data(&message));
  }

  message_data[0] = source();
  sink(message_data); // $ ast,ir

  if (zmq_msg_init_data(&message, message_data, message_len, 0, 0)) {
    sink(message); // $ ast,ir
    sink(zmq_msg_data(&message)); // $ ir MISSING: ast
  }
}
