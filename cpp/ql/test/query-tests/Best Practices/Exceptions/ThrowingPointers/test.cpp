class MyException {
};

class OtherException {
};

// Microsoft MFC's CException hierarchy is intended to be thrown (and
// caught) as a pointer, so it should not be flagged.
class CException {
};

class CMyFrameworkException : public CException {
};

void throwsPointerToMyException() {
  throw new MyException(); // $ Alert
}

void throwsPointerToOtherException() {
  throw new OtherException(); // $ Alert
}

void throwsByValue() {
  throw MyException();
}

void throwsFrameworkExceptionPointer() {
  throw new CMyFrameworkException();
}
