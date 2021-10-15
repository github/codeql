/** standard printf functions */

#define FILE void
typedef unsigned int wchar_t;

int scanf(const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sscanf(const char *s, const char *format, ...);
int swscanf(const wchar_t* ws, const wchar_t* format, ...);

int main(int argc, char *argv[])
{
	char buffer[256];
	wchar_t wbuffer[256];
	FILE *file;
	int i;

	scanf("%s", buffer);
	fscanf(file, "%10s %i", buffer, i);
	sscanf("Hello.", "%*i%s%*s", buffer);
	swscanf(L"Hello.", "%10s", wbuffer);

	return 0;
}