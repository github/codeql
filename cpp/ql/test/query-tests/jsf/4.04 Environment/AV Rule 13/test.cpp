
int main()
{
	const char *const_str = "";
	const wchar_t *const_wstr = L""; // $ Alert // BAD
	char c = 'c';
	wchar_t wc = L'c'; // $ Alert // BAD

	return 0;
}
