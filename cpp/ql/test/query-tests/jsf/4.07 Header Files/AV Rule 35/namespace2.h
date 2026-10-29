// BAD: this should have a header guard

namespace std
{
	extern "C" int (myFunction)(char *param) throw();
};
