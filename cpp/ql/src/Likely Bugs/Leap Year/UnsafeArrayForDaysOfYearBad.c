int items[365];
items[dayOfYear - 1] = x; // buffer overflow on December 31st of any leap year 