
typedef long double MYLD;

bool getBool();
int getInt();
float getFloat();
double getDouble();
MYLD getMyLD();
float *getFloatPtr();
float &getFloatRef();
const float &getConstFloatRef();

void setPosInt(int x);
void setPosFloat(float x);

double round(double x);
float roundf(float x);

void test1()
{
	// simple

	if (getBool())
	{
		setPosInt(getBool());
		setPosFloat(getBool());
	}
	if (getInt())
	{
		setPosInt(getInt());
		setPosFloat(getInt());
	}
	if (getFloat()) // BAD
	{
		setPosInt(getFloat()); // BAD
		setPosFloat(getFloat());
	}
	if (getDouble()) // BAD
	{
		setPosInt(getDouble()); // BAD
		setPosFloat(getDouble());
	}
	if (getMyLD()) // BAD
	{
		setPosInt(getMyLD()); // BAD
		setPosFloat(getMyLD());
	}
	if (getFloatPtr())
	{
		// ...
	}
	if (getFloatRef()) // BAD [NOT DETECTED]
	{
		setPosInt(getFloatRef()); // BAD [NOT DETECTED]
		setPosFloat(getFloatRef());
	}
	if (getConstFloatRef()) // BAD [NOT DETECTED]
	{
		setPosInt(getConstFloatRef()); // BAD [NOT DETECTED]
		setPosFloat(getConstFloatRef());
	}

	// explicit cast

	if ((bool)getInt())
	{
		setPosInt(getInt());
		setPosFloat((float)getInt());
	}
	if ((bool)getFloat())
	{
		setPosInt((int)getFloat());
		setPosFloat(getFloat());
	}

	// explicit rounding

	if (roundf(getFloat()))
	{
		setPosInt(roundf(getFloat()));
		setPosFloat(roundf(getFloat()));
	}
	if (round(getDouble()))
	{
		setPosInt(round(getDouble()));
		setPosFloat(round(getDouble()));
	}
}

double pow(double x, double y);

int test2(double v, double w, int n)
{
	switch (n)
	{
	case 1:
		return pow(2, v); // GOOD
	case 2:
		return pow(10, v); // GOOD
	case 3:
		return pow(2.5, v); // BAD
	case 4:
		return pow(v, 2); // BAD
	case 5:
		return pow(v, w); // BAD
	};
}

double myRound1(double v)
{
	return round(v);
}

double myRound2(double v)
{
	double result = round(v);

	return result;
}

double myRound3(double v)
{
	return (v > 0) ? round(v) : 0;
}

void test3()
{
	int i = myRound1(1.5); // GOOD
	int j = myRound2(2.5); // GOOD
	int k = myRound3(3.5); // GOOD
}
