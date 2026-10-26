// GOOD: these header guards are sufficient. [FALSE POSITIVE]
#ifndef MULTIPLEGUARDS_H
#define MULTIPLEGUARDS_H

	int multiple_guards_var;

#endif /* MULTIPLEGUARDS_H */

#ifndef ADDITIONAL_MACRO
	#define ADDITIONAL_MACRO multiple_guards_var
#endif
