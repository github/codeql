enum Type { S, I };

struct Foo {
	char* name;
	long int count;
	char* another_name;
	char* yet_another_name;
	char initials[2];
	long very_long;
};

struct ExtendedFoo : Foo
{
	char* more_details;
};


void create_foo()
{
	Foo xx;
	xx.name = (char*) "Foo McFoo";
	xx.count = (long) 38;
	Foo xx2 = { "Barry McBar", 99, "Baz", "Basildon", { 'B', 'X' }, 5678 };
}

void print_foo(Foo* p)
{

}

Foo current_foo;

Foo set_current_foo(ExtendedFoo next)
{
	Foo prev = current_foo;
	current_foo = (Foo) next;
	return prev;
}
