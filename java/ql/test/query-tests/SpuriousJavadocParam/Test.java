public class Test<V> {

  // no javadoc
  public void ok0(){ }

  /* no javadoc */
  public void ok1(){ }

  /**
   * no tags
   */
  public void ok2(){ }

  /**
   * @param p1 correctly spelled
   */
  public void ok3(int p1){ }

  /**
   * @param <T> type parameter
   */
  public <T> T ok4(){ return null; }

  /**
   * @param <T> several type 
   * @param <V> parameters
   */
  public <T,V> T ok5(V p){ return null; }

  /**
   * @param <T> several type 
   * @param <V> parameters
   * @param p mixed with normal parameters
   */
  public <T,V> T ok6(V p){ return null; }

  /**
   * weird parameter name
   * @param <V>
   * @param V
   */
  private <V> void ok7(V V){ V = null; }

  /**
   * not a param
   * param   something 
   */
  protected void ok8(){ }

  /**
   * param param
   * @param                       param
   */
  protected void ok9(int...param){ }

  /**
   * @param prameter typo // $ Alert
   */
  public void problem1(int parameter){ }

  /**
   * @param Parameter capitalization // $ Alert
   */
  public void problem2(int parameter){ }

  /**
   * @param parameter unmatched // $ Alert
   */
  public void problem3(){ }

  /**
   * @param someOtherParameter matched
   * @param parameter unmatched // $ Alert
   */
  public void problem4(int someOtherParameter){ }

  /**
   * @param <V> unmatched type parameter // $ Alert
   */
  private <T> T problem5(){ return null; }

  /**
   * @param <V> matched type parameter
   * @param <P> unmatched type parameter // $ Alert
   * @param n unmatched normal parameter // $ Alert
   */
  private <T,V> T problem6(V p){ return null; }

  /**
   * param with immediate newline
   * @param // $ Alert
   */
  protected void problem7(){ }

  /**
   * param without a value (followed by blanks)
   * @param     // $ Alert
   */
  protected void problem8(){ }

  class SomeClass {
    /**
     * @param i exists
     * @param k does not // $ Alert
     */
    SomeClass(int i, int j) {}
  }

  /**
   * @param <T> exists
   * @param T wrong syntax // $ Alert
   * @param <X> does not exist // $ Alert
   */
  class GenericClass<T> {}

  /**
   * @param <T> exists
   * @param T wrong syntax // $ Alert
   * @param <X> does not exist // $ Alert
   */
  interface GenericInterface<T> {}

  /**
   * @param i exists
   * @param k does not // $ Alert
   */
  static record SomeRecord(int i, int j) {}

  /**
   * @param <T> exists
   * @param <U> does not // $ Alert
   * @param i exists
   * @param k does not // $ Alert
   */
  static record GenericRecord<T>(int i, int j) {}
}
