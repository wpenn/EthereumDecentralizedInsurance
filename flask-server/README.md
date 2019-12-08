# Flask Server

## Description

Creates web API using Python Flask, which serves as the Oracle that the smart contract calls periodically to determine whether the parameter is above or below the parameter threshold. Currently, the web API is hosted on a local server but next steps will include migrating to an AWS server. The web API routes the HTTP GET request to the path /[localhost]/get-contract-winner. and makes a call to an external weather API giving input parameters of location and and weather temperature threshold. When the smart contract calls our web API, the Oracle, it passes in theses input parameters. Once our Oracle calls the weather API, passing in the location. parameter, it fetches the data in JSON format, parses through it and compares the actual data with the expected threshold to see if the weather temperature is above or below it.

## Install

- Install Python Flask library 
- Install any other libraries or extensions used in the oracle_server.py 
'''mkdir myProject'''
'''cd myProject'''
'''python'''
'''pip install Flask'''
'''pip3 install requests'''

## Run

'''cd /PATH/TO/YOUR/FOLDER/flask-server'''
'''python oracle_server.py'''

For purposes of testing the local web API, choose a city and a parameter threshold which is a temperature value in Kelvins. These will be your input parameters when you call the web API in this format http://127.0.0.1:5000/get-contract-winner/?location=Philadelphia&threshold=200. In this example, the location is Philadelphia and the threshold is 200 Kelvins. Enter this URL in your browser. It should return “aboveThresh” or “belowThresh”.
