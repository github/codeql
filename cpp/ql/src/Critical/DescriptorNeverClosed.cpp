int main(int argc, char* argv[]) {
	int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	int status = 0;
	... //code that does not close sockfd
	return status; //sockfd is never closed
}
