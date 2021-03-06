Red [
    Title: "blank-template.red"
    Iterations: [
        0.0.0.1.5 {Deleted call}
        0.0.0.1.4 {Fix ask domain error}
        0.0.0.1.3 {Confirm domain-name - bugged when asking domain: 
*** Script Error: ask does not allow block! for its question argument        
        }
        0.0.0.1.2 {unset 'short-filename}
        0.0.0.1.1 {Initial version}
    ]
]

do https://codegen.red/blank-template.red
do https://redlang.red/templating

html-embed: function [][    
    store-template: copy []
    if empty? store-template [
        append store-template get-blank-template/source https://codegen.red/redlang/res/html-embed.template.html
    ]
    
    template: store-template/1

    if value? 'short-filename [
        unset 'short-filename
    ]

    unless not value? 'domain-name [
        ans: ask rejoin ["Confirm domain-name" domain-name "(by default or give new domain):"]
        if ans <> "" [
            system/words/domain-name: ans
        ]
    ]
    return render template %html-embed.html
]







