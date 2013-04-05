(->
    window.WebFontConfig =
        google: {families: [
            "Ubuntu:400,700:latin",
            'Droid+Serif:400,700,400italic,700italic:latin'
        ]}

    wf = document.createElement('script')
    prefix = if "https:" == document.location.protocol then "https" else "http"
    wf.src = "#{prefix}://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js"
    wf.type = "text/javascript"
    wf.async = 'true'
    s = document.getElementsByTagName("script")[0]
    s.parentNode.insertBefore(wf, s)
)(window)