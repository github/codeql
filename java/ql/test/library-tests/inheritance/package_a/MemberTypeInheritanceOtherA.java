package package_a;

public class MemberTypeInheritanceOtherA extends MemberTypeInheritanceA {
    // Cannot inheriting original class, due to class in HidingNestedClassPrivate
    // even though it is not accessible here
    private static class ExtendendingHidingNestedClassPrivate extends HidingNestedClassPrivate {}
}
