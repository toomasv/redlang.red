Red [
    Title: "assemble.red"
    Description: {Assemble a red file from parts}
    Version: [
        0.0.1 {Initial version}
    ]
    Build: [
        0.0.0.1.17 {Cleaning}
        0.0.0.1.16 {Fix get-folder bug}
    ]

]

do https://redlang.red
.redlang [files get-folder alias]

.include: function [
    directory
][
    src: copy ""
    
    files: read directory

    forall files [
        file: rejoin [directory files/1]

            short-filename: rejoin [get-short-filename/wo-extension file]
            extension: get-file-extension file

            folder: get-folder (file)
            sub-folder: rejoin [folder short-filename %/] ; fixed bug: missing %/

        unless (dir? file) or (
            (extension <> %.red) and (extension <> %.html) and (extension <> %.htm)
            ) [
            unless (index? files) = 1 [
                src: rejoin [src newline]
            ]
            src: rejoin [src read file]

            doc-file: clean-path rejoin [folder short-filename %.log]
            ; txt-file: clean-path rejoin [folder short-filename %.txt]

            ; if exists? txt-file [
            ;     write doc-file read txt-file
            ;     delete txt-file
            ; ]
            
            unless exists? doc-file [
                write doc-file ""
            ]            

            if exists? sub-folder [
                src-include: include sub-folder
                replace src {<%parts%>} src-include
            ]
        ]
    ]
    return src
]

.alias .include [include assemble .assemble ]

