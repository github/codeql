
const int c = 1;

namespace namespace_a
{
	const int c = 1;
}

namespace namespace_b
{
	//const int c = 1;
	//
	// this example is causing a DBCheck failure along the lines of:
	// 
	// [INVALID_KEY] Relation namespacembrs((@namespace parentid, unique @namespacembr memberid)): Value 132 of key field memberid occurs in several tuples. Two such tuples are: (134,132) and (144,132)
}
