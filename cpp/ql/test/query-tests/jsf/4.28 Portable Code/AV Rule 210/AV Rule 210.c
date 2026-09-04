
union myUnion1 { // $ Alert // BAD
	int asInt;
	char asChar[4];
};

union myUnion2 { // GOOD
	int asInt;
	char *string;
};

union myUnion3 { // GOOD
	char myChar;
	int arrInt[4];
};

void test1(int *myIntPtr)
{
	short *myShortPtr = (short *)myIntPtr; // $ Alert // BAD
	long long *myLongPtr = (long long *)myIntPtr; // $ Alert // BAD

	int myArray[10];
	myIntPtr = (int *)myArray; // GOOD
	myShortPtr = (short *)myArray; // $ Alert // BAD [BUT DOUBLY REPORTED]

	return 0;
}

union myUnion4 { // $ SPURIOUS: Alert // GOOD? [FALSE POSITIVE]
	char myChar;
	int myInt;
};
