
// --- tests ---

fn test_operations(
	y: i32, a: bool, b: bool,
	ptr: &i32, res: Result<i32, ()>) -> Result<(), ()>
{
	let mut x: i32;

	// simple assignment
	x = y; // $ Operation AssignmentOperation BinaryExpr

	// comparison operations
	x == y; // $ Operation BinaryExpr
	x != y; // $ Operation BinaryExpr
	x < y; // $ Operation BinaryExpr
	x <= y; // $ Operation BinaryExpr
	x > y; // $ Operation BinaryExpr
	x >= y; // $ Operation BinaryExpr

	// arithmetic operations
	x + y; // $ Operation BinaryExpr
	x - y; // $ Operation BinaryExpr
	x * y; // $ Operation BinaryExpr
	x / y; // $ Operation BinaryExpr
	x % y; // $ Operation BinaryExpr
	x += y; // $ Operation AssignmentOperation BinaryExpr
	x -= y; // $ Operation AssignmentOperation BinaryExpr
	x *= y; // $ Operation AssignmentOperation BinaryExpr
	x /= y; // $ Operation AssignmentOperation BinaryExpr
	x %= y; // $ Operation AssignmentOperation BinaryExpr
	-x; // $ Operation PrefixExpr

	// logical operations
	a && b; // $ Operation BinaryExpr LogicalOperation
	a || b; // $ Operation BinaryExpr LogicalOperation
	!a; // $ Operation PrefixExpr LogicalOperation

	// bitwise operations
	x & y; // $ Operation BinaryExpr
	x | y; // $ Operation BinaryExpr
	x ^ y; // $ Operation BinaryExpr
	x << y; // $ Operation BinaryExpr
	x >> y; // $ Operation BinaryExpr
	x &= y; // $ Operation AssignmentOperation BinaryExpr
	x |= y; // $ Operation AssignmentOperation BinaryExpr
	x ^= y; // $ Operation AssignmentOperation BinaryExpr
	x <<= y; // $ Operation AssignmentOperation BinaryExpr
	x >>= y; // $ Operation AssignmentOperation BinaryExpr

	// miscellaneous expressions that might be operations
	*ptr; // $ Operation PrefixExpr
	&x; // $ RefExpr
	res?;

	return Ok(());
}
