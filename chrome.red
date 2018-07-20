Red [
    Title: "chrome.red"
    Iterations: [
        0.0.0.1.4 {print command}
        0.0.0.1.3 {Window size}
        0.0.0.1.2 {Hide scrollbar}
        0.0.0.1.1 {Initial version}
    ]
    .links: [
        https://jonathanmh.com/taking-full-page-screenshots-headless-chrome/
        https://stackoverflow.com/questions/43541925/how-to-set-the-browser-window-size-when-using-google-chrome-headless
    ]
]

get-chrome-path: function [][
    return chrome-path: rejoin [{"} get-env "programfiles(x86)" "\Google\Chrome\Application\chrome.exe" {"}]
]

chrome: function [>url][
    chrome-path: get-chrome-path
    command: rejoin [chrome-path { } >url]
    call command
]

take-screenshot: function [>url >file][
    chrome-path: get-chrome-path
    command: rejoin [chrome-path { } >url { }  {--screenshot=} >file { } {--headless --hide-scrollbars --window-size=1920,1080 --disable-gpu &}]
    print command
    call command
]