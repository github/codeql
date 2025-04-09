
// --- tests ---

fn test_operations(
	y: i32, a: bool, b: bool,
	ptr: &i32, res: Result<i32, ()>) -> Result<(), ()>
{
	let mut x: i32;

	// simple assignment
	x = y; // $ AssignmentOperation BinaryExpr

	// comparison operations
	x == y; // $ BinaryExpr
	x != y; // $ BinaryExpr
	x < y; // $ BinaryExpr
	x <= y; // $ BinaryExpr
	x > y; // $ BinaryExpr
	x >= y; // $ BinaryExpr

	// arithmetic operations
	x + y; // $ BinaryExpr
	x - y; // $ BinaryExpr
	x * y; // $ BinaryExpr
	x / y; // $ BinaryExpr
	x % y; // $ BinaryExpr
	x += y; // $ AssignmentOperation BinaryExpr
	x -= y; // $ AssignmentOperation BinaryExpr
	x *= y; // $ AssignmentOperation BinaryExpr
	x /= y; // $ AssignmentOperation BinaryExpr
	x %= y; // $ AssignmentOperation BinaryExpr
	-x; // $ PrefixExpr

	// logical operations
	a && b; // $ BinaryExpr LogicalOperation
	a || b; // $ BinaryExpr LogicalOperation
	!a; // $ PrefixExpr LogicalOperation

	// bitwise operations
	x & y; // $ BinaryExpr
	x | y; // $ BinaryExpr
	x ^ y; // $ BinaryExpr
	x << y; // $ BinaryExpr
	x >> y; // $ BinaryExpr
	x &= y; // $ AssignmentOperation BinaryExpr
	x |= y; // $ AssignmentOperation BinaryExpr
	x ^= y; // $ AssignmentOperation BinaryExpr
	x <<= y; // $ AssignmentOperation BinaryExpr
	x >>= y; // $ AssignmentOperation BinaryExpr

	// miscellaneous expressions that might be operations
	*ptr; // $ PrefixExpr
	&x; // $ RefExpr
	res?;

	return Ok(());
}
