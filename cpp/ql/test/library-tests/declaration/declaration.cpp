// Variable

extern int myVariable0;

int myVariable0 = 10;

// Function, Parameter

void myFunction0(int myParameter);

void myFunction0(int myParameter)
{
  // ...
}

// Enum (UserType)

enum myEnum0 : short;

enum myEnum0 : short
{
  myEnumConst0
};

enum class MyEnumClass {
  RED,
  GREEN,
  BLUE
};

// Class
class MyClass0 {
public:
  int myField0;

  class MyNestedClass {
    int myNestedField;
  };

  MyClass0() : myField0(0) { myField0 = 1; }

  int getMyField0() { return myField0; }
};

// Struct
struct MyStruct0 {
  int myField0;
};

// Union
union MyUnion0 {
  int myField0;
  void* myPointer;
};

// Typedef
typedef MyClass0 *MyClassPtr;

// TemplateClass, TypeTemplateParameter (UserType)

template <typename T>
class myTemplateClass
{
public:
  T myMemberVariable;
};

myTemplateClass<int> mtc_int;
myTemplateClass<short> mtc_short;


// Everything inside a namespace.
namespace MyNamespace {

// Variable

extern int myVariable1;

int myVariable1 = 10;

// Function, Parameter

void myFunction1(int myParameter);

void myFunction1(int myParameter)
{
  // ...
}

// Enum (UserType)

enum myEnum1 : short;

enum myEnum1 : short
{
  myEnumConst1
};

// Class
class MyClass1 {
public:
  int myField1;

  class MyNestedClass {
    int myNestedField;
  };

  MyClass1() : myField1(0) { myField1 = 1; }

  int getMyField1() { return myField1; }
};

// Typedef
typedef MyClass1 *MyClassPtr;

// TemplateClass, TypeTemplateParameter (UserType)

template <typename T>
class myTemplateClass
{
public:
  T myMemberVariable;
};

myTemplateClass<int> mtc_int;
myTemplateClass<short> mtc_short;

// Nested namespace.
namespace NestedNamespace {
int myVariable2 = 10;
}

}
