
#define NULL (0)

// example from the qhelp
struct person {
  int id;
  char* name;
};

bool hasName(person* p) {
  return  p       != NULL  // This check is sensible,
      &&  p->name != NULL  // as is this one.
      && &p->name != NULL; // But this check is dubious. (BAD)
}

// another example
void assert(bool cond);

class myClass
{
public:
	myClass(myClass *ptr, myClass &ref) {
		assert(ptr != NULL);
		assert(y != NULL);
		assert(&y != NULL); // BAD [NOT DETECTED]
		assert(this->y != NULL);
		assert(&this->y != NULL); // BAD [NOT DETECTED]
		assert(ptr->y != NULL);
		assert(&ptr->y != NULL); // BAD
		assert((ptr->y) != NULL);
		assert(&(ptr->y) != NULL); // BAD
		assert(ref.y != NULL);
		assert(&(ref.y) != NULL); // BAD
	};

private:
	myClass *x, *y;
};
