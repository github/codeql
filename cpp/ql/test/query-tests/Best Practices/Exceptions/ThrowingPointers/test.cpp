class MyException {
};

void throwsPointer1() {
  throw new MyException(); // $ Alert
}

void throwsPointer2() {
  MyException *e = new MyException();

  throw e; // $ MISSING: Alert
}

void throwsByValue() {
  throw MyException();
}

// Microsoft MFC's CException hierarchy is intended to be thrown (and
// caught) as a pointer, so it should not be flagged.
class CException {
};

class CMyFrameworkException : public CException {
};

void throwsFrameworkExceptionPointer() {
  throw new CMyFrameworkException();
}
