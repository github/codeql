// Semmle test cases for rule CWE-764


// Library code

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

// Test code

// BAD
void test_1()
{
	std::mutex mtx;
	mtx.lock();
	mtx.lock();
	mtx.unlock();
}

// GOOD
void test_2()
{
	std::mutex mtx;
	mtx.lock();
	mtx.lock();
	mtx.unlock();
	mtx.unlock();
}

// GOOD
void test_3()
{
	std::mutex mtx;
	mtx.lock();
	mtx.unlock();
	mtx.lock();
	mtx.unlock();
}

// BAD
void test_4(bool something)
{
	std::mutex mtx;
	mtx.lock();
	if (something) {
		mtx.unlock();
	} else {

	}
}

// GOOD
void test_5(bool something)
{
	std::mutex mtx;
	mtx.lock();
	if (something) {
	} else {
	}
	mtx.unlock();
}

// GOOD
void test_6()
{
	std::mutex mtx1;
	std::mutex mtx2;
	std::lock(mtx1, mtx2);
	mtx1.unlock();
	mtx2.unlock();
}

// GOOD
void test_7()
{
	std::mutex mtx1;
	std::mutex mtx2;
	mtx1.lock();
	mtx2.lock();
	std::unlock(mtx1, mtx2);
}

// GOOD
void test_8()
{
	std::mutex mtx;
	if (mtx.try_lock()) {
		mtx.unlock();
	} else {

	}
}

// BAD
void test_9()
{
	std::mutex mtx;
	if (mtx.try_lock()) {
		return;
	}
	mtx.unlock();
	return;
}

std::mutex static_mtx01;

// Helper function for testing the inter-procedural analysis.
void set01() {
	static_mtx01.lock();
}

// Helper function for testing the inter-procedural analysis.
void unset01() {
	static_mtx01.unlock();
}

// GOOD.
void interproc_test_01() {
	set01();
	unset01();
}

std::mutex static_mtx02;

// Helper function for testing the inter-procedural analysis.
void set02() {
	static_mtx02.lock();
}

// Helper function for testing the inter-procedural analysis.
void unset02() {
	static_mtx02.unlock();
}

// BAD.
void interproc_test_02() {
	set02();
	set02();
	unset02();
}

std::mutex static_mtx03;

// Helper function for testing the inter-procedural analysis.
void set03() {
	static_mtx03.lock();
}

// Helper function for testing the inter-procedural analysis.
void unset03() {
	static_mtx03.unlock();
}

// BAD.
void interproc_test_03(int n) {
	set03();
	if (n < 10) {
		// BAD: recursive call will attempt to lock the mutex again.
		interproc_test_03(n+1);
	}
	unset03();
}

// BAD.
void interproc_test_04(int n) {
	static std::mutex mtx;
	mtx.lock();
	if (n < 10) {
		// BAD: recursive call will attempt to lock the mutex again.
		interproc_test_04(n+1);
	}
	mtx.unlock();
}

// GOOD.
void interproc_test_05(int n) {
	static std::mutex mtx;
	mtx.lock();
	if (n < 10) {
		mtx.unlock();
		interproc_test_05(n+1);
		mtx.lock();
	}
	mtx.unlock();
}

// Helper function for testing the inter-procedural analysis.
void set(std::mutex& mtx) {
	mtx.lock();
}

// Helper function for testing the inter-procedural analysis.
void unset(std::mutex& mtx) {
	mtx.unlock();
}

// GOOD.
void interproc_test_06() {
	std::mutex mtx;
	set(mtx);
	unset(mtx);
}

// BAD.
void interproc_test_07() {
	std::mutex mtx;
	set(mtx);
	set(mtx);
	unset(mtx);
}

// BAD.
void interproc_test_08(std::mutex &mtx, int n) {
	set(mtx);
	if (n < 10) {
		// BAD: recursive call will attempt to lock the mutex again.
		interproc_test_08(mtx, n+1);
	}
	unset(mtx);
}

// GOOD.
void interproc_test_09(std::mutex &mtx, int n) {
	mtx.lock();
	if (n < 10) {
		mtx.unlock();
		interproc_test_09(mtx, n+1);
		mtx.lock();
	}
	mtx.unlock();
}

class mutexGuard
{
private:
	std::mutex* m;
public:
	mutexGuard(std::mutex& mtx);
	~mutexGuard();
};

mutexGuard::mutexGuard(std::mutex& mtx) :
	m(&mtx)
{
	m->lock();
}

