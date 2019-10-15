import marshal
import tempfile


serialized = marshal.dumps({'a': 1})
print(marshal.loads(serialized))

file_obj = tempfile.TemporaryFile()
marshal.dump(range(5), file_obj)
file_obj.seek(0)
print(marshal.load(file_obj))
file_obj.close()
