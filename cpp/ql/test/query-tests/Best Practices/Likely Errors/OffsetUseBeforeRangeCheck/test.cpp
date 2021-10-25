
void test(char *buffer, int bufferSize)
{
	int i;

	// skip whitespace
	i = 0;
	while ((i < bufferSize) && (buffer[i] == ' ')) { i++; } // GOOD

	i = 0;
	while ((buffer[i] == ' ') && (i < bufferSize)) { i++; } // BAD

	// check for 'x'
	if ((i < bufferSize) && (buffer[i] == 'x')) {} // GOOD
	if ((buffer[i] == 'x') && (i < bufferSize)) {} // BAD

	if ((bufferSize > i) && (buffer[i] == 'x')) {} // GOOD
	if ((buffer[i] == 'x') && (bufferSize > i)) {} // BAD [NOT DETECTED]

	if ((i <= bufferSize - 1) && (buffer[i] == 'x')) {} // GOOD
	if ((buffer[i] == 'x') && (i <= bufferSize - 1)) {} // BAD [NOT DETECTED]

	if ((bufferSize >= i + 1) && (buffer[i] == 'x')) {} // GOOD
	if ((buffer[i] == 'x') && (bufferSize >= i + 1)) {} // BAD [NOT DETECTED]

	if ((i < bufferSize) && (true) && (buffer[i] == 'x')) {} // GOOD
	if ((buffer[i] == 'x') && (true) && (i < bufferSize)) {} // BAD

	if ((i < bufferSize - 1) && (buffer[i + 1] == 'x')) {} // GOOD
	if ((buffer[i + 1] == 'x') && (i < bufferSize - 1)) {} // BAD [NOT DETECTED]

	if ((i < bufferSize) && (buffer[i] == 'x') && (i < bufferSize - 1)) {} // GOOD
	if ((i < bufferSize) && ((buffer[i] == 'x') && (i < bufferSize - 1))) {} // GOOD
	if ((i < bufferSize + 1) && (buffer[i] == 'x') && (i < bufferSize)) {} // BAD [NOT DETECTED]
	if ((i < bufferSize + 1) && ((buffer[i] == 'x') && (i < bufferSize))) {} // BAD [NOT DETECTED]

	// look for 'ab'
	for (i = 0; i < bufferSize; i++) {
		if ((buffer[i] == 'a') && (i < bufferSize - 1) && (buffer[i + 1] == 'b')) // GOOD [FALSE POSITIVE]
			break;
	}

	if ((i < bufferSize) && (buffer[i])) {} // GOOD
	if ((buffer[i]) && (i < bufferSize)) {} // BAD

	if ((i < bufferSize) && (buffer[i] + 1 == 'x')) {} // GOOD
	if ((buffer[i] + 1 == 'x') && (i < bufferSize)) {} // BAD

	if ((buffer != 0) && (i < bufferSize)) {} // GOOD
}
