public class JavaUser {

  public static void test() {

    HasCompanion.staticMethod("1");
    HasCompanion.Companion.nonStaticMethod("2");
    HasCompanion.setStaticProp(HasCompanion.Companion.getNonStaticProp());
    HasCompanion.Companion.setNonStaticProp(HasCompanion.getStaticProp());
    HasCompanion.Companion.setPropWithStaticGetter(HasCompanion.Companion.getPropWithStaticSetter());
    HasCompanion.setPropWithStaticSetter(HasCompanion.getPropWithStaticGetter());

    // These extract as static methods, since there is no proxy method in the non-companion object case.
    NonCompanion.staticMethod("1");
    NonCompanion.INSTANCE.nonStaticMethod("2");
    NonCompanion.setStaticProp(NonCompanion.INSTANCE.getNonStaticProp());
    NonCompanion.INSTANCE.setNonStaticProp(NonCompanion.getStaticProp());
    NonCompanion.INSTANCE.setPropWithStaticGetter(NonCompanion.INSTANCE.getPropWithStaticSetter());
    NonCompanion.setPropWithStaticSetter(NonCompanion.getPropWithStaticGetter());

  }

}
