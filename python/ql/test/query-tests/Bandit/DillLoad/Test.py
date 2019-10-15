import dill
import StringIO

# dill
pick = dill.dumps({'a': 'b', 'c': 'd'})
print(dill.loads(pick))

file_obj = StringIO.StringIO()
dill.dump([1, 2, '3'], file_obj)
file_obj.seek(0)
print(dill.load(file_obj))

file_obj.seek(0)
print(dill.Undillr(file_obj).load())
