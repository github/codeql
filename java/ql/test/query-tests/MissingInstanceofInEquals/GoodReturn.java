class GoodReturn {
  public static final GoodReturn GR = new GoodReturn();

  @Override
  public int hashCode() {
    return getClass().hashCode();
  }

  @Override
  public boolean equals(Object obj) {
    return obj == GR;
  }
}
