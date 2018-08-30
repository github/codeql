class GoodReturn {
  public static final GoodReturn GR = new GoodReturn();

  @Override
  public int hashCode() {
    getClass().hashCode();
  }

  @Override
  public boolean equals(Object obj) {
    return obj == GR;
  }
}
