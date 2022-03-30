
// --- string ---

class string
{
public:
	string(const char *str)
	{
		// ...
	}

	// ...
};

string operator+(const string &lhs, const string &rhs)
{
	// ...
}

// --- ostream ---

class ostream
{
public:
	// ...
};

ostream &operator<<(ostream &stream, const string &str)
{
	// ...
}

// --- tests ---

void fn(const string &str1);

void joining_test(const string &x, const string &y) \
{
	fn("testrepo.git"); // BAD: "testrepo.git"
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git");
	fn("testrepo.git"); // (21 times)

	fn(x + " extends " + y); // GOOD
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y);
	fn(x + " extends " + y); // (21 times)

	fn("type error: " + x + " has no field " + y); // GOOD
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y);
	fn("type error: " + x + " has no field " + y); // (21 times)

	ostream os;

	os << "NO T_VOID CONSTRUCT"; // BAD: "NO T_VOID CONSTRUCT"
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT";
	os << "NO T_VOID CONSTRUCT"; // (21 times)

	os << "{" << x << "} else {" << y << "}"; // GOOD
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}";
	os << "{" << x << "} else {" << y << "}"; // (21 times)
	
	os << "writeString(" << x << ")"; // GOOD
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")";
	os << "writeString(" << x << ")"; // (21 times)

	os << "compiler error: no const of base type " + x; // BAD: "compiler error: no const of base type "
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x;
	os << "compiler error: no const of base type " + x; // (21 times)
}
