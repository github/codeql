
void returnThreadLocal() {
  thread_local int threadLocal;
  int not_threadLocal;
  static thread_local int threadLocalStatic;
  extern thread_local int threadLocalExtern;
}
