
typedef unsigned int size_t;
void *memset(void *ptr, int value, size_t num);

struct myStruct
{
	int x, y;
};
typedef myStruct *myStructPtr;

struct otherStruct
{
	int a, b;
};

#define NUM (10)

int main()
{
	{
		myStruct ms;

		memset(&ms, 0, sizeof(myStruct)); // GOOD
		memset(&ms, 0, sizeof(ms)); // GOOD
		memset(&ms, 0, 8); // BAD [NOT DETECTED]
		memset(&ms, 0, sizeof(otherStruct)); // BAD
		
		{
			myStruct *msPtr = &ms;
			void *vPtr = msPtr;

			memset(&msPtr, 0, sizeof(myStruct)); // BAD
			memset(&msPtr, 0, sizeof(myStruct *)); // GOOD
			memset(&msPtr, 0, sizeof(*msPtr)); // BAD
			memset(&msPtr, 0, sizeof(msPtr)); // GOOD
			memset(msPtr, 0, sizeof(myStruct)); // GOOD
			memset(msPtr, 0, sizeof(myStruct *)); // BAD
			memset(msPtr, 0, sizeof(*msPtr)); // GOOD
			memset(msPtr, 0, sizeof(msPtr)); // BAD
			memset(vPtr, 0, sizeof(myStruct)); // GOOD
			memset(vPtr, 0, sizeof(myStruct *)); // BAD
			memset(vPtr, 0, sizeof(*msPtr)); // GOOD
			memset(vPtr, 0, sizeof(msPtr)); // BAD

			{
				myStruct **msPtrPtr = &msPtr;

				memset(&msPtrPtr, 0, sizeof(myStruct)); // BAD
				memset(&msPtrPtr, 0, sizeof(myStruct *)); // BAD
				memset(&msPtrPtr, 0, sizeof(myStruct **)); // GOOD
				memset(msPtrPtr, 0, sizeof(myStruct)); // BAD
				memset(msPtrPtr, 0, sizeof(myStruct *)); // GOOD
				memset(msPtrPtr, 0, sizeof(myStruct **)); // BAD
				memset(*msPtrPtr, 0, sizeof(myStruct)); // GOOD
				memset(*msPtrPtr, 0, sizeof(myStruct *)); // BAD
				memset(*msPtrPtr, 0, sizeof(myStruct **)); // BAD
			}
		}
	}

	{
		myStruct msArr[NUM];
		myStruct *msPtr = msArr;

		memset(&msArr, 0, sizeof(myStruct) * NUM); // GOOD
		memset(&msArr, 0, sizeof(msArr)); // GOOD
		memset(&msArr, 0, sizeof(myStruct[NUM])); // GOOD
		memset(&msArr, 0, sizeof(myStruct *)); // BAD
		memset(msArr, 0, sizeof(myStruct) * NUM); // GOOD
		memset(msArr, 0, sizeof(msArr)); // GOOD
		memset(msArr, 0, sizeof(myStruct[NUM])); // GOOD
		memset(msArr, 0, sizeof(myStruct *)); // BAD
		memset(&(msArr[0]), 0, sizeof(myStruct) * NUM); // GOOD
		memset(&(msArr[0]), 0, sizeof(msArr)); // GOOD
		memset(&(msArr[0]), 0, sizeof(myStruct[NUM])); // GOOD
		memset(&(msArr[0]), 0, sizeof(myStruct *)); // BAD
		memset(msPtr, 0, sizeof(myStruct) * NUM); // GOOD
		memset(msPtr, 0, sizeof(msArr)); // GOOD
		memset(msPtr, 0, sizeof(myStruct[NUM])); // GOOD
		memset(msPtr, 0, sizeof(myStruct *)); // BAD
	}
	
	{
		myStructPtr msPtrArr[NUM];

		memset(&msPtrArr, 0, sizeof(myStruct) * NUM); // BAD
		memset(&msPtrArr, 0, sizeof(myStruct *) * NUM); // GOOD
		memset(&msPtrArr, 0, sizeof(myStructPtr) * NUM); // GOOD
		memset(&msPtrArr, 0, sizeof(myStruct **) * NUM); // BAD
		memset(msPtrArr, 0, sizeof(myStruct) * NUM); // BAD [NOT DETECTED]
		memset(msPtrArr, 0, sizeof(myStruct *) * NUM); // GOOD
		memset(msPtrArr, 0, sizeof(myStructPtr) * NUM); // GOOD
		memset(msPtrArr, 0, sizeof(myStruct **) * NUM); // BAD
		memset(&(msPtrArr[0]), 0, sizeof(myStruct) * NUM); // BAD
		memset(&(msPtrArr[0]), 0, sizeof(myStruct *) * NUM); // GOOD
		memset(&(msPtrArr[0]), 0, sizeof(myStructPtr) * NUM); // GOOD
		memset(&(msPtrArr[0]), 0, sizeof(myStruct **) * NUM); // BAD
		memset(msPtrArr[0], 0, sizeof(myStruct) * NUM); // GOOD
		memset(msPtrArr[0], 0, sizeof(myStruct *) * NUM); // BAD
		memset(msPtrArr[0], 0, sizeof(myStructPtr) * NUM); // BAD
		memset(msPtrArr[0], 0, sizeof(myStruct **) * NUM); // BAD
	}

	{
		myStruct multiArray[10][10];

		memset(&(multiArray[0][0]), 0, sizeof(myStruct)); // GOOD
		memset(&(multiArray[0]), 0, sizeof(myStruct[10])); // GOOD
		memset(&multiArray, 0, sizeof(myStruct[10][10])); // GOOD
		memset(multiArray, 0, sizeof(myStruct) * 10 * 10); // GOOD
		memset(multiArray, 0, sizeof(multiArray)); // GOOD
		memset(&(multiArray[0][0]), 0, sizeof(multiArray)); // GOOD
	}

	return 0;
}


