extern int printf(const char *fmt, ...);

// For the following `...gettext` functions, we assume that
// all translations preserve the type and order of `%` specifiers
// (and hence are safe to use as format strings).  This
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

#define _(X) my_gettext(X)

int main(int argc, char **argv) {
	if(argc > 1)
		printf(argv[1]);                  // NOT OK
	else
		printf("No argument supplied.\n"); // OK

	printf(_("No argument supplied.\n")); // NOT OK

	printf(dgettext(NULL, "No argument supplied.\n")); // OK

	printf(ngettext("One argument\n", "%d arguments\n", argc-1), argc-1); // OK

	printf(gettext("%d arguments\n"), argc-1); // OK
	printf(any_random_function("%d arguments\n"), argc-1); // NOT OK

#undef _
    /* The special `..gettext..` functions are allowed arbitrary arguments */
	printf(_(any_random_function("%d arguments\n")),  // OK
			argc-1);
	printf(_("%d more arguments\n"),  // OK
			argc-1);

	return 0;
}
