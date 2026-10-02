# import recipes from internal repo, if present
import? '../build_impl.just'
# otherwise, use the local versions
import 'build_impl.just'