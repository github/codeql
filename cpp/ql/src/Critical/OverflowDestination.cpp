
int main(int argc, char* argv[]) {
	char param[20];
	char *arg1;

	arg1 = argv[1];

	//wrong: only uses the size of the source (argv[1]) when using strncpy
	strncpy(param, arg1, strlen(arg1));

	//correct: uses the size of the destination array as well
	strncpy(param, arg1, min(strlen(arg1), sizeof(param) -1));
}
