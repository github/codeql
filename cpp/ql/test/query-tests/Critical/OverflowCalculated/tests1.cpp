// tests1.cpp

typedef unsigned int size_t;

size_t strlen(const char *str);
size_t wcslen(const wchar_t *wcs);

char *strcpy(char *destination, const char *source);
wchar_t *wcscpy(wchar_t *strDestination, const wchar_t *strSource);

void *malloc(size_t size);
void *calloc(size_t num, size_t size);
void *realloc(void* ptr, size_t size);
void free(void *ptr);

void tests1(int case_num)
{
	const char *str = "abc";
	const wchar_t *wstr = L"12345";
	char *buffer = 0;
	wchar_t *wbuffer = 0;

	switch (case_num)
	{
		case 1:
			buffer = (char *)malloc(strlen(str)); // BAD
			strcpy(buffer, str);
			break;

		case 2:
			buffer = (char *)malloc(strlen(str) + 1); // GOOD
			strcpy(buffer, str);
			break;

		case 3:
			buffer = (char *)malloc(strlen(str) * sizeof(char)); // BAD
			strcpy(buffer, str);
			break;

		case 4:
			buffer = (char *)malloc((strlen(str) + 1) * sizeof(char)); // GOOD
			strcpy(buffer, str);
			break;

		case 5:
			buffer = (char *)calloc(strlen(str), sizeof(char)); // BAD [NOT DETECTED]
			strcpy(buffer, str);
			break;

		case 6:
			buffer = (char *)calloc(strlen(str) + 1, sizeof(char)); // GOOD
			strcpy(buffer, str);
			break;

		case 7:
			buffer = (char *)realloc(buffer, strlen(str)); // BAD
			strcpy(buffer, str);
			break;

		case 8:
			buffer = (char *)realloc(buffer, strlen(str) + 1); // GOOD
			strcpy(buffer, str);
			break;

		case 9:
			int len1 = strlen(str);
			buffer = (char *)malloc(len1); // BAD
			strcpy(buffer, str);
			break;

		case 10:
			int len2 = strlen(str) + 1;
			buffer = (char *)malloc(len2); // GOOD
			strcpy(buffer, str);
			break;

		case 11:
			int len3 = strlen(str);
			buffer = (char *)malloc(len3 + 1); // GOOD
			strcpy(buffer, str);
			break;

		case 12:
			buffer = (char *)malloc(strlen(str) + 0); // BAD [NOT DETECTED]
			strcpy(buffer, str);
			break;

		case 101:
			wbuffer = (wchar_t *)malloc(wcslen(wstr)); // BAD
			wcscpy(wbuffer, wstr);
			break;

		case 102:
			wbuffer = (wchar_t *)malloc(wcslen(wstr) + 1); // BAD (no sizeof) [NOT DETECTED]
			wcscpy(wbuffer, wstr);
			break;

		case 103:
			wbuffer = (wchar_t *)calloc(wcslen(wstr), sizeof(char)); // BAD [NOT DETECTED]
			wcscpy(wbuffer, wstr);
			break;

		case 104:
			wbuffer = (wchar_t *)calloc(wcslen(wstr) + 1, sizeof(char)); // BAD (wrong sizeof) [NOT DETECTED]
			wcscpy(wbuffer, wstr);
			break;

		case 105:
			wbuffer = (wchar_t *)malloc(wcslen(wstr) * sizeof(wchar_t)); // BAD
			wcscpy(wbuffer, wstr);
			break;

		case 106:
			wbuffer = (wchar_t *)malloc((wcslen(wstr) + 1) * sizeof(wchar_t)); // GOOD
			wcscpy(wbuffer, wstr);
			break;

		case 107:
			wbuffer = (wchar_t *)calloc(wcslen(wstr), sizeof(wchar_t)); // BAD [NOT DETECTED]
			wcscpy(wbuffer, wstr);
			break;

		case 108:
			wbuffer = (wchar_t *)calloc(wcslen(wstr) + 1, sizeof(wchar_t)); // GOOD
			wcscpy(wbuffer, wstr);
			break;
	}
	
	if (buffer != 0)
	{
		free(buffer);
	}
	if (wbuffer != 0)
	{
		free(wbuffer);
	}
}
