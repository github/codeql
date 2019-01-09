struct HasDtor {
  int x;
  ~HasDtor();
};

int destructors_main(HasDtor p) {
  HasDtor fscope;
  {
    HasDtor inner;
    if (p.x == 1) {
      return 1;
    }
    ;
  }
  if (p.x == 2) {
    return 2;
  }
  ;
  return 3;
  ;
}


void destructor_after_handler() {
  HasDtor x;

  try {
  } catch (const HasDtor&) {
    return;
  }
}

void destructor_catch() {
  try {
  } catch (HasDtor d) {
    HasDtor d2 = { 0 };
  }
}
