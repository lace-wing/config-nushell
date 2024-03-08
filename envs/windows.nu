$env.Path = ($env.Path | split row (char esep)
    | prepend "test1"
    | append "test2"
)
