window.app = window.app || {}

$(->
    API_BASE = "/api"
    READABILITY = "https://readability.com/api/content/v1/parser"

    app.Article = Backbone.Model.extend(
        readingTime: (word_count) =>
            wordsPerMinute = 250
            return (word_count / wordsPerMinute).toFixed(2)

        mobalise: ->
            _self = this
            $.ajax(
                type: "GET"
                url: "#{READABILITY}"
                data:
                    url: @get "url"
                    token: window.READABILITY_API_KEY
                dataType: "jsonp"
                success: (data) ->
                    detailView = new app.ArticleDetailView({model: _self})
                    $("body").removeClass("loading")
                    $("#header").after(detailView.render().el)

                    _self.set(
                        "mobalised": data.content
                        "excerpt": data.excerpt
                        "word_count": data.word_count
                        "reading_time": _self.readingTime(data.word_count)
                    )
            )
    )

    app.ArticleList = Backbone.Collection.extend(
        model: app.Article

        url: "#{API_BASE}/page"

        parse: (response) ->
            return response.objects

    )
    app.Articles = new app.ArticleList();

    app.ArticleListView = Backbone.View.extend(
        tagName: "li"

        template: app.templates.article_list

        events: ->
            "click a": "openDetail"

        initialize: ->
            @listenTo @model, "change:id", @render
            @listenTo @model, "destroy", @remove

        render: ->
            @$el.attr("id", @model.get "id")
            @$el.html(@template(@model.toJSON()))
            return this

        openDetail: (event) ->
            event.preventDefault()
            $("body").addClass("loading")
            @model.mobalise()
    )

    app.ArticleDetailView = Backbone.View.extend(
        tagName: "div"
        returnTo: 0

        events:
            "click .close>a": "close"

        attributes:
            class: "articleDetail"

        template: app.templates.article_detail

        close: (event) ->
            event.preventDefault()
            $(window).scrollTop(@returnTo)
            $("body").removeClass "detail"
            @remove()

        initialize: ->
            @listenTo @model, "change", @render
            @listenTo @model, "destroy", @remove
            @returnTo = $(window).scrollTop()

        render: ->
            $(window).scrollTop(0)
            $("body").addClass "detail"
            @$el.html(@template(@model.toJSON()))
            return this
    )

    app.AppView = Backbone.View.extend(
        el: "#hn-app"

        initialize: ->

            $("body").addClass("loading")

            @listenTo(app.Articles, "add", @addOne)
            @listenTo(app.Articles, "reset", @addAll)

            app.Articles.fetch(
                success: -> $("body").removeClass("loading")
            )

        addOne: (article) ->
            view = new app.ArticleListView({model: article})
            $("#article_list").append(view.render().el)

        addAll: ->
            this.$("#article_list").html("")
            app.Articles.each(@addOne, this)
    )

    new app.AppView();
)