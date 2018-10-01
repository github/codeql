
int main(int argc, char* argv[]) {
	char param[SIZE];

	char arg1[10];
	char arg2[20];

	//wrong: only uses the size of the source (argv[1]) when using strncpy
	strncpy(param, argv[1], strlen(arg1));

	//correct: uses the size of the destination array as well
	strncpy(param, argv[1], min(strlen(arg1, sizeof(param) -1)));
}
