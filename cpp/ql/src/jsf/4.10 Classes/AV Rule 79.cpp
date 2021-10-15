// This class opens a file but never closes it. Even its clients
// cannot close the file
class ResourceLeak {
private:
    int sockfd;
    FILE* file;
public:
    C() {
        sockfd = socket(AF_INET, SOCK_STREAM, 0);
    }

    void f() {
        file = fopen("foo.txt", "r");
        ...
    }
};

// This class relies on its client to release any stream it
// allocates. Note that this means the client must have
// intimate knowledge of the implementation of the class to
// decide whether it is safe to release the stream. 
class StreamPool {
private:
  Stream *instance;
public:
  Stream *createStream(char *name) {
    if (!instance) 
      instance = new Stream(name);
    return instance;
  }
}

// This class handles its resources, but does not do that in
// the constructor/destructor. It can be rewritten easily to
// be safer to use.
class StreamHandler {
private:
  char *_name;
  Stream *stream;
public:
  C(char *name) {
    _name = strdup(name):
  }
  void open() {
    stream = new Stream();
  }
  void close() {
    delete stream;
  }
  ~StreamHandler() {
    free(_name);
    // stream should be deleted here, not in close()
  }
}