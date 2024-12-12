import 'impl.just'
import? '../justfile'  # internal repo just file, if present

@_default:
    {{ just_executable() }} --list
