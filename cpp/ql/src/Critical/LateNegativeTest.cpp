Record records[SIZE] = ...;

int f() {
	int recordIdx = 0;
	cin >> recordIdx;
	printRecord(&(records[recordIdx])); //incorrect: recordIdx may be negative here

	if (recordIdx >= 0) {
		processRecord(&(records[recordIdx])); //correct: index checked before use
	}
}
