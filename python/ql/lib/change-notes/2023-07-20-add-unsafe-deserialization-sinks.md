---
category: minorAnalysis
---
* Improved modeling of decoding through pickle related functions (which can lead to code execution), resulting in additional sinks for the _Deserializing untrusted input_ query (`py/unsafe-deserialization`). Added support for `pandas.read_pickle`, `numpy.load` and `joblib.load`.