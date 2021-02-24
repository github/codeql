from flask import Flask

app = Flask(__name__)

@app.route('/crash')
def main():
    raise Exception()

# bad
app.run(debug=True)

# okay
app.run()
app.run(debug=False)

# also okay
run(debug=True)

app.notrun(debug=True)

# a slightly more involved example using flow and truthy values

DEBUG = True

app.run(debug=DEBUG) # NOT OK

DEBUG = 1

app.run(debug=DEBUG) # NOT OK

if False:
    app.run(debug=True)



runapp = app.run
runapp(debug=True) # NOT OK


# imports from other module
import settings
app.run(debug=settings.ALWAYS_TRUE) # NOT OK


# depending on environment values
import os

DEPENDS_ON_ENV = os.environ["ENV"] == "dev"

app.run(debug=DEPENDS_ON_ENV) # OK
