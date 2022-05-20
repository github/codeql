struct IteratorT {
  IteratorT(int value) : m_value(value) {}
  
  int operator*() const { return m_value; }
  IteratorT& operator++() { ++m_value; return *this; }
  
private:
  int m_value;
};

bool operator!=(const IteratorT& lhs, const IteratorT& rhs) { return *lhs != *rhs; }

IteratorT first() {
  return IteratorT(0);
}

IteratorT last() {
  return IteratorT(10);
}

#include "common.h"
