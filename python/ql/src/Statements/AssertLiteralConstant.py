def buy_bananas(n):
    if n > 500:
        assert False, "Too many bananas."
    send_order("bananas", n)

def buy_bananas_correct(n):
    if n > 500:
        raise AssertionError("Too many bananas")
    send_order("bananas", n)
