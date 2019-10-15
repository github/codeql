import cPickle
import pickle
import StringIO


# pickle
pick = pickle.dumps({'a': 'b', 'c': 'd'})
print(pickle.loads(pick))

file_obj = StringIO.StringIO()
pickle.dump([1, 2, '3'], file_obj)
file_obj.seek(0)
print(pickle.load(file_obj))

file_obj.seek(0)
print(pickle.Unpickler(file_obj).load())

# cPickle
serialized = cPickle.dumps({(): []})
print(cPickle.loads(serialized))

file_obj = StringIO.StringIO()
cPickle.dump((1,), file_obj)
file_obj.seek(0)
print(cPickle.load(file_obj))

file_obj.seek(0)
print(cPickle.Unpickler(file_obj).load())

