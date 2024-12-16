# import base recipes from internal repo, if present
import? '../impl.just'
# otherwise, use the local version of recipes
import 'impl.just'
import 'install.just'
import? 'local.just'

mod rust

@_default:
    {{ just_executable() }} --list --list-submodules
