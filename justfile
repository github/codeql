import 'build.just'
import 'test.just'
import 'install.just'
import? 'local.just'

mod rust

@_default:
    {{ just_executable() }} --list --list-submodules
