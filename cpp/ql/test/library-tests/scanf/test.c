/** standard printf functions */

#define FILE void
typedef unsigned int wchar_t;

int scanf(const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sscanf(const char *s, const char *format, ...);
int swscanf(const wchar_t* ws, const wchar_t* format, ...);
int scanf_s(const char *format, ...);

int main(int argc, char *argv[])
{
	char buffer[256];
	wchar_t wbuffer[256];
	FILE *file;
	int i, i2;

	scanf("%s", buffer);
	fscanf(file, "%10s %i", buffer, i);
	sscanf("Hello.", "%*i%s%*s", buffer);
	swscanf(L"Hello.", "%10s", wbuffer);
	scanf_s("%d %s %d", &i, buffer, 10, &i2);

	return 0;
}