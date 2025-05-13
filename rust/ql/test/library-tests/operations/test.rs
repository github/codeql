
// --- tests ---

fn test_operations(
	y: i32, a: bool, b: bool,
	ptr: &i32, res: Result<i32, ()>) -> Result<(), ()>
{
	let mut x: i32;

	// simple assignment
	x = y; // $ Operation Op== Operands=2 AssignmentOperation BinaryExpr

	// comparison operations
	x == y; // $ Operation Op=== Operands=2 BinaryExpr
	x != y; // $ Operation Op=!= Operands=2 BinaryExpr
	x < y; // $ Operation Op=< Operands=2 BinaryExpr
	x <= y; // $ Operation Op=<= Operands=2 BinaryExpr
	x > y; // $ Operation Op=> Operands=2 BinaryExpr
	x >= y; // $ Operation Op=>= Operands=2 BinaryExpr

	// arithmetic operations
	x + y; // $ Operation Op=+ Operands=2 BinaryExpr
	x - y; // $ Operation Op=- Operands=2 BinaryExpr
	x * y; // $ Operation Op=* Operands=2 BinaryExpr
	x / y; // $ Operation Op=/ Operands=2 BinaryExpr
	x % y; // $ Operation Op=% Operands=2 BinaryExpr
	x += y; // $ Operation Op=+= Operands=2 AssignmentOperation BinaryExpr
	x -= y; // $ Operation Op=-= Operands=2 AssignmentOperation BinaryExpr
	x *= y; // $ Operation Op=*= Operands=2 AssignmentOperation BinaryExpr
	x /= y; // $ Operation Op=/= Operands=2 AssignmentOperation BinaryExpr
	x %= y; // $ Operation Op=%= Operands=2 AssignmentOperation BinaryExpr
	-x; // $ Operation Op=- Operands=1 PrefixExpr

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
