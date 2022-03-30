// Variable

extern int myVariable;

int myVariable = 10;

// Function, Parameter

void myFunction(int myParameter);

void myFunction(int myParameter)
{
	// ...
}

// Enum (UserType)

enum myEnum : short;

enum myEnum : short
{
	myEnumConst
};

// TemplateClass, TemplateParameter (UserType)

template <typename T>
class myTemplateClass
{
public:
	T myMemberVariable;
};

myTemplateClass<int> mtc_int;
myTemplateClass<short> mtc_short;
