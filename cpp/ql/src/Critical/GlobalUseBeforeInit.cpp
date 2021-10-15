int g_callCtr;

void initGlobals() {
	g_callCtr = 0;
}

int main(int argc, char* argv[]) {
	...
	cout << g_callCtr; //callCtr used before it is initialized
	initGlobals();
}
