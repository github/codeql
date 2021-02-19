void sink(...);
int source();

// --- accept ---

struct sockaddr {
	unsigned char length;
	int sa_family;
	char* sa_data;
};

int accept(int, const sockaddr*, int*);

void sink(sockaddr);

void test_accept() {
  int s = source();
  sockaddr addr;
  int size = sizeof(sockaddr);
  int a = accept(s, &addr, &size);

  sink(a); // $ ast=17:11 SPURIOUS: ast=18:12 MISSING: ir
  sink(addr); // $ ast MISSING: ir
}

// --- poll ---

struct pollfd {
  int   fd;
  short events;
  short revents;
};

int poll(struct pollfd *, int, int);

void test_poll() {
  pollfd pfds;

  pfds.events = 1;
  pfds.fd = source();
  poll(&pfds, 1, -1);

  sink(pfds); // $ ast MISSING: ir
}

// --- select ---

typedef struct {} timeval;

typedef struct fd_set {
  int  fd_count;
  int fd_array[4096];
} fd_set;

int select(int, fd_set *, fd_set *, fd_set *, timeval *);

void test_select(timeval timeout) {
  fd_set readfds;

  readfds.fd_count = 1;
  readfds.fd_array[0] = source();
  select(2, &readfds, nullptr, nullptr, &timeout);
  sink(&readfds); // $ ast MISSING: ir
}