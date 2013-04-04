from flask import Flask
from flask import render_template, jsonify

from libs.hackernews import HackerNews

app = Flask(__name__)
app.config.from_pyfile('settings.py')

@app.route("/")
def home():
    return render_template('index.html')

@app.route("/api/page")
def api_page():
    hn = HackerNews()
    articles = hn.get_top_article()

    return jsonify(articles=[article.__dict__ for article in articles])

@app.route("/api/<int:story_id>")
def api_article(story_id):
    hn = HackerNews()
    article = hn.get_article(story_id)

    return jsonify(article=article.__dict__)

if __name__ == "__main__":
    app.debug = True
    app.run()
