lgtm,codescanning
* Improved modeling of decoding through pickle related functions (which can lead to code execution), resulting in additional sinks for the _Deserializing untrusted input_ query (`py/unsafe-deserialization`). Now we fully support `pickle.load`, `pickle.loads`, `pickle.Unpickler`, `marshal.load`, `marshal.loads`, `dill.load`, `dill.loads`, `shelve.open`.
