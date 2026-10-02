// --- definitions ---

class MyException {
public:
  void ReportError() {}
  void Delete() {}
};

class OtherException {
public:
  void ReportError() {}
};

void handle(OtherException *e) {}

// --- test cases ---

void leakyCatchEmpty() {
  try {
    // ...
  } catch (MyException *e) { } // $ Alert
}

void leakyCatchNoDelete() {
  try {
    // ...
  } catch (OtherException *e) { e->ReportError(); } // $ Alert
}

void catchWithDeleteMethodCall() {
  try {
    // ...
  } catch (MyException *e) {
    e->ReportError();
    e->Delete();
  }
}

void catchWithOperatorDelete() {
  try {
    // ...
  } catch (MyException *e) {
    e->ReportError();
    delete e;
  }
}

void catchWithPassToFunction() {
  try {
    // ...
  } catch (OtherException *e) {
    handle(e);
  }
}

void catchByValueNotPointer() {
  try {
    // ...
  } catch (MyException e) { }
}
