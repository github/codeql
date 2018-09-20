WCHAR szBuffer[8];
LPWSTR pSrc;

pSrc = (LPWSTR)"a";		// Casting a const char * to LPWSTR 
wcscpy(szBuffer, pSrc);