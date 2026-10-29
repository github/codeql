int main(int argc, char *argv[])
{
	char *str1, *str2, *str3, *result;
	int cond1, cond2, cond3, cond4;

	str1 = "1";
	str2 = "22";
	str3 = "333";

	result = str1; // max length 1
	if (cond1)
	{
		result = (cond2 ? str2 : str3); // max length 3
	}
	result = (cond3 ? str1 : result); // max length 3
	result = (cond4 ? str1 : argv[0]); // max unknown

	return 0;
}

namespace std
{
	class string
	{
	public:
		string(char *_str) : str(_str) {};
		~string() {};

		string &operator=(string &other) {
			str = other.str;
		};

	private:
		char *str;
	};
}

void more_cases()
{
	wchar_t *wstr1 = L"4444";
	wchar_t *wstr2 = wstr1;
	std::string str1 = "666666";
	std::string str2 = str1;
}
