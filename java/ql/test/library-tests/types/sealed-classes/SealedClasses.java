class SealedClasses {
    static class NonSealedClass { }
    interface NonSealedInterface { }

    static sealed class ExplicitPermitsClass permits SealedSubClass, NonSealedSubClass, FinalSubClass { }

    static sealed class SealedSubClass extends ExplicitPermitsClass implements ExplicitPermitsInterface { }
    static final class FinalSubSubClass extends SealedSubClass { }

    static non-sealed class NonSealedSubClass extends ExplicitPermitsClass { }

    static final class FinalSubClass extends ExplicitPermitsClass { }

    static class ExtendingNonSealedClass extends NonSealedSubClass { }


    sealed interface ExplicitPermitsInterface permits SealedSubClass, SealedSubInterface, NonSealedSubInterface, RecordClass, EnumClass { }

    sealed interface SealedSubInterface extends ExplicitPermitsInterface { }
    static final class FinalInterfaceClass implements SealedSubInterface { }

    non-sealed interface NonSealedSubInterface extends ExplicitPermitsInterface { }

    record RecordClass() implements ExplicitPermitsInterface { }

    enum EnumClass implements ExplicitPermitsInterface { }

    interface ExtendingNonSealedInterface extends NonSealedSubInterface { }


    // `permits` clause may be omitted if all subtypes are in the same compilation unit
    sealed interface ImplicitPermitsInterface { }
    non-sealed interface ImplicitPermitsSubInterface extends ImplicitPermitsInterface { }


    // Enum with anonymous subclass is implicitly sealed, see JLS 17 8.9
    enum ImplicitlySealedEnum {
        A { }
    }
}
