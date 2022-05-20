import cpp

// A function might have more than one block if it's used in more than one
// preprocessor context -- even if the preprocessor context does not affect the
// blocks.
from Function f
select f, f.getBlock(), count(f.getBlock())
