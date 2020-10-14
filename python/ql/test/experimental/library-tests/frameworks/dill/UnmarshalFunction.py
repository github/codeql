import dill

dill.loads(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute() $UNSAFE_getFormat=dill
dill.loads(payload, encoding='latin1')  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute() $UNSAFE_getFormat=dill
