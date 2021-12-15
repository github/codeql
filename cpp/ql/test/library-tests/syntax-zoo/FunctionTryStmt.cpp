int foo() try {
  return 0;
}
catch(...) {
  throw;
}

class Bar
{
  Bar() try {
    return;
  }
  catch(...) {
    throw;
  }
};
