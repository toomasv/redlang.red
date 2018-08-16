Red [
    Title: "do.red"
    Builds: [
        0.0.0.1 {Initial Build}
    ]
]

if not value? '.do [

    .do: function [

        {Evaluates a value, returning the last evaluation result} 
        'value [any-type!] 
        /expand "Expand directives before evaluation" 
        /args {If value is a script, this will set its system/script/args} 
        arg "Args passed to a script (normally a string)" 
        /next {Do next expression only, return it, update block word} 
        position [word!] "Word updated with new block position"
        /redlang {Examples: 
            .do/redlang cd
            .do/redlang [cd copy-files]
            .do/redlang/silent [cd copy-files]
        }
        /silent {Don't print command}
        /_debug {debug mode for developer only}

    ][
        value: :value

        if redlang [

            either block? value [

                new-value: copy value

                forall new-value [

                    command: copy []
                    main-command: copy ".do/redlang"
                    if expand [
                        main-command: rejoin [main-command "/expand"]
                    ]
                    if args [
                        main-command: rejoin [main-command "/args"]
                    ]
                    if next[
                        main-command: rejoin [main-command "/next"]
                    ]
                    if silent[
                        main-command: rejoin [main-command "/silent"]
                    ]
                    if _debug[
                        main-command: rejoin [main-command "/_debug"]
                    ]                                         
                    command: copy reduce [load main-command] ; don't forget reduce otherwise bug !!

                    append command compose [(new-value/1)]

                    if args [
                        append command to-word 'arg
                    ]
                    if next [
                        append command to-word 'position
                    ]   

                    if _debug [
                        msg-debug: {.do line 63: }
                        print rejoin [msg-debug command]
                    ]
                    do command
                ]
                exit ; if missing => bug
                
            ][
                url-string: form value

                if not find url-string "redlang" [
                    either find url-string "https" [
                        parse url-string [
                            thru "https://" start: (insert start "redlang.red/")
                        ]
                        value: to-url url-string
                    ][
                        value: to-url rejoin [https://redlang.red/ url-string]
                    ]
                ]
            ]
        ]

        command: copy []

        main-command: copy "do"
        
        if expand [
            main-command: rejoin [main-command "/expand"]
        ]
        if args [
            main-command: rejoin [main-command "/args"]
        ]
        if next[
            main-command: rejoin [main-command "/next"]
        ]
        command: copy reduce [load main-command] ; don't forget reduce otherwise bug !!

        append command compose [(value)]

        if args [
            append command to-word 'arg
        ]
        if next [
            append command to-word 'position
        ]   

        unless silent [
            msg-debug: ""
            if _debug [msg-debug: {.do line 112: }]
            print rejoin [msg-debug command]
        ]

        do command        

        ;reduce command ; TODO: compare performance
    ]  
]     

