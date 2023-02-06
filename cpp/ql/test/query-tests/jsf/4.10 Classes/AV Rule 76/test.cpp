class Class1 // good: no pointer members, default assignment operator and copy constructor
{
};

class Class2 // bad: pointer members, default assignment operator and copy constructor
{
private:
    int* _a;

public:
    Class2(int* a):_a(a)
    {
    }
};

class Class3 // bad: pointer members, custom assignment operator and default copy constructor
{
private:
    int* _a;

public:
    Class3(int* a) :_a(a)
    {
    }

    Class3& operator=(const Class3& rhs)
    {
        this->_a = rhs._a;
        return *this;
    }
};

class Class4 // bad: pointer members, default assignment operator and custom copy constructor
{
private:
    int* _a;

public:
    Class4(int* a) :_a(a)
    {
    }

    Class4(const Class4& rhs):_a(rhs._a)
    {
    }
};

class Class5  // good: pointer members, custom assignment operator and copy constructor
{
private:
    int* _a;

public:
    Class5(int* a) :_a(a)
    {
    }

    Class5(const Class5& rhs) :_a(rhs._a)
    {
    }

    Class5& operator=(const Class5& rhs)
    {
        this->_a = rhs._a;
        return *this;
    }
};

class Class6 // good: pointer members, deleted assignment operator and copy constructor
{
private:
    int* _a;

public:
    Class6(int* a) :_a(a)
    {
    }

    Class6& operator=(const Class6& rhs) = delete;
    Class6(const Class6& rhs) = delete;
};

class Class7 // good: pointer members, disallowed assignment operator and copy constructor
{
private:
    int* _a;

public:
    Class7(int* a) :_a(a)
    {
    }

private:
    Class7& operator=(const Class7& rhs); // no implementation to get linker error!
    Class7(const Class7& rhs); // no implementation to get linker error!
};