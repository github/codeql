public class User {

  public static void test(Lib<CharSequence> invarLib, Lib<? extends CharSequence> extendsLib, Lib<? super CharSequence> superLib, Lib<?> unboundLib) {

    invarLib.takesVar(null);
    extendsLib.takesVar(null);
    superLib.takesVar(null);
    unboundLib.takesVar(null);

  }

}
