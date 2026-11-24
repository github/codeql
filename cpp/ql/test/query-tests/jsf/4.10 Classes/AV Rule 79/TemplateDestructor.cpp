template <typename T>
class TemplateArray {
public:
  TemplateArray() : ptr(nullptr) {}

  ~TemplateArray() {
    reset();
  }

  void init(unsigned size) {
    ptr = new T[size]; // GOOD
  }

  void reset() {
    T *tmp = ptr;
    ptr = nullptr;
    delete[] tmp;
  }

private:
  T *ptr;
};

class NonTemplateArray {
public:
  NonTemplateArray() : ptr(nullptr) {}

  ~NonTemplateArray() {
    reset();
  }

  void init(unsigned size) {
    ptr = new int[size]; // GOOD
  }

  void reset() {
    int *tmp = ptr;
    ptr = nullptr;
    delete[] tmp;
  }

private:
  int *ptr;
};

class OverwrittenAlias {
public:
  OverwrittenAlias() : ptr(nullptr) {}

  ~OverwrittenAlias() {
    reset();
  }

  void init(unsigned size) {
    ptr = new int[size]; // $ Alert
  }

  void reset() {
    int *tmp = ptr;
    tmp = new int[1];
    delete[] tmp;
  }

private:
  int *ptr;
};

void testArrays() {
  TemplateArray<int> templateArray;
  templateArray.init(10);

  NonTemplateArray nonTemplateArray;
  nonTemplateArray.init(10);

  OverwrittenAlias overwrittenAlias;
  overwrittenAlias.init(10);
}
