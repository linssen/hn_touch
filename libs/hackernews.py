from bs4 import BeautifulSoup
import requests


class HackerNews(object):
    def get_page(self, url):
        """Requests the page."""
        r = requests.get('%s/' % self.base_url)
        return r.text

    def find_articles(self, url):
        """Rummages through the page and finds the articles."""
        page = self.get_page(url)
        soup = BeautifulSoup(page)
        articles = []
        story_rows = soup.find_all('td', class_='title')
        self.num_stories = len(story_rows)/2

        for i, row in enumerate(tuple(story_rows)):
            if i % 2:
                article = Article()
                article.title = unicode(row.a.string)
                article.url = unicode(row.a['href'])
                articles.append(article)

        return articles

    def get_top_stories(self):
        """Get's the top stories (front page)."""
        articles = self.find_articles(self.base_url)
        return articles

    def __init__(self):
        self.base_url = 'http://news.ycombinator.com'
        self.num_stories = 0


class Article(object):
    id = 0
    title = ''
    url = ''
    score = 0
