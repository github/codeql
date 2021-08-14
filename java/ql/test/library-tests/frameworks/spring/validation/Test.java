import org.springframework.validation.Errors;

class ValidationErrorsTest {
  Object source() { return null; }

  Errors sourceErrs() { return (Errors)source(); }
  Errors errors() { return null; }

  void sink(Object o) {}

  void test() {
    Errors es0 = errors();
    es0.addAllErrors(sourceErrs());
    sink(es0); // $hasTaintFlow

    sink(sourceErrs().getAllErrors()); // $hasTaintFlow

    sink(sourceErrs().getFieldError()); // $hasTaintFlow
    sink(sourceErrs().getFieldError("field")); // $hasTaintFlow

    sink(sourceErrs().getGlobalError()); // $hasTaintFlow
    sink(sourceErrs().getGlobalErrors()); // $hasTaintFlow

    Errors es1 = errors();
    es1.reject((String)source());
    sink(es1); // $hasTaintFlow

    Errors es2 = errors();
    es2.reject((String)source(), null, "");
    sink(es2); // $hasTaintFlow

    Errors es3 = errors();
    es3.reject((String)source(), null, "");
    sink(es3); // $hasTaintFlow

    {
      Errors es4 = errors();
      Object[] in = { (String)source() };
      es4.reject("", in, "");
      sink(in); // $hasTaintFlow
    }

    {
      Errors es5 = errors();
      es5.reject("", null, (String)source());
      sink(es5); // $hasTaintFlow
    }

    Errors es6 = errors();
    es6.reject((String)source(), "");
    sink(es6); // $hasTaintFlow

    Errors es7 = errors();
    es7.reject("", (String)source());
    sink(es7); // $hasTaintFlow

    Errors es8 = errors();
    es8.rejectValue("", (String)source(), null, "");
    sink(es8); // $hasTaintFlow

    Errors es9 = errors();
    Object[] in = {source()};
    es9.rejectValue("", "", in, "");
    sink(es9); // $hasTaintFlow

    Errors es10 = errors();
    es10.rejectValue("", "", null, (String)source());
    sink(es10); // $hasTaintFlow

    Errors es11 = errors();
    es11.rejectValue("", (String)source(), "");
    sink(es11); // $hasTaintFlow

    Errors es12 = errors();
    es12.rejectValue("", "", (String)source());
    sink(es12); // $hasTaintFlow
  }
}
