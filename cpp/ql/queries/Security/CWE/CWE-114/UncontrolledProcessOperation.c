int main(int argc, char** argv) {
  char *lib = argv[2];
  
  // BAD: the user can cause arbitrary code to be loaded
  void* handle = dlopen(lib, RTLD_LAZY);
  
  // GOOD: only hard-coded libraries can be loaded
  void* handle2;

  if (!strcmp(lib, "inmem")) {
    handle2 = dlopen("/usr/share/dbwrap/inmem", RTLD_LAZY);
  } else if (!strcmp(lib, "mysql")) {
    handle2 = dlopen("/usr/share/dbwrap/mysql", RTLD_LAZY);
  } else {
    die("Invalid library specified\n");
  }
}
