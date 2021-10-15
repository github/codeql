// The Dining Philosophers.
//
// Classic example of deadlock.
//
// The philosophers sit in a circle. Each philosopher attempts
// to pick up the fork on their left and right. If all of the
// philosophers attempt to do this at the same time then deadlock
// can occur.

namespace std
{
	class mutex {
	public:
		void lock();
		void unlock();
		bool try_lock();
	};

	template <class Mutex1, class Mutex2, class... Mutexes> void lock (Mutex1& a, Mutex2& b, Mutexes&... cde);
	template <class Mutex1, class Mutex2, class... Mutexes> void unlock (Mutex1& a, Mutex2& b, Mutexes&... cde);
}

std::mutex fork1;
std::mutex fork2;
std::mutex fork3;
std::mutex fork4;
std::mutex fork5;

void eat(int ph);

void philosopher1() {
  for (;;) {
    fork1.lock();
    fork5.lock();
    eat(1);
    fork5.unlock();
    fork1.unlock();
  }
}

void philosopher2() {
  for (;;) {
    fork2.lock();
    fork1.lock();
    eat(2);
    fork1.unlock();
    fork2.unlock();
  }
}

void philosopher3() {
  for (;;) {
    fork3.lock();
    fork2.lock();
    eat(3);
    fork2.unlock();
    fork3.unlock();
  }
}

void philosopher4() {
  for (;;) {
    fork4.lock();
    fork3.lock();
    eat(4);
    fork3.unlock();
    fork4.unlock();
  }
}

void philosopher5() {
  for (;;) {
    fork5.lock();
    fork4.lock();
    eat(5);
    fork4.unlock();
    fork5.unlock();
  }
}
