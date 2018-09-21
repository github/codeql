struct property {
  char *name;
  int value;
};

struct property * get_property(char *key);
struct property * get_property_default(char *key, int default_value);

void check_properties() {
  // this call will get flagged since most
  // calls to get_property handle NULL
  struct property *p1 = get_property("time");
  if(p1->value > 600) {
    ...
  }

  // this call will not get flagged since
  // the result of the call is checked for NULL
  struct property *p2 = get_property("time");
  if(p2 != NULL && p2->value > 600) {
    ...
  }

  // this call will not get flagged since calls
  // to get_property_default rarely handle NULL
  struct property *p3 = get_property_default("time", 50);
  if(p3->value > 60) {
    ...
  }
}
