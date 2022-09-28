class Test {

  @interface CustomAnnotation {
    String value();
  }

  @interface ArrayValues {
    CustomAnnotation[] annotationValues();
  }

  @ArrayValues(annotationValues = @CustomAnnotation(value = "only")) private int fieldWithSingular;
  @ArrayValues(annotationValues = {@CustomAnnotation(value = "val1"), @CustomAnnotation(value = "val2")}) private int fieldWithMultiple;

}
