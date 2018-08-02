struct S {
	char* name;
};

void v()
{
  char c[] = "hello";
  struct S s;
  s.name = c;
}
