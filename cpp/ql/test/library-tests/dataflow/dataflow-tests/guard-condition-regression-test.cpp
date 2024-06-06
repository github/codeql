int source();
void gard_condition_sink(int);
void use(int);
/*
  This test checks that we hit the node corresponding to the expression node that wraps `source`
  in the condition `source >= 0`. 
*/
void test_guard_condition(int source, bool b)
{
  if (b) {
    use(source);
  }

  if (source >= 0) {
    use(source);
  }

  gard_condition_sink(source); // clean
}