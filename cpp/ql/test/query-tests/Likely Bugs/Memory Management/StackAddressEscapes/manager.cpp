// test cases for StackAddressEscapes.ql

namespace std
{
	class string;

	template<class T> class vector
	{
	};
};

class manager
{
public:
	manager() {};
	~manager() {};
};

class resource
{
public:
	resource(manager *_m) : m(_m) {};

	void set_strings(std::vector<std::string> const &_strings);

private:
	manager *m;
	std::vector<std::string> const *strings;
};

void resource :: set_strings(std::vector<std::string> const &_strings)
{
	strings = &_strings;
}

manager *glob_man;

manager *test_managers()
{
	manager man;
	manager *man_ptr;
	man_ptr = &man;

	resource a(&man); // BAD: stack address `&man` escapes [NOT DETECTED]
	resource b(man_ptr); // BAD: stack address `man_ptr` escapes [NOT DETECTED]
	resource *c = new resource(&man); // BAD: stack address `&man` escapes [NOT DETECTED]

	std::vector<std::string> vs;
	a.set_strings(vs); // BAD: stack address `&vs` escapes [NOT DETECTED]

	glob_man = &man; // BAD: stack address `&man` escapes

	return &man; // BAD: stack address `&man` escapes [NOT DETECTED]
}
