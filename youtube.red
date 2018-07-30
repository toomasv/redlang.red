Red [
    Title: "youtube.red"
    Builds: [
        0.0.0.1.10 {Multiple urls support}
    ]
]

unless not error? try [
    do load-thru/update https://redlang.red/url.red
][
    do %libs/url.red
]

.parse-youtube-url: function [>youtube-url [url!]][

    .url: >youtube-url
    .html: read >youtube-url

    write-clipboard .html

    parse .html [
        thru {<meta name="twitter:title" content="} copy .title to {">}
        thru {<meta name="twitter:description" content="} copy .description to {">}
    ]


    .id: parse-url .url 'v

    return compose [
        id: (.id)
        title: (.title)
        description: (.description)
    ]    

]

youtube: function [>id_or_url [word! string! url! block!] /to-clipboard][

    either block? >id_or_url [
        result: copy []
        >id_or_urls: >id_or_url
        forall >id_or_urls [
            >id_or_url: >id_or_urls/1
            youtube-parsed: youtube >id_or_url
            append/only result youtube-parsed
        ]

        if to-clipboard [
            write-clipboard mold result
            print mold result
            print "copied to clipboard"
        ]

        return result
    ][
        if >id_or_url = 'clipboard [
            >id_or_url: read-clipboard
            if find >id_or_url "http" [
                >id_or_url: to-url >id_or_url
            ]
            to-clipboard: true
        ]

        either url? >id_or_url [
            url: >id_or_url
        ][
            id: >id_or_url
            url: rejoin [https://www.youtube.com/watch?v= id]
        ]
        

        it: .parse-youtube-url url

        if to-clipboard [
            write-clipboard mold it
            print mold it
            print "copied to clipboard"
        ]
        return it
    ]

]

; test: youtube 'GHvnIm9UEoQ
; test: youtube/to-clipboard https://www.youtube.com/watch?y=10&v=GHvnIm9UEoQ
;test: youtube https://www.youtube.com/watch?v=mKFGj8sK5R8&t=2s
;?? test

; test: youtube https://www.youtube.com/watch?v=mKFGj8sK5R8&t=2s
; ?? test

;test: youtube 'clipboard

; youtube.7.red
; test: youtube/to-clipboard https://www.youtube.com/watch?v=B5kkOxHGz8M
; test2: youtube/to-clipboard https://www.youtube.com/watch?v=Gg84CO4L2Yw
; test: youtube [
;     https://www.youtube.com/watch?v=B5kkOxHGz8M
;     https://www.youtube.com/watch?v=Gg84CO4L2Yw
; ]

; ?? test


