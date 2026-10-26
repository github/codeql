
int global;

typedef struct
{
  int *x, y;
} s;

void access(int param)
{
  s my_s;

  global = 1;

  my_s.x = &(my_s.y);

  access(param);
}

typedef enum {
  MYENUMCONST = 1,
} myEnum;

void more_accesses()
{
  void (*fn_ptr)() = &more_accesses;
  myEnum me = MYENUMCONST;
}
