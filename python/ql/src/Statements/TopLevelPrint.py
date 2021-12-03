
try:
    import fast_system as system
except ImportError:
    print ("Cannot import fast system, falling back on slow system")
    import slow_system as system

#Fixed version
import logging

try:
    import fast_system as system
except ImportError:
    logging.info("Cannot import fast system, falling back on slow system")
    import slow_system as system
