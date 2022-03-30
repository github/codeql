void arrayParameter(int a[4]);
void pointerParameter(int *a);
void referenceParameter(int &n);

void constArrayParameter(const int a[4]);
void constPointerParameter(const int *a);
void constReferenceParameter(const int &n);

int caller(int n) {
  int uninitializedArray[4];

  arrayParameter(uninitializedArray);
  pointerParameter(uninitializedArray);

  constArrayParameter(uninitializedArray);
  constPointerParameter(uninitializedArray);

  int i1 = n;
  referenceParameter(i1);

  int i2 = n;
  pointerParameter(&i2);

  constPointerParameter(&i2);
  constReferenceParameter(i2);

  return uninitializedArray[0] + i1 + i2;
}

void loop(int n) {
  int arr[4] = {0};
  while (--n)
    arrayParameter(arr);
}

void loop2(int n) {
  int arr[4] = {0};

  while (--n) {
    pointerParameter(arr);
    arrayParameter(arr);
  }
}

int afterIf(int n) {
  int i = n;

  if (n) {
    i++;
  }
  // The following access to `i` should be the first control-flow node in its
  // basic block.
  referenceParameter(i);
  return i;
}
