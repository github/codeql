
from third_party import get_resource

def ignore_error(name):
    rsc = get_resource(name)
    rsc.initialize()
    try:
        use_resource(rsc)
    finally:
        rsc.close()

#Fixed
def do_not_ignore_error(name):
    rsc = get_resource(name)
    success = rsc.initialize()
    if not success:
        raise Error("Could not initialize resource")
    try:
        use_resource(rsc)
    finally:
        rsc.close()
