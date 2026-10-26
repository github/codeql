void bad_server() {
  char* query = getenv("QUERY_STRING");
  puts("<p>Query results for ");
  // BAD: Printing out an HTTP parameter with no escaping
  puts(query);
  puts("\n<p>\n");
  puts(do_search(query));
}

void good_server() {
  char* query = getenv("QUERY_STRING");
  puts("<p>Query results for ");
  // GOOD: Escape HTML characters before adding to a page
  char* query_escaped = escape_html(query);
  puts(query_escaped);
  free(query_escaped);

  puts("\n<p>\n");
  puts(do_search(query));
}
