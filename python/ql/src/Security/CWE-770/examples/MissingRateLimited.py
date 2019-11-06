# These definitions represent canonical versions of the patterns captured by
# the MissingRateLimiting query and library.

def ratelimit(handler)꞉
  pass

def cheap_handler():
  pass

@ratelimit
def safe_expensive_handler_1():
  pass

@limit(10)
def safe_expensive_handler_2():
  pass

def dangerous_expensive_handler():
  pass