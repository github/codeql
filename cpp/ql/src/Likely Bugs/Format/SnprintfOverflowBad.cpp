#define BUF_SIZE (32)

int main(int argc, char *argv[])
{
	char buffer[BUF_SIZE];
	size_t pos = 0;
	int i;

	for (i = 0; i < argc; i++)
	{
		pos += snprintf(buffer + pos, BUF_SIZE - pos, "%s", argv[i]);
			// BUF_SIZE - pos may overflow
	}
}
