// This header file is extracted only once even though it's included by both
// file1.c and file2.c. That's presumably because it's wrongly considered to
// expand to the same trap in both contexts. In practice, this header gets
// extracted together with the extraction of file1.c.

// BUG: types of members depend on extraction order.
// Only one copy of this struct is extracted, and the types of its members refer
// to the typedefs in file1.c. Had file2.c been extracted first instead, the
// types of its members would be different.
struct UnifiableOnce {
    intAlias intMember;
    qualifiedIntAlias qualifiedIntMember;
};

// BUG: types of parameters depend on extraction order.
void functionOnce(intAlias param);
