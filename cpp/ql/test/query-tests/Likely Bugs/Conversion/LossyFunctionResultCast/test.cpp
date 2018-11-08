
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

	if (roundf(getFloat())) // [FALSE POSITIVE]
	{
		setPosInt(roundf(getFloat())); // [FALSE POSITIVE]
		setPosFloat(roundf(getFloat()));
	}
	if (round(getDouble()))
	{
		setPosInt(round(getDouble()));
		setPosFloat(round(getDouble()));
	}
}
