
class MyClass1
{
	// public / static data members
public:
	int public_val;
	char public_arr[100];
	static int public_static_val;

protected:
	static int protected_static_val;

private:
	static int private_static_val;
};

class MyClass2
{
protected:
	int protected_val; // has protected non-static variable -> not aggregate / POD
};

class MyClass3
{
private:
	char private_arr[100]; // has private non-static variable -> not aggregate / POD
};

struct MyClass4
{
	int public_val; // (public by default)
};

class MyClass5
{
	int private_val; // (private by default) has private non-static variable -> not aggregate / POD
};

// ---

class MyClass10
{
	// non-virtual functions
public:
	void public_fun();

protected:
	void protected_fun();

private:
	void private_fun();
};

class MyClass11
{
public:
	virtual void fun(); // has virtual function -> not aggregate / POD
};

class MyClass12
{
public:
	virtual ~MyClass12(); // has virtual function -> not aggregate / POD
};

// ---

class MyClass20
{
public:
	MyClass20 &operator=(const MyClass20 &); // // copy-assignment -> not POD
};

class MyClass21
{
public:
	~MyClass21(); // destructor -> not POD
};

class MyClass22
{
public:
	MyClass22(); // has user-declared constructor -> not aggregate / POD
};

class MyClass23
{
public:
	MyClass23(int fromInt); // has user-declared constructor -> not aggregate / POD
};

class MyClass24
{
private:
	MyClass24(const MyClass24 &); // has user-declared copy-constructor -> not aggregate / POD
};

// ---

class MyClass30 : public MyClass1 // has a base class -> not aggregate / POD
{
};

class MyClass31
{
public:
	static MyClass30 public_static_mc30;

protected:
	static MyClass30 protected_static_mc30;

private:
	static MyClass30 private_static_mc30;
};

class MyClass32
{
public:
	MyClass30 public_mc30; // has non-static, non-POD variable -> not POD
};

class MyClass33
{
protected:
	MyClass30 &public_mc30; // has non-static, non-POD variable reference -> not POD
};

class MyClass34
{
protected:
	MyClass30 public_mc30[10]; // has array of non-static, non-POD type -> not POD
};
