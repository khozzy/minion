from flask import Flask, jsonify

from minion.security.decorators import secured

app = Flask(__name__)


@app.route("/")
def hello_world():
    return jsonify({"message": "Hello, Stranger"})


@app.route("/api")
@secured
def api():
    return jsonify({"message": "Namaste"})
