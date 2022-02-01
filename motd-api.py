# apt install python3-pip
# pip install flask
import sys
from flask import Flask
from flask import jsonify
from flask import Response
app = Flask(__name__)

dico = {"message": "Hello, world"}

@app.route("/")
def hello_world():
    if len(sys.argv) >= 3: # si un message est spécifié alors on l'utilise
        dico["message"]=str(sys.argv[2])
        return jsonify(dico)
    else: # message par défaut
        return jsonify(dico)
    #endif

if __name__=="__main__":
    if len(sys.argv) >= 2: # si un port est spécifié alors
        app.run(host='0.0.0.0',port=int(sys.argv[1]), debug=True)
    else: # port par défaut
        app.run(host='0.0.0.0',port=5000, debug=True)
    #endif