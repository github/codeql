extern "C" int printf(const char *fmt, ...);
extern "C" int sprintf(char *buf, const char *fmt, ...);
extern "C" char *gettext (const char *);

#define MYSPRINTF sprintf

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
  printf(choose_message(argc - 1), argc - 1); // GOOD
  printf(messages[1]); // GOOD
  printf(message); // GOOD
  printf(make_message(argc - 1)); // BAD
  printf("Hello, World\n"); // GOOD
  printf(_("Hello, World\n")); // GOOD
  {
    char hello[] = "hello, World\n";
    hello[0] = 'H';
    printf(hello); // BAD
    printf(_(hello)); // GOOD
    printf(gettext(hello)); // GOOD
    printf(const_wash(hello)); // BAD
    printf((hello + 1) + 1); // BAD
    printf(+hello); // BAD
    printf(*&hello); // BAD
    printf(&*hello); // BAD
    printf((char*)(void*)+(hello+1) + 1); // BAD
  }
  printf(("Hello, World\n" + 1) + 1); // BAD
  {
    const char *hello = "Hello, World\n";
    printf(hello + 1); // BAD
    printf(hello); // GOOD
  }
  {
    const char *hello = "Hello, World\n";
    hello += 1;
    printf(hello); // BAD
  }
  {
    // Same as above block but using "x = x + 1" syntax
    const char *hello = "Hello, World\n";
    hello = hello + 1;
    printf(hello); // BAD
  }
  {
    // Same as above block but using "x++" syntax
    const char *hello = "Hello, World\n";
    hello++;
    printf(hello); // BAD
  }
  {
    // Same as above block but using "++x" as subexpression
    const char *hello = "Hello, World\n";
    printf(++hello); // BAD
  }
  {
    // Same as above block but through a pointer
    const char *hello = "Hello, World\n";
    const char **p = &hello;
    (*p)++;
    printf(hello); // BAD [NOT DETECTED]
  }
  {
    // Same as above block but through a C++ reference
    const char *hello = "Hello, World\n";
    const char *&p = hello;
    p++;
    printf(hello); // BAD [NOT DETECTED]
  }
  if (gettext_debug) {
    printf(new char[100]); // BAD
  }
  {
    const char *hello = "Hello, World\n";
    const char *const *p = &hello; // harmless reference to const pointer
    printf(hello); // GOOD
    hello++; // modification comes after use and so does no harm
  }
  printf(argc > 2 ? "More than one\n" : _("Only one\n")); // GOOD

  // This following is OK since a const literal is passed to const_wash()
  // and the taint tracker detects this.
  //
  //
  printf(const_wash("Hello, World\n")); // GOOD

  {
	char buffer[1024];

	MYSPRINTF(buffer, "constant"); // GOOD
	MYSPRINTF(buffer, argv[0]); // BAD
  }
}

const char *simple_func(const char *str) {
	return str;
}

void another_func(void) {
  const char *message = messages[2];
  printf(simple_func("Hello, World\n")); // GOOD
  printf(messages[1]); // GOOD
  printf(message); // GOOD
  printf("Hello, World\n"); // GOOD
  printf(gettext("Hello, World\n")); // GOOD
}

void set_value_of(int *i);

void print_ith_message() {
  int i;
  set_value_of(&i);
  printf(messages[i], 1U); // GOOD
}
