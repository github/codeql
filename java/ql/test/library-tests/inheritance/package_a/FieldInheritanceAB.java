package package_a;

import package_b.FieldInheritanceB;

// Tries to transitively inherit package-private fields which were not inherited by FieldInheritanceB
// These fields should not be considered inherited per JLS, even though the javac error message when
// trying to access them is misleading: "cannot be accessed from outside package"
public class FieldInheritanceAB extends FieldInheritanceB {
}
