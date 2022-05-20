

// --- standard library ---

typedef unsigned int size_t;

void *memset(void *buffer, int data, size_t num);



typedef enum {
  kind_error,
  kind_warning,
  //...
  kind_last
} Kind;

typedef unsigned char ArrayElement;
typedef ArrayElement ThingArray[(int)kind_last+1];

#define memzero(dest, nbytes) memset(dest, 0, nbytes)
#define clear_array(array) memzero((char *)(array), sizeof(array))

ThingArray things;

typedef long double FloatValue;

// --- test cases ---

void extractor_tests()
{
	// case one (IV-24322)
	clear_array(things); // GOOD

	// simplified case one
	{
		unsigned char myArray[100];

		memset((char *)myArray, 0, sizeof(myArray)); // GOOD
			// note that char and unsigned char have the same size, and even if they didn't, any
			// cast in this location wouldn't matter.  It's not particularly clean, a cast to
			// (void *) or no cast at all would have been better.
	}

	// case two (IV-23788)
	{
		FloatValue	temp;

		memzero((char *)&temp, sizeof(FloatValue)); // GOOD
	}
}
