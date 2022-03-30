def pointless_else(container):
    for item in container:
        if of_interest(item):
            return item
    else:
        raise NotFoundException()

def no_else(container):
    for item in container:
        if of_interest(item):
            return item
    raise NotFoundException()

def with_break(container):
    for item in container:
        if of_interest(item):
            found = item
            break
    else:
        raise NotFoundException()
    return found
