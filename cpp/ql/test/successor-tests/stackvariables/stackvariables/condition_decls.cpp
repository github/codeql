struct BoxedInt {
  BoxedInt(int x) {
    m_ptr = new int(x);
  }
  ~BoxedInt() {
    delete m_ptr;
  }
  operator int() {
    return *m_ptr;
  }

  int* m_ptr;
};

void if_decl_bind(int x) {
  if(BoxedInt bi = x) {
    ++*bi.m_ptr;
  }
  else {
    --*bi.m_ptr;
  }
  x = 1;
}

void switch_decl_bind(int x) {
  switch(BoxedInt bi = x) {
  case 0:
    --*bi.m_ptr;
    break;
  case 1:
    ++*bi.m_ptr;
    break;
  default:
    *bi.m_ptr /= 2;
    /* no break -- this is important */
  }
  x = 1;
}

void while_decl_bind(int x) {
  while(BoxedInt bi = x) {
    --x;
  }
  ++x;
}

void for_decl_bind(int x) {
  for(BoxedInt init = -x; BoxedInt bi = x; x *= 2) {
    ++x;
  }
  --x;
}
