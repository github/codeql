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

void good_server1(char* query) {
  puts("<p>Query results for ");
  // GOOD: Escape HTML characters before adding to a page
  char* query_escaped = escape_html(query);
  puts(query_escaped);
  free(query_escaped);

  puts("\n<p>\n");
  puts(do_search(query));
}

int sscanf(const char *s, const char *format, ...);

void good_server2(char* query) {
  puts("<p>Query results for ");
  // GOOD: Only an integer is added to the page.
  int i = 0;
  sscanf(query, "value=%i", &i);
  printf("\n<p>%i</p>\n", i);
}

typedef unsigned long size_t;
size_t strlen(const char *s);
char *strcpy(char *dst, const char *src);
char *strcat(char *s1, const char *s2);

void bad_server3(char* query) {
  char query_text[strlen(query) + 8];
  strcpy(query_text, "query: ");
  strcat(query_text, query);

  puts("<p>Query results for ");
  // BAD: Printing out an HTTP parameter with no escaping
  puts(query_text);
  puts("\n<p>\n");
}

int main(int argc, char** argv) {
  char* raw_query = getenv("QUERY_STRING");
  if (strcmp("good1", argv[0]) == 0) {
    good_server1(raw_query);
  } else if (strcmp("bad1", argv[0]) == 0) {
    bad_server1(raw_query);
  } else if (strcmp("bad2", argv[0]) == 0) {
    bad_server2(raw_query);
  } else if (strcmp("good2", argv[0]) == 0) {
    good_server2(raw_query);
  } else if (strcmp("bad3", argv[0]) == 0) {
    bad_server3(raw_query);
  }
}
