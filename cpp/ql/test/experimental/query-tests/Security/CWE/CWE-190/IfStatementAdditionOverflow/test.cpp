
int getAnInt();
double getADouble();
unsigned short getAnUnsignedShort();

void test()
{
	int a = getAnInt();
	int b = getAnInt();
	int c = getAnInt();
	int x = getAnInt();
	int y = getAnInt();
	double d = getADouble();
	unsigned short a1 = getAnUnsignedShort();
	unsigned short b1 = getAnUnsignedShort();
	unsigned short c1 = getAnUnsignedShort();

	if (a+b>c) a = c-b; // BAD
	if (a+b>c) { a = c-b; } // BAD
	if (b+a>c) a = c-b; // BAD
	if (b+a>c) { a = c-b; } // BAD
	if (c>a+b) a = c-b; // BAD
	if (c>a+b) { a = c-b; } // BAD
	if (c>b+a) a = c-b; // BAD
	if (c>b+a) { a = c-b; } // BAD

	if (a+b>=c) a = c-b; // BAD
	if (a+b>=c) { a = c-b; } // BAD
	if (b+a>=c) a = c-b; // BAD
	if (b+a>=c) { a = c-b; } // BAD
	if (c>=a+b) a = c-b; // BAD
	if (c>=a+b) { a = c-b; } // BAD
	if (c>=b+a) a = c-b; // BAD
	if (c>=b+a) { a = c-b; } // BAD

	if (a+b<c) a = c-b; // BAD
	if (a+b<c) { a = c-b; } // BAD
	if (b+a<c) a = c-b; // BAD
	if (b+a<c) { a = c-b; } // BAD
	if (c<a+b) a = c-b; // BAD
	if (c<a+b) { a = c-b; } // BAD
	if (c<b+a) a = c-b; // BAD
	if (c<b+a) { a = c-b; } // BAD

	if (a+b<=c) a = c-b; // BAD
	if (a+b<=c) { a = c-b; } // BAD
	if (b+a<=c) a = c-b; // BAD
	if (b+a<=c) { a = c-b; } // BAD
	if (c<=a+b) a = c-b; // BAD
	if (c<=a+b) { a = c-b; } // BAD
	if (c<=b+a) a = c-b; // BAD
	if (c<=b+a) { a = c-b; } // BAD

	if (a+b>d) a = d-b; // BAD
	if (a+(double)b>c) a = c-b; // GOOD
	if (a+(-x)>c) a = c-(-y); // GOOD
	if (a+b>c) { b++; a = c-b; } // GOOD
	if (a+d>c) a = c-d; // GOOD
	if (a1+b1>c1) a1 = c1-b1; // GOOD
	
	if (a+b<=c) { /* ... */ } else { a = c-b; } // BAD
	if (a+b<=c) { return; } a = c-b; // BAD
}
