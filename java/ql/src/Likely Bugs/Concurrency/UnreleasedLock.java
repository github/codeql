public void m() {
   lock.lock();
   // A
   try {
      // ... method body
   } finally {
      // B
      lock.unlock();
   }
}