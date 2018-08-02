
void f();
void g();
void h()
{
	f();

	__assume(0);

	g(); // unreachable
}
void i();
void j();
void k()
{
	i();
	h();
	j(); // unreachable
}
