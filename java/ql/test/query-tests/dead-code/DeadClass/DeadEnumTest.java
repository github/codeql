public class DeadEnumTest {
  public enum DeadEnum { // $ Alert
    A
  }

  public enum LiveEnum {
    A
  }

  public static void main(String[] args) {
    LiveEnum.values();
  }
}
