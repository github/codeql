// semmle-extractor-options: --microsoft
#define FIRST_VALUE  0x0001 // Comment on FIRST_VALUE
                            // that spans two lines.
#define SECOND_VALUE 0x0002 // Comment on SECOND_VALUE
                            // that spans two lines.

#define __cplusplus
#ifdef __cplusplus
extern "C" { /* comment on extern "C" */
}
#endif

class bad_cast;
template<class T> inline
	const T& myTemplateFunction()
	{
#if _HAS_EXCEPTIONS
		throw bad_cast(); // comment on throw bad_cast()
#else
		abort(); // comment on abort()
#endif
	}

template<class T>
class myClass {
public:
	typedef int iterator;

    int operator-(const iterator &iter) const
        {   // comment on operator-
            return 1;
        }

    int operator[](int off) const
        {   // comment on operator[]
            return 2;
        }
};

// On myns namespace
namespace myns { // Also on myns namespace
    void myns_fn(void);
}

// On class my_class
class my_class {
    // On my_class_int
    int my_class_int; // Also on my_class_int
};

// On outer static assert
static_assert(3 + 4 == 7, "Addition is sane");

void sa_fun(int x, int y) {
  // On inner static assert
  static_assert(sizeof(x) == sizeof(y), "Type sizes are sane"); // Also on inner static assert
}

// More myns namespace
namespace myns {
}

