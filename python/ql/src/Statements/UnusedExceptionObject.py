
def do_action_forgotten_raise(action):
    if action == "go":
        start()
    elif action == "stop":
        stop()
    else:
        ValueError(action)

def do_action(action):
    if action == "go":
        start()
    elif action == "stop":
        stop()
    else:
        raise ValueError(action)
