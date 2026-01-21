package package_a;

public class FieldInheritanceOtherA extends FieldInheritanceA {
    // Cannot inheriting original fields, due to fields in PrivateHidingField
    // even though they are not accessible here
    class ExtendingPrivateHidingField extends PrivateHidingField {}
}
