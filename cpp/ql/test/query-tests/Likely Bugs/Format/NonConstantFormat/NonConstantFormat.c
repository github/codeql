extern int printf(const char *fmt, ...);


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
#define _(X) any_random_function((X))

int main(int argc, char **argv) {
	if(argc > 1)
		printf(argv[1]);                   // not ok
	else
		printf("No argument supplied.\n"); // ok

	printf(_("No argument supplied.\n")); // not ok

	printf(dgettext(NULL, "No argument supplied.\n")); // ok

	printf(ngettext("One argument\n", "%d arguments\n", argc-1), argc-1); // ok

	printf(gettext("%d arguments\n"), argc-1); // ok
	printf(any_random_function("%d arguments\n"), argc-1); // not ok

	// Since `_` is mapped to `some_random_function` above,
	// the following call will be flagged.
	printf(_(any_random_function("%d arguments\n")),
			argc-1); // not ok

	return 0;
}
