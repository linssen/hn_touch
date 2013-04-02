import re

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
        titles = soup.find_all('td', class_='title')
        subtexts = soup.find_all('td', class_='subtext')
        self.num_stories = len(titles)/2
        nore = re.compile('^(\d+)')

        for i, row in enumerate(tuple(titles)):
            if i % 2:
                article = Article()
                subtext = subtexts[((i+1)/2)-1]
                article.title = unicode(row.a.string)
                article.url = unicode(row.a['href'])
                article.score = int(nore.match(subtext.span.string).group(0))
                article.submitter = subtext.a.text
                num_comments = nore.match(subtext.a.find_next_sibling('a').text)
                if num_comments:
                    article.comment_count = int(num_comments.group(0))
                else:
                    article.comment_count = 0
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
