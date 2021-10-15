// tests2.cpp

typedef unsigned int size_t;

size_t strlen(const char *str);
size_t wcslen(const wchar_t *wcs);

char *strcpy(char *destination, const char *source);
wchar_t *wcscpy(wchar_t *strDestination, const wchar_t *strSource);

char *strcat(char *destination, const char *source);
wchar_t *wcscat(wchar_t *strDestination, const wchar_t *strSource);

void *malloc(size_t size);
void *calloc(size_t num, size_t size);
void *realloc(void* ptr, size_t size);
void free(void *ptr);

void tests2(int case_num)
{
	const char *str1 = "abc";
	const char *str2 = "def";
	const char *str3 = "ghi";
	const wchar_t *wstr1 = L"12345";
	const wchar_t *wstr2 = L"67890";
	char *buffer = 0;
	wchar_t *wbuffer = 0;

	switch (case_num)
	{
		case 1:
			buffer = (char *)malloc(strlen(str1) + 1); // BAD
			strcpy(buffer, str1);
			strcat(buffer, str2);
			break;

		case 2:
			buffer = (char *)malloc(strlen(str1) + strlen(str2)); // BAD [NOT DETECTED]
			strcpy(buffer, str1);
			strcat(buffer, str2);
			break;

		case 3:
			buffer = (char *)malloc(strlen(str1) + strlen(str2) + 1); // GOOD
			strcpy(buffer, str1);
			strcat(buffer, str2);
			break;

		case 4:
			buffer = (char *)malloc((strlen(str1) + 1) * sizeof(char)); // BAD
			strcpy(buffer, str1);
			strcat(buffer, str2);
			break;

		case 5:
			buffer = (char *)malloc((strlen(str1) + strlen(str2)) * sizeof(char)); // BAD [NOT DETECTED]
			strcpy(buffer, str1);
			strcat(buffer, str2);
			break;

		case 6:
			buffer = (char *)malloc((strlen(str1) + strlen(str2) + 1) * sizeof(char)); // GOOD
			strcpy(buffer, str1);
			strcat(buffer, str2);
			break;

		case 7:
			buffer = (char *)malloc((strlen(str1) + strlen(str2) + 1) * sizeof(char)); // BAD [NOT DETECTED]
			strcpy(buffer, str1);
			strcat(buffer, str2);
			strcat(buffer, str3);
			break;

		case 8:
			buffer = (char *)malloc((strlen(str1) + strlen(str2) + strlen(str3) + 1) * sizeof(char)); // GOOD
			strcpy(buffer, str1);
			strcat(buffer, str2);
			strcat(buffer, str3);
			break;

		case 101:
			wbuffer = (wchar_t *)malloc((wcslen(wstr1) + 1) * sizeof(wchar_t)); // BAD [NOT DETECTED]
			wcscpy(wbuffer, wstr1);
			wcscat(wbuffer, wstr2);
			break;
		
		case 102:
			wbuffer = (wchar_t *)malloc((wcslen(wstr1) + wcslen(wstr2)) * sizeof(wchar_t)); // BAD [NOT DETECTED]
			wcscpy(wbuffer, wstr1);
			wcscat(wbuffer, wstr2);
			break;
			
		case 103:
			wbuffer = (wchar_t *)malloc((wcslen(wstr1) + wcslen(wstr2) + 1) * sizeof(wchar_t)); // GOOD
			wcscpy(wbuffer, wstr1);
			wcscat(wbuffer, wstr2);
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
