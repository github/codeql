// Semmle test case for rule CgiXss.ql (CGI script vulnerable to cross-site scripting)
// Associated with CWE-079: Cross-site Scripting. http://cwe.mitre.org/data/definitions/79.html

// Standard library routines
void free(void *ptr);
char *getenv(const char *name);
int printf(const char *format, ...);
int puts(const char *s);

// External routines
char* do_search(char* query);
char* escape_html(char* raw);

void bad_server1(char* query) {
  puts("<p>Query results for ");
  // BAD: Printing out an HTTP parameter with no escaping
  puts(query);
  puts("\n<p>\n");
  puts(do_search(query));
}

void bad_server2(char* query) {
  printf("<p>Query results for %s\n", query);
  // BAD: Printing out an HTTP parameter with no escaping
  puts("\n<p>");
  puts(do_search(query));
}

void good_server(char* query) {
  puts("<p>Query results for ");
  // GOOD: Escape HTML characters before adding to a page
  char* query_escaped = escape_html(query);
  puts(query_escaped);
  free(query_escaped);

  puts("\n<p>\n");
  puts(do_search(query));
}

int main(int argc, char** argv) {
  char* raw_query = getenv("QUERY_STRING");
  if (strcmp("good", argv[0]) == 0) {
    good_server(raw_query);
  } else if (strcmp("bad1", argv[0]) == 0) {
    bad_server1(raw_query);
  } else {
    bad_server2(raw_query);
  }
}

