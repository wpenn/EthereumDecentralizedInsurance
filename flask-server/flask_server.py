#!flask/bin/python
from flask import Flask, jsonify, request, abort, make_response
import io
import csv
import requests
import json
from urllib.parse import urlparse

app = Flask(__name__)

#create local web API using flask
#routes the HTTP GET request to the path /[localhost]/get-contract-winner
#Instructions: Make API call giving input parameter of location and threshold (theoretically, threshold value will be set within contract when Oracle is called). For purposes of testing, use this format: http://127.0.0.1:5000/get-contract-winner/?location=Philadelphia&threshold=200 In this example, location parameter is set to Philadelphia and threshold is 200 Kelvins. Our custom web API will call the weather API, passing in the location value, fetching data, then compares the actual data with the expected threshold to see if the weather is above or below the threshold parameter. 

@app.route('/get-contract-winner/', methods=["GET"])
def transform_view():
    #parses through the API request to get input parameter of location and the threshold value from the smart contract
    if 'location' in request.args:
        location = str(request.args['location'])
        threshold = float(request.args['threshold'])

    #makes a call to the weather API based on input parameter for location
    r = requests.get('http://api.openweathermap.org/data/2.5/weather?q=' + location + ',us&APPID={YOUR-API-KEY}')
    # convert fetched data into json format
    json_data = json.loads(r.text)
    temp = json_data["main"]["temp"]
    temp_min = json_data["main"]["temp_min"]
    temp_max = json_data["main"]["temp_max"]
    base = json_data["base"]
    return weather_logic(temp, threshold)

#determine whether current weather temperature is above or below threshold so smart contract can determine whether payout is necessary
def weather_logic(temp, thresh):
    if temp > thresh:
        return "aboveThresh"
    else:
        return "belowThresh"

if __name__ == '__main__':
    app.run(debug=True)
