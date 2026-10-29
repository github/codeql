#if __has_feature(attribute_availability)
void f(void) __attribute__((availability(macosx,introduced=10.4,deprecated=10.6,obsoleted=10.7)));
#endif

#if __has_feature(attribute_availability_with_message)
void g(void) __attribute__((availability(ios,unavailable,message="Woah, don't use this.")));
#endif

void h(void);

void tententhree(void) __attribute__((availability(macosx,introduced=10.10.3,message = "Ten" "Ten" "Three")));
