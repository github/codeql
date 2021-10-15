
// Badly laid out struct. Layout:
// - 4 bytes: int a
// - 4 bytes: padding
// - 8 bytes: double b
// - 4 bytes: int c
// - 4 bytes: padding
// - 6 bytes: char d[6]
// - 2 bytes: trailing padding
// Optimal layout removes 8 bytes padding, leaves 2 bytes trailing padding.
typedef struct a {
	int a;
	double b;
	int c;
	char d[6];
} struct_a;

// Struct with struct-typed member. Layout:
// - 32 bytes: struct_a a
// - 8 bytes: struct_a* b
// - 2 bytes: char c[2]
// - 6 bytes: trailing padding
// This layout is optimal, without rearranging struct a.
typedef struct b {
	struct_a a;
	struct_a* b;
	char c[2];
} struct_b;