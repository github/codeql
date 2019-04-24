extern int printf(const char *fmt, ...);

// For the following `...gettext` functions, we assume that
// all translations preserve the type and order of `%` specifiers
// (and hence are safe to use as format strings).  This is
// assumption is hard-coded into the query.

extern char *gettext (const char *__msgid);

extern char *dgettext (const char *__domainname, const char *__msgid);

extern char *dcgettext (const char *__domainname,
                        const char *__msgid, int __category);

extern char *ngettext (const char *__msgid1, const char *__msgid2,
                       unsigned long int __n);

extern char *dngettext (const char *__domainname, const char *__msgid1,
                        const char *__msgid2, unsigned long int __n);

extern char *dcngettext (const char *__domainname, const char *__msgid1,
                         const char *__msgid2, unsigned long int __n,
                         int __category);


extern char *any_random_function(const char *);

#define NULL ((void*)0)

// The `_` macro is treated specially.  While it is typically set to
// `gettext`, we allow it to point at any function.
#define _(X) my_gettext(X)

int main(int argc, char **argv) {
	if(argc > 1)
		printf(argv[1]);                   // not ok
	else
		printf("No argument supplied.\n"); // ok

	printf(_("No argument supplied.\n")); // ok

	printf(dgettext(NULL, "No argument supplied.\n")); // ok

	printf(ngettext("One argument\n", "%d arguments\n", argc-1), argc-1); // ok

	printf(gettext("%d arguments\n"), argc-1); // ok
	printf(any_random_function("%d arguments\n"), argc-1); // not ok

#undef _
	printf(_(any_random_function("%d arguments\n")),
			argc-1); // not ok

	return 0;
}