void myFunc(myStruct paramArray[80], myStruct &refStruct)
{
	myStruct localArray[80];
	
	memset(localArray, 0, sizeof(myStruct) * 80); // GOOD
	memset(localArray, 0, sizeof(localArray)); // GOOD
	memset(&localArray, 0, sizeof(myStruct) * 80); // GOOD
	memset(&localArray, 0, sizeof(localArray)); // GOOD

	memset(paramArray, 0, sizeof(myStruct) * 80); // GOOD
	memset(paramArray, 0, sizeof(paramArray)); // GOOD [FALSE POSITIVE]
	memset(&paramArray, 0, sizeof(myStruct) * 80); // BAD
	memset(&paramArray, 0, sizeof(paramArray)); // BAD [NOT DETECTED]

	memset(&refStruct, 0, sizeof(myStruct)); // GOOD
	memset(&refStruct, 0, sizeof(refStruct)); // GOOD
	memset(&refStruct, 0, sizeof(myStruct *)); // BAD
}

class MyClass
{
public:
	MyClass()
	{
		memset(myStructs, 0, 128 * sizeof(myStruct *)); // GOOD
	}

	const myStruct *myStructs[128];
};

typedef unsigned char u8;

void more_tests()
{
	myStruct ms;
	u8 *ptr = (u8 *)&ms;
	u8 buffer[sizeof(myStruct)];

	memset(ptr, 0, sizeof(myStruct)); // GOOD
	memset(buffer, 0, sizeof(myStruct)); // GOOD
}

typedef int intArray[77];
typedef intArray *intArrayPointer;

void more_tests_2()
{
	intArrayPointer iap;
	intArrayPointer iapa[88];

	memset(iap, 0, sizeof(intArray)); // GOOD
	memset(&iap, 0, sizeof(intArray)); // BAD
	memset(iapa, 0, sizeof(iapa)); // GOOD
	memset(iapa, 0, sizeof(intArrayPointer *)); // BAD
}

void more_tests_3()
{
	myStruct ms;
	decltype(&ms) msPtr = &ms;
	memset(msPtr, 0, sizeof(myStruct)); // GOOD
}
