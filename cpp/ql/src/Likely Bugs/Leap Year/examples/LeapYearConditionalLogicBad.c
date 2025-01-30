// Checking for leap year
bool isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
if (isLeapYear)
{
    // untested path
}
else
{
    // tested path
}


// Checking specifically for the leap day
if (month == 2 && day == 29)  // (or 1 with a tm_mon value)
{
    // untested path
}
else
{
    // tested path
}