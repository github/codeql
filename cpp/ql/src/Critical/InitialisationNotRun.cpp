GlobalStorage *g_storage;

void init() { //initializes g_storage, but is never run from main
	g_storage = new GlobalStorage();
	...
}

int main(int argc, char *argv[]) {
	... //init not called
	strcpy(g_storage->name, argv[1]); // g_storage is used before init() is called
	...
}
