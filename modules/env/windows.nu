export-env {
    $env.Path = ($env.Path | split row (char esep)
        | append $"C:\\Program Files\\LLVM\\bin"
    )
}
