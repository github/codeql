
int ymlSource();
void ymlSink(int value);
int ymlStep(int value);

void test() {
	int x = ymlSource();

	ymlSink(0);

	ymlSink(x); // $ MISSING: ir

	int y = ymlStep(x);

	ymlSink(y); // $ MISSING: ir
}
