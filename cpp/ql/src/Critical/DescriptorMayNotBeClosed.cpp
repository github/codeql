int f() {
	try {
		int sockfd = socket(AF_INET, SOCK_STREAM, 0);
		do_stuff(sockfd);
		return sockfd; //if there are no exceptions, the socket is returned
	} catch (int do_stuff_exception) {
		return -1; //return error value, but sockfd may still be open
	}
}
