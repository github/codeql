template <typename T>
struct vector
{
  T* begin() { return nullptr; }
  T* end() { return nullptr; }
};

template <typename T>
void stream_it(vector<T>& t)
{
  for(T& itr : t)
  {
  }
}

static int f()
{
  vector<int> xs;
  stream_it(xs);
  return 0;
}
