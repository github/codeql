from configparser import RawConfigParser
from flask import Flask, request

app = Flask(__name__)


@app.route("/unsafe1")
def unsafe1():
    # Retrieve the user input
    user_input = request.args.get("ui")

    # Create an instance of RawConfigParser
    config = RawConfigParser()

    # Add some configuration data
    config.add_section("Section1")
    config.set("Section1", "key1", "value1")
    config.set("Section1", "key2", user_input)
