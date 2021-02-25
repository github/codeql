try:
    1+2
except Exception as e:  #$ exceptionSource errorInfoSource
    e

def test_exception():
    try:
        1+2
    except Exception as e:  #$ exceptionSource errorInfoSource
        e
