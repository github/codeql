
typedef unsigned long size_t;

size_t strlen(const char *s);
char *getenv(const char *name);

#define	AF_INET (2)
#define SOCK_STREAM (1)

struct sockaddr {
	int sa_family;

	// ...
};

int socket(int domain, int type, int protocol);
int connect(int socket, const struct sockaddr *address, size_t address_len);
size_t send(int socket, const void *buffer, size_t length, int flags);
int write(int handle, const void *buffer, size_t length);

void test_sockets1()
{
	int sockfd;
	sockaddr addr_remote;
	char *msg = "Hello, world!";
	char *path = getenv("PATH");

	// create socket
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0) return;

	// connect socket to a remote address
	addr_remote.sa_family = AF_INET;
	// ...
	if (connect(sockfd, &addr_remote, sizeof(addr_remote)) != 0) return;

	// send something using 'send'
	if (send(sockfd, msg, strlen(msg) + 1, 0) < 0) return; // GOOD
	if (send(sockfd, path, strlen(path) + 1, 0) < 0) return; // BAD
	
	// send something using 'write'
	if (write(sockfd, msg, strlen(msg) + 1) < 0) return; // GOOD
	if (write(sockfd, path, strlen(path) + 1) < 0) return; // BAD

	// clean up
	// ...
}

int mksocket()
{
	int fd;
	
	fd = socket(AF_INET, SOCK_STREAM, 0);
	
	return fd;
}

void test_sockets2()
{
	int sockfd;
	sockaddr addr_remote;
	char *msg = "Hello, world!";
	char *path = getenv("PATH");

	// create socket
	sockfd = mksocket();
	if (sockfd < 0) return;

	// connect socket to a remote address
	addr_remote.sa_family = AF_INET;
	// ...
	if (connect(sockfd, &addr_remote, sizeof(addr_remote)) != 0) return;

	// send something using 'send'
	if (send(sockfd, msg, strlen(msg) + 1, 0) < 0) return; // GOOD
	if (send(sockfd, path, strlen(path) + 1, 0) < 0) return; // BAD
	
	// send something using 'write'
	if (write(sockfd, msg, strlen(msg) + 1) < 0) return; // GOOD
	if (write(sockfd, path, strlen(path) + 1) < 0) return; // BAD

	// clean up
	// ...
}
