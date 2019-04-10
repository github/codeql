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

app.run(debug=DEBUG)

DEBUG = 1

app.run(debug=DEBUG)

if False:
    app.run(debug=True)



runapp = app.run
runapp(debug=True)
