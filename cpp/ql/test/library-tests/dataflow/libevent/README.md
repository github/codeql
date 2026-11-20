# libevent model tests

The lightweight declarations in `libevent.h` follow libevent 2.1.12-stable
(`5df3037d10556bfcb675bc73e516978b75fc7bc7`), in particular
`include/event2/http.h` and `include/event2/buffer.h`. The test aliases describe
the default Linux target. `LIBEVENT_REAL_HEADERS` allows the same consumers to
be compiled separately against real, platform-configured libevent headers.
No libevent implementation or unsafe consumer is executed by these tests.

`flow.ql` tests server request sources established by `evhttp_set_cb` and
`evhttp_set_gencb`, request-to-URI/input-buffer summaries, and evbuffer taint
propagation. Positive controls also use explicit source bytes and `recv`.
Negative cases cover local requests, unregistered callbacks, local and output
buffers, a separate buffer, callback context, literals, and numeric results.

`callbacks.cpp` adds C++11 captureless lambdas, named function pointers,
pointer copies, address-of/unary-plus wrappers, and overwritten pointer
controls. These use the C API declarations, including C language linkage.

`ExecTainted.qlref` runs the existing command-injection query on URI, pullup,
and remove paths followed by command concatenation. Local requests and local
buffers must not introduce remote-source alerts.

The initial source scope is HTTP server callbacks. A callback supplied to
`evhttp_request_new` is not modeled as a server source; this does not imply
that client responses are trusted. Summaries are length-insensitive and
conservative across success/failure. They do not model draining, overwrites,
or general libevent callback lifecycles. A handler registered as a server
callback is treated as receiving remote request content even if it can also
be invoked directly by application code.
