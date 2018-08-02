#define BUF_SIZE (32)

int main(int argc, char *argv[])
{
	char buffer[BUF_SIZE];
	size_t pos = 0;
	int i;

	for (i = 0; i < argc; i++)
	{
		int n = snprintf(buffer + pos, BUF_SIZE - pos, "%s", argv[i]);
		if (n < 0 || n >= BUF_SIZE - pos)
		{
			break;
		}
		pos += n;
	}
}
