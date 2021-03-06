Red [
    Title: "build-markup.red"
    Build: 1.0.0.5
    Version: 1.0.3
    History: [
        1.0.0 {Initial version}
        1.0.1 {.get-vars: return unique vars}
        1.0.2 {.render-template}
        1.0.3 {render: :.render-template}
    ]
    Alias: [
        %build-markup
    ]
    Published-url: [
        http://redlang.red/build-markup
    ]
    Included-in: [
        http://redlang.red/authoring.red
    ]
]

.build-markup: func [
    {Return markup text replacing <%tags%> with their evaluated results.}
    content [string! file! url!]
    /bind obj [object!] "Object to bind"    ;ability to run in a local context
    /quiet "Do not show errors in the output."
    /delimiters >delimiters [block!]
    /local out eval value
][
    either delimiters [
        -delimiters: >delimiters
    ][
        -delimiters: ["<%" "%>"]
    ]

    content: either string? content [copy content] [read content]
    out: make string! 126
    eval: func [val /local tmp] [
        either error? set/any 'tmp try [either bind [do system/words/bind load val obj] [do val]] [
            if not quiet [
                tmp: disarm :tmp
                append out reform ["***ERROR" tmp/id "in:" val]
            ]
        ] [
            if not unset? get/any 'tmp [append out :tmp]
        ]
    ]

    rule: copy []
    any-block: [
            end break
            | "<%" [copy value to "%>" 2 skip | copy value to end] (eval value)
            | copy value [to "<%" | to end] (append out value)
        ]
    append/only rule [any any-block]

    ; rule: [
    ;     any [
    ;         end break
    ;         | "<%" [copy value to "%>" 2 skip | copy value to end] (eval value)
    ;         | copy value [to "<%" | to end] (append out value)
    ;     ]
    ; ]

    parse content rule
    out
]

build-markup: :.build-markup

; .string.expand: function[.string-template [string!] .block-vars[block!]][

;     return build-markup/bind .string-template Context Compose .block-vars
; ]

; expand-string: :.string.expand
; string.expand: :.string.expand
; string-expand: :.string.expand
; .expand: :.string.expand