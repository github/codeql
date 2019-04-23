extern "C" int printf(const char *fmt, ...);
extern "C" int sprintf(char *buf, const char *fmt, ...);
extern "C" char *gettext (const char *);

bool gettext_debug = false;

const char *messages[] = {
    "All tasks done\n",
    "One task left\n",
    "%u tasks left\n",
};

const char *choose_message(unsigned int n) {
  if (n == 0) {
    const char *message = messages[0];
    return message;
  } else {
    return n == 1
         ? messages[n]
         : messages[sizeof messages / sizeof *messages - 1];
  }
}

const char *make_message(unsigned int n) {
  static char buf[64];
  sprintf(buf, "%d tasks left\n", n); // ok
  return buf;
}

// This is meant to simulate a typical gettext wrapper function
const char *_(const char *str) {
  if (gettext_debug) {
    return "#";
  }
  return str ? gettext(str) : "NULL";
}

// Attempt to "const-wash" a non-const string. Should be detected.
const char *const_wash(char *str) {
  return str;
}

int main(int argc, char **argv) {
  const char *message = messages[2];
  printf(choose_message(argc - 1), argc - 1); // OK
  printf(messages[1]); // OK
  printf(message); // OK
  printf(make_message(argc - 1)); // NOT OK
  printf("Hello, World\n"); // OK
  printf(_("Hello, World\n")); // OK
  {
    char hello[] = "hello, World\n";
    hello[0] = 'H';
    printf(hello); // NOT OK
    printf(_(hello)); // OK
    printf(gettext(hello)); // OK
    printf(const_wash(hello)); // NOT OK
    printf((hello + 1) + 1); // NOT OK
    printf(+hello); // NOT OK
    printf(*&hello); // NOT OK
    printf(&*hello); // NOT OK
    printf((char*)(void*)+(hello+1) + 1); // NOT OK
  }
  printf(("Hello, World\n" + 1) + 1); // NOT OK
  {
    const char *hello = "Hello, World\n";
    printf(hello + 1); // NOT OK
    printf(hello); // OK
  }
  {
    const char *hello = "Hello, World\n";
    hello += 1;
    printf(hello); // NOT OK
  }
  {
    // Same as above block but using "x = x + 1" syntax
    const char *hello = "Hello, World\n";
    hello = hello + 1;
    printf(hello); // NOT OK
  }
  {
    // Same as above block but using "x++" syntax
    const char *hello = "Hello, World\n";
    hello++;
    printf(hello); // NOT OK
  }
  {
    // Same as above block but using "++x" as subexpression
    const char *hello = "Hello, World\n";
    printf(++hello); // NOT OK
  }
  {
    // Same as above block but through a pointer
    const char *hello = "Hello, World\n";
    const char **p = &hello;
    (*p)++;
    printf(hello); // NOT OK
  }
  {
    // Same as above block but through a C++ reference
    const char *hello = "Hello, World\n";
    const char *&p = hello;
    p++;
    printf(hello); // NOT OK
  }
  if (gettext_debug) {
    printf(new char[100]); // NOT OK
  }
  {
    const char *hello = "Hello, World\n";
    const char *const *p = &hello; // harmless reference to const pointer
    printf(hello); // OK
    hello++; // modification comes after use and so does no harm
  }
  printf(argc > 2 ? "More than one\n" : _("Only one\n")); // OK

  // This following is OK since a const literal is passed to const_wash()
  // and the taint tracker detects this.
  //
  //
  printf(const_wash("Hello, World\n")); // OK
}

const char *simple_func(const char *str) {
	return str;
}

void another_func(void) {
  const char *message = messages[2];
  printf(simple_func("Hello, World\n")); // OK
  printf(messages[1]); // OK
  printf(message); // OK
  printf("Hello, World\n"); // OK
  printf(gettext("Hello, World\n")); // OK
}