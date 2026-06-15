int factor = atoi(getenv("BRANCHING_FACTOR"));

// BAD: This can allocate too little memory if factor is very large due to overflow.
char **root_node = (char **) malloc(factor * sizeof(char *));

// GOOD: Prevent overflow and unbounded allocation size by checking the input.
if (factor > 0 && factor <= 1000) {
    char **root_node = (char **) malloc(factor * sizeof(char *));
}
