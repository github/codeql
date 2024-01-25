// We want a source of user input that can be both a pointer and a non-pointer. So we
// hack the testing a bit by providing an overload that takes a boolean to distinguish
// between the two while still satisfying the test requirement that the function must
// be named `user_input`.
int user_input();
int* user_input(bool);
void sink(...);
void argument_source(int*);

struct S {
	int** x;
};

void test()
{
	{
		S s;
		**s.x = user_input();
		*s.x = 0;
		sink(**s.x); // clean, as *s.x was overwritten and that contains the tainted **s.x
	}

	{
		S s;
		**s.x = user_input();
		**s.x = 0;
		sink(**s.x); // clean, as **s.x was overwritten and tainted
	}

	{
		S s;
		*s.x = user_input(true);
		**s.x = 0;
		sink(*s.x); // $ ir // not clean, as **s.x was overwritten and is neither equal nor contains the tainted *s.x
	}

	{
		S s;
		*s.x = user_input(true);
		s.x = 0;
		sink(*s.x); // clean, as s.x was overwritten and contains the tainted *s.x
	}

	{
		S s;
		**s.x = user_input();
		s.x = 0;
		sink(*s.x); // clean, as s.x was overwritten and contains the tainted **s.x
	}

	{
		S s;
		*s.x = user_input(true);
		s.x++;
		sink(s.x); // $ SPURIOUS: ir ast // Cannot tell the difference with the whole array being tainted
	}

	{
		S s;
		**s.x = user_input();
		s.x++;
		sink(s.x); // $ SPURIOUS: ir // Cannot tell the difference with the whole array being tainted
	}
}

struct S2
{
	int* val;
};

void test_uncertain_write_is_not_clear()
{
	S2 s;
	argument_source(s.val);
	s.val[10] = 0;
	sink(*s.val); // $ ir MISSING: ast // not clean, as all elements of s.val are tainted and only one is overwitten
}

void test_indirection_should_not_be_cleared_with_write_1() {
	S2 s;
	argument_source(s.val); // *s.val is tainted
	s.val[0] = 0;
    s.val = s.val + 1;
	sink(*s.val); // $ ir MISSING: ast // not clean, as all elements of s.val are tainted, only one if overwritten, and the updated pointer still points to tainted elements
}

void test_indirection_should_not_be_cleared_with_write_2() {
	S2 s;
	argument_source(s.val); // *s.val is tainted
	*s.val++ = 0;
	sink(*s.val); // $ ir MISSING: ast // not clean, as all elements of s.val are tainted, only one if overwritten, and the updated pointer still points to tainted elements
}

void test_indirection_should_not_be_cleared_without_write_1() {
	S2 s;
	argument_source(s.val); // *s.val is tainted
	s.val = s.val + 1;
	sink(*s.val); // $ ir MISSING: ast // not clean, as all elements of s.val are tainted and the updated pointer still points to tainted elements
}

void test_indirection_should_not_be_cleared_without_write_2() {
	S2 s;
	argument_source(s.val); // *s.val is tainted
	s.val++;
	sink(*s.val); // $ ir MISSING: ast // not clean, as all elements of s.val are tainted and the updated pointer still points to tainted elements
}

void test_indirection_should_not_be_cleared_without_write_3() {
	S2 s;
	argument_source(s.val); // *s.val is tainted
	++s.val;
	sink(*s.val); // $ ir MISSING: ast // not clean as the pointer is only moved to the next tainted element
}

void test_indirection_should_not_be_cleared_without_write_4() {
	S2 s;
	argument_source(s.val); // *s.val is tainted
	s.val += 1;
	sink(*s.val); // $ ir MISSING: ast // not clean as the pointer is only moved to the next tainted element
}

void test_direct_should_be_cleared() {
	S2 s;
	s.val = user_input(true); // s.val is tainted
	s.val += 1;
	sink(s.val); // $ SPURIOUS: ast // clean, as s.val was overwritten and tainted
}

void test_direct_should_be_cleared_post() {
	S2 s;
	s.val = user_input(true); // s.val is tainted
	s.val++;
	sink(s.val); // $ SPURIOUS: ast // clean, as s.val was overwritten and tainted
}

void test_direct_should_be_cleared_pre() {
	S2 s;
	s.val = user_input(true); // s.val is tainted
	++s.val;
	sink(s.val); // $ SPURIOUS: ast // // clean, as s.x was overwritten and tainted
}

struct S3
{
	int val;
};

void test_direct() {
	{
		S3 s;
		s.val = user_input();
		sink(s.val); // $ ir ast
	}

	{
		S3 s;
		s.val = user_input();
		s.val = 0;
		sink(s.val); // $ SPURIOUS: ast // clean
	}

	{
		S3 s;
		s.val = user_input();
		s.val++;
		sink(s.val); // $ SPURIOUS: ast // clean
	}

	{
		S3 s;
		s.val = user_input();
		s.val += 1;
		sink(s.val); // $ SPURIOUS: ast // clean
	}

	{
		S3 s;
		s.val = user_input();
		s.val = s.val + 1;
		sink(s.val); // $ SPURIOUS: ast // clean
	}
}
