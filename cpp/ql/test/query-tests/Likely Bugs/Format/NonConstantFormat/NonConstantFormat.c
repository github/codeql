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
#define _(X) gettext(X)

int main(int argc, char **argv) {
	if(argc > 1)
		printf(argv[1]);                   // BAD
	else
		printf("No argument supplied.\n"); // GOOD

	printf(_("No argument supplied.\n")); // GOOD

	printf(dgettext(NULL, "No argument supplied.\n")); // GOOD

	printf(ngettext("One argument\n", "%d arguments\n", argc-1), argc-1); // GOOD

	printf(gettext("%d arguments\n"), argc-1); // GOOD
	printf(any_random_function("%d arguments\n"), argc-1); // BAD



	printf(_(any_random_function("%d arguments\n")), argc-1); // BAD

	return 0;
}
