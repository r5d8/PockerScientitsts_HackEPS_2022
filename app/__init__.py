# Import flask and template operators
from datetime import datetime, timedelta
from flask import Flask, jsonify, request
import uuid
from flask_cors import CORS

from main_pub import *



# Define the WSGI application object
app = Flask(__name__)
CORS(app, resources=r'*', origins=r'*')

# Configurations
app.config.from_object('config')

@app.errorhandler(404)
def not_found(error):
    return "<h1>404</h1><p>This route does not exist on our API, try again ;)</p>", 404

@app.route('/', methods=['GET'])
def homepage():
    return "Welcome to PokerScientists' api", 200

# Starts challenge 1 execution
@app.route('/challenge1', methods=['POST'])
def api_request_challenge_1():
    if not (request.json): return "ERROR: Please enter a JSON.", 400
    api_challenge_1_prolog(request.json)
    return "", 200

# Returns challenge 1's execution
@app.route('/challenge1', methods=['GET'])
def api_request_ended_challenge_1():
    json, optimum = api_ask_end()
    if (json == ""): return "", 204
    else: return json, 200

# Starts challenge 2 execution
@app.route('/challenge2', methods=['POST'])
def api_request_challenge_1():
    if not (request.json): return "ERROR: Please enter a JSON.", 400
    api_challenge_2_prolog(request.json)
    return "", 200

# Returns challenge 2's execution
@app.route('/challenge2', methods=['GET'])
def api_request_ended_challenge_2():
    json, optimum = api_ask_end_2()
    if (json == ""): return "", 204
    else: return json, 200