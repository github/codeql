struct S {
	char* name;
};

void ArrayToPointer()
{
  char c[] = "hello";
  struct S s;
  s.name = c;
}
