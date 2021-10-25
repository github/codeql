
# A class to demonstrate tracking of tainted attributes.
class Task(object):

    def __init__(self, worker):
        self.worker = worker

def assign_task(worker):
    # The Task object will have its .worker attribute with whatever taint `worker`
    return Task(worker)

def lunch(worker):
    return worker

# The engineers go to a meeting
def example1():
    worker = ENGINEER
    meeting(worker)

# The engineers go to a meeting, but might need to skip lunch
def example2():
    worker = ENGINEER
    worker = lunch(worker)
    meeting(worker)

# Everyone goes to a meeting (but that's OK for the managers)
def example3():
    worker = ENGINEER
    meeting(worker)

#Tracking taint of an attribute.
def example4():
    worker = ENGINEER
    task = assign_task(worker)
    #Here 'task' has its .worker attribute "tainted"
    #Task team lunch
    worker = lunch(task.worker)
    #And meeting
    meeting(worker)

#A fire -- A barrier to all kinds of taint.
def example5():
    worker = ENGINEER
    worker = fire(worker)
    meeting(worker)

#Some context sensitive flow
def cubical(worker):
    ''' The flow here is context sensitive.
        In example6 the worker can be any engineer,
        but in example7 is cannot be Wally.
    '''
    return worker

# Workers go back to their cubicals
def example6():
    worker = ENGINEER
    worker = cubical(worker)
    #And meeting
    meeting(worker)

# Workers have lunch, then go back to their cubicals
def example7():
    worker = ENGINEER
    worker = lunch(worker)
    worker = cubical(worker)
    #And meeting
    meeting(worker)

