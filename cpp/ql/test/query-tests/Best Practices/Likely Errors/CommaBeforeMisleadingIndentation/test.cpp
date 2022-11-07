// clang-format off

typedef unsigned size_t;

struct X {
	int foo(int y) { return y; }
} x;

#define FOO(x) ( \
   (x),          \
  (x)            \
)

#define BAR(x, y) ((x), (y))

#define BAZ //printf

struct Foo {
	int i, i_array[3];
	int j;
	virtual int foo(int) = 0;
	virtual int bar(int, int) = 0;
	int test(int (*baz)(int));

	struct Tata {
		struct Titi {
			void tutu() {}
			long toto() { return 42; }
		} titi;

		Titi *operator->() { return &titi; }
	} *tata;
};

int Foo::test(int (*baz)(int))
{
	// Comma in simple if statement (prototypical example):

	if (i)
		(void)i,	// GOOD
		j++;

	if (i)
		this->foo(i),	// GOOD
		foo(i);

	if (i)
		(void)i,	// BAD
	(void)j;

	if (1) FOO(i),
	(void)x.foo(j); // BAD

	// Parenthesized comma (borderline example):

	foo(i++), j++;   // GOOD
	(foo(i++), j++); // GOOD
	(foo(i++),       // GOOD
	 j++);
	(foo(i++),
	 foo(i++),
	j++,             // GOOD (?) -- Currently explicitly excluded
	j++);

	x.foo(i++), j++;   // GOOD
	(x.foo(i++), j++); // GOOD
	(x.foo(i++),       // GOOD
	 j++);
	(x.foo(i++),
	 x.foo(i++),
	j++,               // GOOD (?) -- Currently explicitly excluded
	j++);

	FOO(i++), j++;   // GOOD
	(FOO(i++), j++); // GOOD
	(FOO(i++),       // GOOD
	 j++);
	(FOO(i++),
	 FOO(i++),
	j++,             // GOOD (?) -- Currently explicitly excluded
	j++);

	(void)(i++), j++;   // GOOD
	((void)(i++), j++); // GOOD
	((void)(i++),       // GOOD
	 j++);
	((void)(i++),
	 (void)(i++),
	j++,                // GOOD (?) -- Currently explicitly excluded
	j++);

	// Comma in argument list doesn't count:

	bar(i++, j++); // GOOD
	bar(i++,
	    j++);      // GOOD
	bar(i++
	  , j++);      // GOOD
	bar(i++,
	j++);          // GOOD: common pattern and unlikely to be misread.

	BAR(i++, j++); // GOOD
	BAR(i++,
	    j++);      // GOOD
	BAR(i++
	  , j++);      // GOOD
	BAR(i++,
	j++);          // GOOD: common pattern and unlikely to be misread.

	using T = decltype(x.foo(i++), // GOOD
	                   j++);
	(void)sizeof(x.foo(i++), // GOOD
	             j++);
	using U = decltype(x.foo(i++), // GOOD? Unlikely to be misread
				j++);
	(void)sizeof(x.foo(i++), // GOOD? Unlikely to be misread
				j++);

	BAZ("%d %d\n", i,
		j); // GOOD -- Currently explicitly excluded

	// Comma in loops

    while (i = foo(j++), // GOOD
           i != j && i != 42 &&
               !foo(j)) {
        i = j = i + j;
    }

    while (i = foo(j++), // GOOD??? Currently ignoring loop heads
        i != j && i != 42 && !foo(j)) {
        i = j = i + j;
    }

	for (i = 0,         // GOOD? Currently ignoring loop heads.
	    j = 1;
		i + j < 10;
		i++, j++);

	for (i = 0,
         j = 1; i < 10; i += 2, // GOOD? Currently ignoring loop heads.
        j++) {}

	// Comma in if-conditions:

	if (i = foo(j++),
		i == j)	// GOOD(?) -- Currently ignoring if-conditions for the same reason as other parenthesized commas.
		i = 0;

    // Mixed tabs and spaces (ugly case):

    for (i = 0,         // GOOD if tab >= 4 spaces else BAD -- Currently ignoring loop heads.
		 j = 0;
		 i + j < 10;
         i++,           // GOOD if tab >= 4 spaces else BAD -- Currently ignoring loop heads.
		 j++);

	if (i)
	    (void)i,	    // GOOD if tab >= 4 spaces else BAD -- can't exclude w/o source code text :/
		(void)j;

	// LHS ends on same line RHS begins on:

	if (1) foo(
		i++
	), j++; // GOOD? [FALSE POSITIVE]

	if (1) baz(
		i++
	), j++; // GOOD... when calling a function pointer..!?

	// Weird cases:

	if (foo(j))
		return i++
			, i++ // GOOD(?) [FALSE POSITIVE] -- can't exclude w/o source code text :/
			? 1
			: 2;

    int quux =
      (tata->titi.tutu(),
       foo(tata->titi.toto())); // GOOD

	(*tata)->toto(), // GOOD
	i_array[i] += (int)(*tata)->toto();

	return quux;
}

// Comma in variadic template splice:

namespace std {
	template <size_t... Is>
	struct index_sequence {};
}

template <size_t I>
struct zip_index {};

template <size_t I>
int& at(zip_index<I>) { throw 1; }

template <class Fn, class At, size_t... Is>
void for_each_input(Fn&& fn, std::index_sequence<Is...>) {
	(fn(zip_index<Is>{}, at(zip_index<Is>{})), ...); // GOOD
}

// clang-format on