mutexGuard::~mutexGuard()
{
	m->unlock();
}

// GOOD.
void raii_test_01() {
	std::mutex mtx;

	{
		mutexGuard g(mtx);
	}

	{
		mutexGuard g(mtx);
	}
}

// GOOD.
void raii_test_02(int n) {
	std::mutex mtx;

	for (int i = 0; i < n; i++)
	{
		mutexGuard g(mtx);
	}
}

std::mutex static_mtx09;

// Helper function for testing the inter-procedural analysis.
void unset09() {
	static_mtx09.unlock();
}

// GOOD.
void interproc_test_09() {
	static_mtx09.lock();
	unset09();
}

// GOOD
void test_10()
{
	std::mutex mtx;
	if (!mtx.try_lock()) { // [FALSE POSITIVE]
	} else {
		mtx.unlock();
	}
}

// GOOD
void test_11()
{
	std::mutex mtx;
	if (!mtx.try_lock()) { // [FALSE POSITIVE]
		return;
	}
	
	mtx.unlock();
}

// BAD
void test_12()
{
	std::mutex mtx;
	if (mtx.try_lock()) { // [NOT REPORTED]
		return;
	}
}

void unlock_lock(std::mutex &mtx)
{
	mtx.unlock();
	mtx.lock();
}

// GOOD
void interproc_test_10()
{
	std::mutex mtx;
	
	mtx.lock();
	unlock_lock(mtx);
	mtx.unlock();
}

// BAD
void interproc_test_11()
{
	std::mutex mtx;
	
	mtx.lock();
	unlock_lock(mtx); // [NOT REPORTED]
}

// BAD
void twice_locked_1()
{
	std::mutex mtx;
	
	mtx.lock();
	mtx.lock();
	mtx.unlock();
	mtx.unlock();
}

// GOOD
void twice_locked_2()
{
	std::mutex mtx;
	
	mtx.lock();
	mtx.unlock();
	mtx.lock();
	mtx.unlock();
}

// BAD
void twice_locked_3()
{
	std::mutex mtx;

	if (mtx.try_lock())
	{
		mtx.lock();
		mtx.unlock();
		mtx.unlock();
	}
}

std::mutex static_mtx_01a, static_mtx_01b;

// BAD
void lock_order_1(int cond)
{
	static_mtx_01a.lock();
	static_mtx_01b.lock();
	static_mtx_01b.unlock();
	static_mtx_01a.unlock();
	
	static_mtx_01b.lock();
	static_mtx_01a.lock();
	static_mtx_01a.unlock();
	static_mtx_01b.unlock();
}

std::mutex static_mtx_02a, static_mtx_02b;

// GOOD
void lock_order_2(int cond)
{
	std::mutex a, b;

	static_mtx_02a.lock();
	static_mtx_02b.lock();
	static_mtx_02b.unlock();
	static_mtx_02a.unlock();
	
	static_mtx_02a.lock();
	static_mtx_02b.lock();
	static_mtx_02b.unlock();
	static_mtx_02a.unlock();
}

struct mutex_t {
  int state;
};

int mutex_lock(mutex_t *m);
int mutex_unlock(mutex_t *m);

#define LOCK_SUCCESS (1)
#define LOCK_FAIL (1)

struct data_t {
  int val;
  mutex_t mutex;
};

#define CHECK(x) if (x == LOCK_FAIL) return false

bool test_mutex(data_t *data)
{
	CHECK(mutex_lock(&(data->mutex))); // GOOD [FALSE POSITIVE]
	data->val = 1;
	CHECK(mutex_unlock(&(data->mutex)));

	return true;
}

// ---

struct pthread_mutex
{
	// ...
};

void pthread_mutex_lock(pthread_mutex *m);
void pthread_mutex_unlock(pthread_mutex *m);

class MyClass
{
public:
	pthread_mutex lock;
};

bool maybe();

int test_MyClass_good(MyClass *obj)
{
	pthread_mutex_lock(&obj->lock);
	
	if (maybe()) {
		pthread_mutex_unlock(&obj->lock);
		return -1; // GOOD
	}

	pthread_mutex_unlock(&obj->lock); // GOOD
	return 0;
}

int test_MyClass_bad(MyClass *obj)
{
	pthread_mutex_lock(&obj->lock);

	if (maybe()) {
		return -1; // BAD
	}

	pthread_mutex_unlock(&obj->lock); // GOOD
	return 0;
}
