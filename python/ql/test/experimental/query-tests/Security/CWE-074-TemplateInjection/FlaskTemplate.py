from flask import Flask, request


app = Flask(__name__)


@app.route("/")
def home():
    from flask import render_template_string
    if request.args.get('template'):
        return render_template_string(request.args.get('template'))


@app.route("/a")
def a(): 
    import flask   
    return flask.render_template_string(request.args.get('template'))
    


if __name__ == "__main__":
    app.run(debug=True)
