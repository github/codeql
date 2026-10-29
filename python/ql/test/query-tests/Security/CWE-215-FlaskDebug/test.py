from flask import Flask

app = Flask(__name__)

@app.route('/crash')
def main():
    raise Exception()

# bad
app.run(debug=True) # $ Alert
app.run('host', 8080, True) # $ Alert

# okay
app.run()
app.run(debug=False)

# also okay
run(debug=True)

app.notrun(debug=True)

# a slightly more involved example using flow and truthy values

DEBUG = True

app.run(debug=DEBUG) # $ Alert # NOT OK

DEBUG = 1

app.run(debug=DEBUG) # $ Alert # NOT OK

if False:
    app.run(debug=True)



runapp = app.run
runapp(debug=True) # $ Alert # NOT OK


# imports from other module
import settings
app.run(debug=settings.ALWAYS_TRUE) # $ Alert # NOT OK


# depending on environment values
import os

DEPENDS_ON_ENV = os.environ["ENV"] == "dev"

app.run(debug=DEPENDS_ON_ENV) # OK
