enum Type { S, I };

struct Foo {
	char* name;
	int count;
	char* another_name;
	char* yet_another_name;
	char initials[2];
	long very_long;
};

void create_foo()
{
	Foo xx;
	char name[] = "Foo McFoo";
	xx.name = name;
	xx.count = 123;
	Foo yy = { "Barry McBar", 42, "Baz", "Basildon", { 'B', 'X' }, 5678 };
}

void print_foo(Foo* p)
{

}

Foo current_foo;

Foo set_current_foo(Foo next)
{
	Foo prev = current_foo;
	current_foo = next;
	return prev;
}
