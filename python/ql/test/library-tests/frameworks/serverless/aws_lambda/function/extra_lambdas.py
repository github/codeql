def handler1(event, context):
    ensure_tainted(event) # $ tainted
    return "Hello World!"

def handler2(event, context):
    ensure_tainted(event) # $ tainted
    return "Hello World!"

# This function is not mentioned in template.yml
# and so it is not receiving user input.
def non_handler(event, context):
    ensure_not_tainted(event)
    return "Hello World!"
