public class Test {

  public static void test() {
    var x = Unavailable.f()::g;
  }

}

// Diagnostic Matches: 1 javac errors
// Diagnostic Matches: Unable to extract method reference Unavailable.f()::g with no owner type
// Diagnostic Matches: Unknown or erroneous type for expression of kind MemberReference
// Diagnostic Matches: Unknown or erroneous type for expression of kind TypeAccess
