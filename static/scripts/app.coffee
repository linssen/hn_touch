window.app = window.app || {}

$(->
    API_BASE = "http://api.ihackernews.com"

    app.Article = Backbone.Model.extend(
        defaults:
            title: "",

        url: ->
            return "#{API_BASE}/post/#{this.id}"
    )

    app.ArticleList = Backbone.Collection.extend(
        model: app.Article

        url: "#{API_BASE}/page"

        sync: (method, model, options) ->
            options = _.extend({dataType: 'jsonp'}, options)
            Backbone.sync.call(this, method, model, options)

        parse: (response) ->
            return response.items
    )
    app.Articles = new app.ArticleList();

    app.ArticleView = Backbone.View.extend(
        tagName: "li"

        template: app.templates.article

        initialize: ->
            console.log @template
    )

    app.AppView = Backbone.View.extend(
        el: "#hn-app"

        initialize: ->

            @listenTo(app.Articles, "add", @addOne)
            @listenTo(app.Articles, "reset", @addAll)

            app.Articles.fetch()

        addOne: (article) =>
            console.log article
            view = new app.ArticleView({model: article})

        addAll: =>
            this.$("#article_list").html("")
            app.Articles.each(@addOne, this)
    )

    new app.AppView();
)