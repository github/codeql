void bad_remove_even_numbers(std::vector<int>& v) {
    // BAD: the iterator is invalidated after the call to `erase`.
  for(std::vector<int>::iterator it = v.begin(); it != v.end(); ++it) {
    if(*it % 2 == 0) {
      v.erase(it);
    }
  }
}

void good_remove_even_numbers(std::vector<int>& v) {
  // GOOD: `erase` returns the iterator to the next element.
  for(std::vector<int>::iterator it = v.begin(); it != v.end(); ) {
    if(*it % 2 == 0) {
      it = v.erase(it);
    } else {
      ++it;
    }
  }
}