package package_a;

import package_b.MemberTypeInheritanceB;

// Tries to transitively inherit package-private member types which were not inherited by MemberTypeInheritanceB
// These member types should not be considered inherited per JLS, even though the javac error message when
// trying to access them is misleading: "cannot be accessed from outside package"
public class MemberTypeInheritanceAB extends MemberTypeInheritanceB {
}
