
// --- tests ---

fn test_operations(
	y: i32, a: bool, b: bool,
	ptr: &i32, res: Result<i32, ()>) -> Result<(), ()>
{
	let mut x: i32;

	// simple assignment
	x = y; // $ Operation Op== Operands=2 AssignmentOperation BinaryExpr

	// comparison operations
	x == y; // $ Operation Op=== Operands=2 BinaryExpr ComparisonOperation EqualityOperation EqualsOperation
	x != y; // $ Operation Op=!= Operands=2 BinaryExpr ComparisonOperation EqualityOperation NotEqualsOperation
	x < y; // $ Operation Op=< Operands=2 BinaryExpr ComparisonOperation RelationalOperation LessThanOperation Greater=y Lesser=x
	x <= y; // $ Operation Op=<= Operands=2 BinaryExpr ComparisonOperation RelationalOperation LessOrEqualsOperation Greater=y Lesser=x
	x > y; // $ Operation Op=> Operands=2 BinaryExpr ComparisonOperation RelationalOperation GreaterThanOperation Greater=x Lesser=y
	x >= y; // $ Operation Op=>= Operands=2 BinaryExpr ComparisonOperation RelationalOperation GreaterOrEqualsOperation Greater=x Lesser=y

	// arithmetic operations
	x + y; // $ Operation Op=+ Operands=2 BinaryExpr ArithmeticOperation BinaryArithmeticOperation
	x - y; // $ Operation Op=- Operands=2 BinaryExpr ArithmeticOperation BinaryArithmeticOperation
	x * y; // $ Operation Op=* Operands=2 BinaryExpr ArithmeticOperation BinaryArithmeticOperation
	x / y; // $ Operation Op=/ Operands=2 BinaryExpr ArithmeticOperation BinaryArithmeticOperation
	x % y; // $ Operation Op=% Operands=2 BinaryExpr ArithmeticOperation BinaryArithmeticOperation
	x += y; // $ Operation Op=+= Operands=2 AssignmentOperation BinaryExpr ArithmeticOperation AssignArithmeticOperation
	x -= y; // $ Operation Op=-= Operands=2 AssignmentOperation BinaryExpr ArithmeticOperation AssignArithmeticOperation
	x *= y; // $ Operation Op=*= Operands=2 AssignmentOperation BinaryExpr ArithmeticOperation AssignArithmeticOperation
	x /= y; // $ Operation Op=/= Operands=2 AssignmentOperation BinaryExpr ArithmeticOperation AssignArithmeticOperation
	x %= y; // $ Operation Op=%= Operands=2 AssignmentOperation BinaryExpr ArithmeticOperation AssignArithmeticOperation
	-x; // $ Operation Op=- Operands=1 PrefixExpr ArithmeticOperation PrefixArithmeticOperation

	// logical operations
	a && b; // $ Operation Op=&& Operands=2 BinaryExpr LogicalOperation
	a || b; // $ Operation Op=|| Operands=2 BinaryExpr LogicalOperation
	!a; // $ Operation Op=! Operands=1 PrefixExpr LogicalOperation

	// bitwise operations
	x & y; // $ Operation Op=& Operands=2 BinaryExpr
	x | y; // $ Operation Op=| Operands=2 BinaryExpr
	x ^ y; // $ Operation Op=^ Operands=2 BinaryExpr
	x << y; // $ Operation Op=<< Operands=2 BinaryExpr
	x >> y; // $ Operation Op=>> Operands=2 BinaryExpr
	x &= y; // $ Operation Op=&= Operands=2 AssignmentOperation BinaryExpr
	x |= y; // $ Operation Op=|= Operands=2 AssignmentOperation BinaryExpr
	x ^= y; // $ Operation Op=^= Operands=2 AssignmentOperation BinaryExpr
	x <<= y; // $ Operation Op=<<= Operands=2 AssignmentOperation BinaryExpr
	x >>= y; // $ Operation Op=>>= Operands=2 AssignmentOperation BinaryExpr

	// miscellaneous expressions that might be operations
	*ptr; // $ Operation Op=* Operands=1 PrefixExpr
	&x; // $ RefExpr
	res?;

	return Ok(());
}
