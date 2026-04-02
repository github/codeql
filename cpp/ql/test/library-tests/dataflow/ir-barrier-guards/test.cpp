bool checkArgument(int* x);

void sink(int);

void testCheckArgument(int* p) {
  if (checkArgument(p)) {
    sink(*p); // $ indirect_barrier=int barrier=int*
  }
}

void testCheckArgument(int p) {
  if (checkArgument(&p)) {
    sink(p); // $ barrier=glval<int> indirect_barrier=int
  }
}

int* get_clean_value(int* x) { return x; }
bool is_clean_value(int*);

int* get_clean_pointer(int* x) { return x; }
bool is_clean_pointer(int*);

void sink(int*);

void test_mad(int x, int* p) {
	{
		if(is_clean_value(&x)) {
			sink(x); // $ external=int
		}
	}

	{
		if(is_clean_value(p)) {
			sink(*p); // $ external=int
		}
	}

	{
		if(is_clean_pointer(p)) {
			sink(p); // $ external=int*
		}
	}

	{
		if(is_clean_pointer(&x)) {
			sink(x); // $ external=glval<int>
		}
	}
}