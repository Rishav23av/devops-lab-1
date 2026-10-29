from flask import Flask, jsonify

app = Flask(__name__)
VERSION = "1.0.0"


@app.get("/")
def home():
    return jsonify(
        message="Welcome to Rishav's DevOps Lab 1",
        name="Rishav",
        roll_no="2301730245",
        version=VERSION,
    )


@app.get("/health")
def health():
    return jsonify(status="UP", version=VERSION)
