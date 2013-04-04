window.app = window.app || {}

$(->
    API_BASE = "/api"

    app.Article = Backbone.Model.extend()

    app.ArticleList = Backbone.Collection.extend(
        model: app.Article

        url: "#{API_BASE}/page"

        parse: (response) ->
            return response.objects
    )
    app.Articles = new app.ArticleList();

    app.ArticleView = Backbone.View.extend(
        tagName: "li"

        template: app.templates.article

        initialize: ->
            @listenTo @model, "change", @render
            @listenTo @model, "destroy", @remove

        render: ->
            @$el.attr("id", @model.get "id")
            @$el.html(@template(@model.toJSON()))
            return this
    )

    app.AppView = Backbone.View.extend(
        el: "#hn-app"

        initialize: ->

            @listenTo(app.Articles, "add", @addOne)
            @listenTo(app.Articles, "reset", @addAll)

            app.Articles.fetch()

        addOne: (article) ->
            view = new app.ArticleView({model: article})
            $("#article_list").append(view.render().el)

        addAll: ->
            this.$("#article_list").html("")
            app.Articles.each(@addOne, this)
    )

    new app.AppView();
)