// This header file is extracted twice because its inclusions in file1.c and
// file2.c lead to different context hashes, seemingly because this file (unlike
// extracted_once.h) refers to `structAlias`. That means the resulting trap has
// two copies of all declarations in this file, and those copies have to be
// unified in the trap import step or in QL.

// GOOD. The types of the members of this struct are unifiable, which in this
// context means that they share the same unspecified types. This means that the
// two extractions of the struct get the same content hash and therefore become
// one entry in the database. Both struct members have multiple types in the
// `membervariables` table, but those are unified in the
// `MemberVariable.getType()` predicate.
struct UnifiableTwice {
    intAlias intMember;
    qualifiedIntAlias qualifiedIntMember;
};

// BUG: Non-member variables of this type have two types in the database.
// The type of `structMember` is ambiguous, and the two possible types are not
// unifiable, meaning in this context that they don't share an unspecified type.
// The types are nevertheless _compatible_, so it's valid C (not C++) to use
// these two definitions interchangably in the same program.
struct NotUnifiableTwice {
    structAlias structMember;
};

// BUG: The parameter of this function has two types.
// Because the `MemberVariable.getType()` workaround does not apply to a
// `Parameter`, this `Parameter` gets two types.
void functionTwice(intAlias param);
