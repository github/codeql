package package_a;

import package_b.MethodInheritanceB;

// Tries to transitively inherit package-private methods which were not inherited by FieldInheritanceB
// These methods should not be considered inherited per JLS
public class MethodInheritanceAB extends MethodInheritanceB {
    // Interestingly it is possible to override the method, but not to refer to the super implementation
    @Override
    void packagePrivateMethod() {
        // Does not compile
        // super.packagePrivateMethod();
    }
}
