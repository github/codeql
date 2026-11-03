class BaseException {
public:
  virtual ~BaseException() {}
};

class DerivedException : public BaseException {
};

void catchByValueDerived() {
  try {
    throw DerivedException();
  } catch (DerivedException e) { } // $ Alert

  try {
    throw BaseException();
  } catch (BaseException e) { } // $ Alert

  try {
    throw DerivedException();
  } catch (DerivedException &e) { }

  try {
    throw DerivedException();
  } catch (BaseException &e) { }

  try {
    throw new BaseException();
  } catch (BaseException *e) { }

  try {
    throw DerivedException();
  } catch (...) { }
}
