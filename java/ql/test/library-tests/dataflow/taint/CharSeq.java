public class CharSeq {
    public static String taint() { return "tainted"; }
  
    public static void sink(Object o) { }
  
    void test1() {
      CharSequence seq = taint().subSequence(0,1);
      sink(seq);
  
      CharSequence seqFromSeq = seq.subSequence(0, 1);
      sink(seqFromSeq);

      String stringFromSeq = seq.toString();
      sink(stringFromSeq);
    }
  }