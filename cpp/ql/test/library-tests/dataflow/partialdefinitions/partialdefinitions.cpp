
struct MyStruct
{
	int x;
	struct MySubStruct {
		int z;
	} y;
};

void test()
{
	MyStruct s;

	s.x = 1;
	s.y.z = 1;
}

struct Int {
  int data;
  Int(int value) : data(value) { } // Not a partial definition but a `PostUpdateNode`
  int getData() const { return data; }
  void setData(int value) { data = value; }
};

int getSet() {
  Int myInt(1);
  myInt.setData(
      myInt.getData() + 1 // should not be a partial def
  );
  return myInt.getData(); // should not be a partial def
}
