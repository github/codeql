int main(int argc, char* argv[]) {
	FILE *fp = fopen("foo.txt", "w");
	int status = 0;
	... //code that does not close fp
	return status; //fp is never closed
}
