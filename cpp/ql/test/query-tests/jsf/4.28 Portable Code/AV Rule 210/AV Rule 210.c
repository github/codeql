
union myUnion1 { // BAD
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
	short *myShortPtr = (short *)myIntPtr; // BAD
	long long *myLongPtr = (long long *)myIntPtr; // BAD

	int myArray[10];
	myIntPtr = (int *)myArray; // GOOD
	myShortPtr = (short *)myArray; // BAD [BUT DOUBLY REPORTED]

	return 0;
}

union myUnion4 { // GOOD? [FALSE POSITIVE]
	char myChar;
	int myInt;
};
