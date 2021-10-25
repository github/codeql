
extern "C++" {
    namespace std {
        class type_info {
        };
    }
}

class Base
{
public:
	Base() {};

	virtual void v() {}
};

class Derived : public Base {
public:
	Derived() {};
};

void func() {
	Base *base_ptr = new Base();
	Derived *derived_ptr = new Derived();
	Base *base_derived_ptr = derived_ptr;
	unsigned short us;

	const std::type_info &info1 = typeid(base_ptr);
	const std::type_info &info2 = typeid(derived_ptr);
	const std::type_info &info3 = typeid(base_derived_ptr);
	const std::type_info &info4 = typeid(Base); // [GOOD - the test result for this line should not have a getExpr()]
	const std::type_info &info5 = typeid(Derived); // [GOOD - the test result for this line should not have a getExpr()]
	const std::type_info &info6 = typeid(us);
	const std::type_info &info7 = typeid(unsigned short); // [GOOD - the test result for this line should not have a getExpr()]
}
