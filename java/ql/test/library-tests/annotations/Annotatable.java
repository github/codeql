import java.lang.annotation.Inherited;
import java.lang.annotation.Repeatable;

class Annotatable {
    @interface CustomAnnotation {}

    @Inherited
    @interface CustomInheritedAnnotation {
        String value();
    }

    @CustomAnnotation
    @CustomInheritedAnnotation("base")
    class WithDeclared {
        // Annotations on methods are not inherited
        @CustomInheritedAnnotation("base-method")
        void methodWithDeclared() {}
    }

    class Subclass extends WithDeclared {
        @Override
        void methodWithDeclared() {}
    }

    // Inheritance from super-superclass
    class SubSubclass extends Subclass {}

    // Prevents inheriting annotation of same type
    @CustomInheritedAnnotation("sub")
    class SubclassDeclaringSameAnnotation extends WithDeclared {}


    // Annotations on interfaces are not inherited
    @CustomInheritedAnnotation("base")
    interface InterfaceWithDeclared {}

    interface ExtendingInterface extends InterfaceWithDeclared {}

    class ImplementingInterface implements InterfaceWithDeclared {}


    @interface ContainerAnnotation {
        RepeatableAnnotation[] value();
    }

    @Repeatable(ContainerAnnotation.class)
    @interface RepeatableAnnotation {
        String value();
    }

    @Inherited
    @interface InheritedContainerAnnotation {
        InheritedRepeatableAnnotation[] value();
    }

    @Inherited
    @Repeatable(InheritedContainerAnnotation.class)
    @interface InheritedRepeatableAnnotation {
        String value();
    }

    @Inherited
    @interface InheritedContainerAnnotation2 {
        NonInheritedRepeatableAnnotation[] value();
    }

    // Container is marked as @Inherited, but this annotation type is not
    // This is allowed, but means that associated annotations will not be inherited,
    // see java.lang.reflect.AnnotatedElement documentation
    @Repeatable(InheritedContainerAnnotation2.class)
    @interface NonInheritedRepeatableAnnotation {
        String value();
    }

    @RepeatableAnnotation("base")
    @InheritedRepeatableAnnotation("base")
    @NonInheritedRepeatableAnnotation("base")
    class WithAssociatedSingle {}

    @RepeatableAnnotation("sub-1")
    @RepeatableAnnotation("sub-2")
    @InheritedRepeatableAnnotation("sub-1")
    @InheritedRepeatableAnnotation("sub-2")
    @NonInheritedRepeatableAnnotation("sub-1")
    @NonInheritedRepeatableAnnotation("sub-2")
    class SubclassWithMultiple extends WithAssociatedSingle {}


    // Empty container annotations have no effect; annotations are inherited from superclass
    @InheritedContainerAnnotation({})
    @InheritedContainerAnnotation2({})
    class SubclassOfSingleWithEmptyContainer extends WithAssociatedSingle {}


    // Annotations on interfaces are not inherited
    @InheritedRepeatableAnnotation("base-1")
    @InheritedRepeatableAnnotation("base-2")
    interface InterfaceWithAssociated {}

    interface ExtendingInterfaceWithAssociated extends InterfaceWithAssociated {}

    class ImplementingInterfaceWithAssociated implements InterfaceWithAssociated {}


    @RepeatableAnnotation("base-1")
    @RepeatableAnnotation("base-2")
    @InheritedRepeatableAnnotation("base-1")
    @InheritedRepeatableAnnotation("base-2")
    // These annotations are not inherited, but their (implicit) container annotation
    // is inherited
    @NonInheritedRepeatableAnnotation("base-1")
    @NonInheritedRepeatableAnnotation("base-2")
    class WithAssociatedMultiple {
        // Annotations on methods are not inherited
        @InheritedRepeatableAnnotation("base-method")
        void methodWithAssociatedSingle() {}

        // Annotations on methods are not inherited
        @InheritedRepeatableAnnotation("base-method-1")
        @InheritedRepeatableAnnotation("base-method-2")
        void methodWithAssociated() {}
    }

    class WithAssociatedSubclass extends WithAssociatedMultiple {
        @Override
        void methodWithAssociatedSingle() {}

        @Override
        void methodWithAssociated() {}
    }

    // Inheritance from super-superclass
    class WithAssociatedSubSubclass extends WithAssociatedSubclass {}

    @RepeatableAnnotation("sub-1")
    @InheritedRepeatableAnnotation("sub-1")
    @NonInheritedRepeatableAnnotation("sub-1")
    class SubclassWithSingle extends WithAssociatedMultiple {}


    // Empty container annotations have no effect; associated annotations are inherited from superclass
    @InheritedContainerAnnotation({})
    @InheritedContainerAnnotation2({})
    class SubclassOfMultipleWithEmptyContainer extends WithAssociatedMultiple {}


    // This annotation exists on its own without a container
    @InheritedRepeatableAnnotation("single")
    // TODO: Has currently spurious results for ArrayInit due to https://github.com/github/codeql/issues/8647
    @InheritedContainerAnnotation({
        @InheritedRepeatableAnnotation("container-1"),
        @InheritedRepeatableAnnotation("container-2")
    })
    class ExplicitContainerAndSingleContained {}

    class ExplicitContainerSubclass extends ExplicitContainerAndSingleContained {}


    @Inherited
    @interface NestedAnnotationContainer1 {
        NestedAnnotation1[] value();
    }

    @Inherited
    @Repeatable(NestedAnnotationContainer1.class)
    @interface NestedAnnotation1 {
        NestedAnnotation2[] value();
    }

    @Inherited
    @Repeatable(NestedAnnotation1.class)
    @interface NestedAnnotation2 {
        String value();
    }

    // This annotation exists on its own without a container
    @NestedAnnotation2("1")
    // But these are nested inside an implicit @NestedAnnotationContainer1
    // Nested repeated annotations (@NestedAnnotation2) are not considered associated
    @NestedAnnotation1({@NestedAnnotation2("1-1"), @NestedAnnotation2("1-2")})
    @NestedAnnotation1({@NestedAnnotation2("2-1"), @NestedAnnotation2("2-2")})
    class WithNestedAssociated {}

    class WithNestedAssociatedSubclass extends WithNestedAssociated {}

    // Nested repeated annotations (@NestedAnnotation2) are not considered associated
    @NestedAnnotation1({@NestedAnnotation2("1-1"), @NestedAnnotation2("1-2")})
    @NestedAnnotation1({@NestedAnnotation2("2-1"), @NestedAnnotation2("2-2")})
    class WithNestedAssociatedExplicitContainers {}

    class WithNestedAssociatedExplicitContainersSubclass extends WithNestedAssociatedExplicitContainers {}
}
