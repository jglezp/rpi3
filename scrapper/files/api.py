from flask import Flask, request, json, g
import scrap

app = Flask(__name__, template_folder="/opt/template")

@app.route('/<web>/<asin>')
def index(web, asin):
    if web == "amazon":
        return scrap.amazon(asin)
    if web == "game":
        return scrap.game(asin)
    if web == "fnac":
        return scrap.fnac(asin)
    if web == "mediamarkt":
        return scrap.mediamarkt(asin)
'''
@app.before_request
def before():
    pass

@app.after_request
def after(response):
    fn = g.get('fn', None)
    if fn:
        with open(fn, 'a') as f:
            print("Printing response", file=f)
            print(response.status, file=f)
            print(response.headers, file=f)
            print(response.get_data(), file=f)
    return response
'''
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
