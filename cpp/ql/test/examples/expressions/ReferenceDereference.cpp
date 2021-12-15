/*
  there is an implicit compiler-generated dereference node before the access to the variable 'i'
*/
void ReferenceDereference(int &i, int j) {
  j = i;
}