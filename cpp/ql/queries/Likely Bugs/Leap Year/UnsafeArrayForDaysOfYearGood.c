bool isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
int *items = new int[isLeapYear ? 366 : 365];
// ...
delete[] items;