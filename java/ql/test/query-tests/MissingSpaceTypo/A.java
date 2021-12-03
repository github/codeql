public class A {
  public void missing() {
    String s;
    s = "this text" +
      "is missing a space";
    s = "the class java.util.ArrayList" +
      "without a space";
    s = "This isn't" +
      "right.";
    s = "There's 1" +
      "thing wrong";
    s = "There's A/B" +
      "and no space";
    s = "Wait for it...." +
      "No space!";
    s = "Is there a space?" +
      "No!";
  }

  public void ok() {
    String s;
    s = "some words%n" +
      "and more";
    s = "some words\n" +
      "and more";
    s = "the class java.util." +
      "ArrayList";
    s = "some data: a,b,c," +
      "d,e,f";
  }
}
