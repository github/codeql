std::mutex mtx1;
std::mutex mtx2;

void f1() {
  // GOOD: lock mtx1 before mtx2.
  mtx1.lock();
  mtx2.lock();
  printf("f1");
  mtx2.unlock();
  mtx1.unlock();
}

void f2() {
  // BAD: lock mtx2 before mtx1.
  mtx2.lock();
  mtx1.lock();
  printf("f2");
  mtx1.unlock();
  mtx2.unlock();
}
