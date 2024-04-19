# if OS name is "windows"
export def is-win [] { $nu.os-info.name == "windows" }
# if OS name is "macos"
export def is-mac [] { $nu.os-info.name == "macos" }
# get OS' current username
export def username [] {
    if (is-win) { $env.USERNAME } else { $env.USER }
}
# get OS' short hostname
export def hostname-short [] {
    if (is-win) { hostname | str trim } else { ^hostname -s | str trim }
}
# get OS' 'path' name
export def path-cell-name [] {
    (if (is-win) { [Path] } else { [PATH] }) | into cell-path
}
# get OS' 'path'
export def get-path [] {
    $env | get (path-cell-name) | split row (char esep)
}

