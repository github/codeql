template <class T>
class vector {
private:
	T _x;
public:
	vector(int size)
	{
	}

	T& operator[](int idx) { return _x; }
	const T& operator[](int idx) const { return _x; }
};

void ArrayOfDays_Bug(int dayOfYear, int x)
{
	// BUG
	int items[365]; // $ Alert

	items[dayOfYear - 1] = x;
}

void ArrayOfDays_Bug2(int dayOfYear, int x)
{
	// BUG
	int *items = new int[365]; // $ Alert

	items[dayOfYear - 1] = x;
	delete items;
}


void ArrayOfDays_Correct(unsigned long year, int dayOfYear, int x)
{
	bool isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
	int *items = new int[isLeapYear ? 366 : 365];

	items[dayOfYear - 1] = x;

	delete[] items;
}

void ArrayOfDays_FalsePositive(int dayOfYear, int x)
{
	int items[366];

	items[dayOfYear - 1] = x;
}

void VectorOfDays_Bug(int dayOfYear, int x)
{
	// BUG
	vector<int> items(365); // $ Alert

	items[dayOfYear - 1] = x;
}

void VectorOfDays_Correct(unsigned long year, int dayOfYear, int x)
{
	bool isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
	vector<int> items(isLeapYear ? 366 : 365);

	items[dayOfYear - 1] = x;
}

void VectorOfDays_FalsePositive(int dayOfYear, int x)
{
	vector<int> items(366);

	items[dayOfYear - 1] = x;
}

void f_______________________________________________________this_name_must_be_exactly_357_chars__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________() {
  // Using this magic compiler variable results in a `const char` array being
  // initialized with the function name which (including `void`, a space,
  // and `()`). in this case, this adds up to exactly 364 characters.
  // The initializer for `__PRETTY_FUNCTION__` thus initializes an array of
  // length 365 (because the null-terminator adds another character).
  auto x = __PRETTY_FUNCTION__; // $ SPURIOUS: Alert
}