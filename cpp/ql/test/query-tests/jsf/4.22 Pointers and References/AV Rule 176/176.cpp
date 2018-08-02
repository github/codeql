int add(int x, int y)
{
  return x + y;
}

int sub(int x, int y)
{
  return x + y;
}

typedef int(*operator_t)(int, int);

operator_t good_get_operator(bool which)
{
  return which ? add : sub;
}

int (*bad_get_operator(bool which))(int, int)
{
  return which ? add : sub;
}

typedef operator_t (*good_meta_t)(bool);
typedef int (*(*bad_meta_t)(bool))(int, int);

int good_call(operator_t op, int lhs, int rhs)
{
  return op(lhs, rhs);
}

int bad_call(int(*op)(int, int), int lhs, int rhs)
{
  return op(lhs, rhs);
}

typedef int (*good_call_t)(operator_t, int, int);
typedef int (*bad_call_t)(int(*)(int, int), int, int);

void usages()
{
  operator_t good_op = add;
  int (*bad_op)(int, int) = good_op;
  
  good_meta_t good_meta_1 = good_get_operator;
  bad_meta_t good_meta_2 = good_meta_1;
  
  good_call_t good_call_1 = good_call;
  bad_call_t good_call_2 = good_call_1;
}
