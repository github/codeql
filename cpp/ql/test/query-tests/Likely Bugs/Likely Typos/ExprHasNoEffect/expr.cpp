namespace Expr {

int i;

void comma_expr_test()
{
	i++, i++; // GOOD
	0, i++; // BAD (first part)
	i++, 0; // BAD (second part)
	0, 0; // BAD (whole)
}

}