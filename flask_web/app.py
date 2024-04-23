from flask import Flask, render_template, request

app = Flask(__name__)

@app.get('/')
def index():
    print(request.headers)
    return render_template('index.html')

if __name__ == "__main__":
    app.run(debug=True)