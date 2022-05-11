public class StringBuilderTests {
  public static String taint() { return "tainted"; }

  public static void sink(String s) { }

  static void stringBuilderBad() {
    StringBuilder sb = new StringBuilder();
    sb.append("from preferences select locale where user='");
    sb.append(taint());
    sb.append("'");
    sink(sb.toString());
  }

  static void stringBuilderOkay() {
    StringBuilder sb = new StringBuilder();
    sb.append("from preferences select locale where user='");
    sb.append("fred");
    sb.append("'");
    sink(sb.toString());
  }

  static void stringBufferBad() {
    StringBuffer sb = new StringBuffer();
    sb.append("from preferences select locale where user='");
    sb.append(taint());
    sb.append("'");
    sink(sb.toString());
  }

  static void stringBuilderNoVarBad() {
    sink(new StringBuilder()
      .append("from preferences select locale where user='")
      .append(taint())
      .append("'").toString()
    );
  }

  static void stringBuilderConstructorBad() {
    StringBuilder sb = new StringBuilder(taint());
    sb.append("from preferences select locale where user='");
    sb.append("fred");
    sb.append("'");
    sink(sb.toString());
  }

  static void stringBuilderMultipleAppendsBad() {
    StringBuilder sb = new StringBuilder();
    sb.append("from preferences select locale where user='").append(taint());
    sb.append("'");
    sink(sb.toString());
  }

  static void stringBuilderReplaceBad() {
    StringBuilder sb = new StringBuilder();
    sb.append("from preferences select locale where user='placeholder'");
    sb.replace(45, 57, taint());
    sink(sb.toString());
  }

  static void stringBuilderInsertBad() {
    StringBuilder sb = new StringBuilder();
    sb.append("from preferences select locale where user=''");
    sb.insert(45, taint());
    sink(sb.toString());
  }

  static void stringBuilderGetCharsBad() {
    StringBuilder sb = new StringBuilder();
    sb.append("from preferences select locale where user=''");
    sb.append(taint());
    char[] chars = null;
    sb.getChars(0, 0, chars, 0);
    sink(new String(chars));
  }

  static void stringBuilderSubSequenceBad() {
    StringBuilder sb = new StringBuilder();
    sb.append("from preferences select locale where user=''");
    sb.append(taint());
    sink(sb.subSequence(0, 0).toString());
  }

  static void stringBuilderSubstringBad() {
    StringBuilder sb = new StringBuilder();
    sb.append("from preferences select locale where user=''");
    sb.append(taint());
    sink(sb.substring(0, 0));
  }
}
