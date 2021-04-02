import org.springframework.validation.Errors;

class ValidationErrorsTest {
  String taint() { return "tainted"; }

  Errors taintErrs() { return null; }
  Errors errors() { return null; }

  void sink(Object o) {}

  void test() {
    Errors es0 = errors();
    es0.addAllErrors(taintErrs());
    sink(es0); // $hasTaintFlow

    sink(taintErrs().getAllErrors()); // $hasTaintFlow

    sink(taintErrs().getFieldError()); // $hasTaintFlow
    sink(taintErrs().getFieldError("field")); // $hasTaintFlow

    sink(taintErrs().getGlobalError()); // $hasTaintFlow
    sink(taintErrs().getGlobalErrors()); // $hasTaintFlow

    Errors es1 = errors();
    es1.reject(taint());
    sink(es1); // $hasTaintFlow

    Errors es2 = errors();
    es2.reject(taint(), null, "");
    sink(es2); // $hasTaintFlow

    Errors es3 = errors();
    es3.reject(taint(), new Object[]{}, "");
    sink(es3); // $hasTaintFlow

    Errors es4 = errors();
    es4.reject("", new Object[]{taint()}, "");
    sink(es4); // $hasTaintFlow

    Errors es5 = errors();
    es5.reject("", new Object[]{}, taint());
    sink(es5); // $hasTaintFlow

    Errors es6 = errors();
    es6.reject(taint(), "");
    sink(es6); // $hasTaintFlow

    Errors es7 = errors();
    es7.reject("", taint());
    sink(es7); // $hasTaintFlow

    Errors es8 = errors();
    es8.rejectValue("", taint(), new Object[]{}, "");
    sink(es8); // $hasTaintFlow

    Errors es9 = errors();
    es9.rejectValue("", "", new Object[]{taint()}, "");
    sink(es9); // $hasTaintFlow

    Errors es10 = errors();
    es10.rejectValue("", "", new Object[]{}, taint());
    sink(es10); // $hasTaintFlow

    Errors es11 = errors();
    es11.rejectValue("", taint(), "");
    sink(es11); // $hasTaintFlow

    Errors es12 = errors();
    es12.rejectValue("", "", taint());
    sink(es12); // $hasTaintFlow
  }
}
