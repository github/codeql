int main(int argc, char* argv[]) {
	int *buff = malloc(SIZE * sizeof(int));
	int status = 0;
	... //code that does not free buff
	return status; //buff is never closed
}
