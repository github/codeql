/*
 * In this example, the developer intended to use a semicolon but accidentally used a comma:
 */

enum privileges entitlements = NONE;

if (is_admin)
    entitlements = FULL, // BAD

restrict_privileges(entitlements);

/*
 * The use of a comma means that the first example is equivalent to this second example:
 */

enum privileges entitlements = NONE;

if (is_admin) {
    entitlements = FULL;
    restrict_privileges(entitlements);
}

/*
 * The indentation of the first example suggests that the developer probably intended the following code:
 */

enum privileges entitlements = NONE;

if (is_admin)
    entitlements = FULL; // GOOD

restrict_privileges(entitlements);
