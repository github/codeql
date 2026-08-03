namespace Expr {

int i;

void comma_expr_test()
{
	i++, i++; // GOOD
	0, i++; // $ Alert // BAD (first part)
	i++, 0; // $ Alert // BAD (second part)
	0, 0; // $ Alert // BAD (whole)
}

}
