
int ymlSource();
void ymlSink(int value);
int ymlStepManual(int value);
int ymlStepGenerated(int value);
int ymlStepManual_with_body(int value1, int value2) { return value2; }
int ymlStepGenerated_with_body(int value, int value2) { return value2; }

void test() {
	int x = ymlSource();

	ymlSink(0);

	ymlSink(x); // $ ir

	// ymlStepManual is manually modeled so we should always use the model
	int y = ymlStepManual(x);
	ymlSink(y); // $ ir

	// ymlStepGenerated is modeled by the model generator so we should use the model only if there is no body
	int z = ymlStepGenerated(x);
	ymlSink(z); // $ ir

	// ymlStepManual_with_body is manually modeled so we should always use the model
	int y2 = ymlStepManual_with_body(x, 0);
	ymlSink(y2); // $ ir

	int y3 = ymlStepManual_with_body(0, x);
	ymlSink(y3); // clean

	// ymlStepGenerated_with_body is modeled by the model generator so we should use the model only if there is no body
	int z2 = ymlStepGenerated_with_body(0, x);
	ymlSink(z2); // $ ir

	int z3 = ymlStepGenerated_with_body(x, 0);
	ymlSink(z3); // clean
}
