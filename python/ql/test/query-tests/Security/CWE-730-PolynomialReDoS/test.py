import re
from flask import Flask, request
app = Flask(__name__)

@app.route("/poly-redos")
def code_execution():
    text = request.args.get("text")
    re.sub(r"^\s+|\s+$", "", text) # NOT OK
    re.match(r"^0\.\d+E?\d+$", text) # NOT OK

    reg = re.compile(r"^\s+|\s+$")
    reg.sub("", text) # NOT OK

    def indirect(input_reg_str, my_text):
        my_reg = re.compile(input_reg_str)
        my_reg.sub("", my_text) # NOT OK

    indirect(r"^\s+|\s+$", text)

    reg2 = re.compile(r"(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)C.*Y")
    reg2.sub("", text) # NOT OK

