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

/**
 * AntiPattern 4 - Static allocation of 365 array items
*/
void ArrayOfDays_Bug(int dayOfYear, int x)
{
	// BUG
	int items[365];

	items[dayOfYear - 1] = x;
}

/**
 * AntiPattern 4 - Static allocation of 365 array items
*/
void ArrayOfDays_Bug2(int dayOfYear, int x)
{
	// BUG
	int *items = new int[365];

	items[dayOfYear - 1] = x;
	delete items;
}

/**
 * True Negative
 * Correct conditional allocation of array length
*/
void ArrayOfDays_Correct(unsigned long year, int dayOfYear, int x)
{
	bool isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
	int *items = new int[isLeapYear ? 366 : 365];

	items[dayOfYear - 1] = x;

	delete[] items;
}

/**
 * True Negative
 * Allocation of 366 items (Irregardless of common or leap year)
*/
void ArrayOfDays_FalsePositive(int dayOfYear, int x)
{
	int items[366];

	items[dayOfYear - 1] = x;
}

/**
 * AntiPattern 4 - Static allocation of 365 array items
*/
void VectorOfDays_Bug(int dayOfYear, int x)
{
	// BUG
	vector<int> items(365);

	items[dayOfYear - 1] = x;
}

/**
 * True Negative
 * Conditional quantity allocation on the basis of common or leap year 
*/
void VectorOfDays_Correct(unsigned long year, int dayOfYear, int x)
{
	bool isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
	vector<int> items(isLeapYear ? 366 : 365);

	items[dayOfYear - 1] = x;
}

/**
 * True Negative
 * Allocation of 366 items (Irregardless of common or leap year)
*/
void VectorOfDays_FalsePositive(int dayOfYear, int x)
{
	vector<int> items(366);

	items[dayOfYear - 1] = x;
}

/**
 * AntiPattern 4 - Static allocation of 365 array items
*/
void HandleBothCases(int dayOfYear, int x)
{
	vector<int> items(365);
	vector<int> items_leap(366);

	items[dayOfYear - 1] = x; // BUG
}

/**
 * AntiPattern 4 - Static allocation of 365 array items
*/
void HandleBothCases2(int dayOfYear, int x)
{
	int items[365];
	int items_leap[366];

	char items_bad[365]; 	// BUG

	items[dayOfYear - 1] = x; // BUG
}

const short LeapYearDayToMonth[366] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // January
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,        // February
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  // March
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,     // April
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,  // May
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,     // June
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,  // July
    7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,  // August
    8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,     // September
    9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,  // October
    10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,     // November
    11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11}; // December

/* Negative - #947 Sibling definition above*/
const short NormalYearDayToMonth[365] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // January
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,           // February
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  // March
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,     // April
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,  // May
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,     // June
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,  // July
    7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,  // August
    8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,     // September
    9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,  // October
    10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,     // November
    11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11}; // December