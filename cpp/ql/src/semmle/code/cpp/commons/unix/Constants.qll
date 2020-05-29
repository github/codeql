/**
 * Standard Unix constants.
 */

import cpp

/**
 * Gets the number corresponding to the contents of `input` in base-8.
 * Note: the first character of `input` must be `0`. For example:
 * `parseOctal("012345") = 5349`.
 */
bindingset[input]
int parseOctal(string input) {
  input.charAt(0) = "0" and
  result =
    strictsum(int ix |
      ix in [0 .. input.length()]
    |
      8.pow(input.length() - (ix + 1)) * input.charAt(ix).toInt()
    )
}

/** Gets the number corresponding to the "set-user-ID on execute bit" in Unix. */
int s_isuid() { result = parseOctal("04000") }

/** Gets the number corresponding to the "set-group-ID on execute bit" in Unix. */
int s_isgid() { result = parseOctal("02000") }

/** Gets the number corresponding to the sticky bit in Unix. */
int s_isvtx() { result = parseOctal("01000") }

/** Gets the number corresponding to the read permission bit for owner of the file in Unix. */
int s_irusr() { result = parseOctal("0400") }

/** Gets the number corresponding to the write permission bit for owner of the file in Unix. */
int s_iwusr() { result = parseOctal("0200") }

/** Gets the number corresponding to the execute permission bit for owner of the file in Unix. */
int s_ixusr() { result = parseOctal("0100") }

/** Gets the number corresponding to the permissions `S_IRUSR | S_IWUSR | S_IXUSR` in Unix. */
int s_irwxu() { result = s_irusr().bitOr(s_iwusr()).bitOr(s_ixusr()) }

/**
 * Gets the number corresponding to the read permission bit for the group
 * owner of the file in Unix.
 */
int s_irgrp() { result = s_irusr().bitShiftRight(3) }

/**
 * Gets the number corresponding to the write permission bit for the group
 * owner of the file in Unix.
 */
int s_iwgrp() { result = s_iwusr().bitShiftRight(3) }

/**
 * Gets the number corresponding to the execute permission bit for the group
 * owner of the file in Unix.
 */
int s_ixgrp() { result = s_ixusr().bitShiftRight(3) }

/** Gets the number corresponding to the permissions `S_IRGRP | S_IWGRP | S_IXGRP` in Unix. */
int s_irwxg() { result = s_irwxu().bitShiftRight(3) }

/** Gets the number corresponding to the read permission bit for other users in Unix. */
int s_iroth() { result = s_irgrp().bitShiftRight(3) }

/** Gets the number corresponding to the write permission bit for other users in Unix. */
int s_iwoth() { result = s_iwgrp().bitShiftRight(3) }

/** Gets the number corresponding to the execute-or-search permission bit for other users in Unix. */
int s_ixoth() { result = s_ixgrp().bitShiftRight(3) }

/** Gets the number corresponding to the permissions `S_IROTH | S_IWOTH | S_IXOTH` in Unix. */
int s_irwxo() { result = s_irwxg().bitShiftRight(3) }

/**
 * Gets the number that can be used in a bitwise and with the file status flag
 * to produce a number representing the file access mode.
 */
int o_accmode() { result = parseOctal("0003") }

/** Gets the number corresponding to the read-only file access mode. */
int o_rdonly() { result = parseOctal("00") }

/** Gets the number corresponding to the write-only file access mode. */
int o_wronly() { result = parseOctal("01") }

/** Gets the number corresponding to the read-and-write file access mode. */
int o_rdwr() { result = parseOctal("02") }

/** Gets the number corresponding to the file creation flag O_CREAT on Linux. */
int o_creat() { result = parseOctal("0100") }

/** Gets the number corresponding to the file creation flag O_EXCL on Linux. */
int o_excl() { result = parseOctal("0200") }
