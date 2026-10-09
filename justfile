# see misc/just/README.md for an overview

import 'lib.just'
import 'misc/just/forward.just'

# bazel files live all over the repository rather than under any one language, so they
# are formatted from here. `format` itself is the forwarder, hence `_root_`; see
# misc/just/README.md.
_root_format *ARGS=".": (_format_bazel ARGS)
