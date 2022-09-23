/*
 * Here, the comma should have been a semicolon:
 */

enum privileges entitlements = NONE;

if (is_admin)
    entitlements = FULL, // BAD

restrict_privileges(entitlements);

/*
 * This is misleading, because the code is unexpectedly equivalent to:
 */

enum privileges entitlements = NONE;

if (is_admin) {
    entitlements = FULL;
    restrict_privileges(entitlements);
}

/*
 * Whereas the following code was probably intended:
 */

enum privileges entitlements = NONE;

if (is_admin)
    entitlements = FULL; // GOOD

restrict_privileges(entitlements);
