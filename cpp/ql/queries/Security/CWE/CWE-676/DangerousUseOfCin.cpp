#define BUFFER_SIZE 20

void bad()
{
	char buffer[BUFFER_SIZE];
	// BAD: Use of 'cin' without specifying the length of the input.
	cin >> buffer;
	buffer[BUFFER_SIZE-1] = '\0';
}

void good()
{
	char buffer[BUFFER_SIZE];
	// GOOD: Specifying the length of the input before using 'cin'.
	cin.width(BUFFER_SIZE);
	cin >> buffer;
	buffer[BUFFER_SIZE-1] = '\0';
}
