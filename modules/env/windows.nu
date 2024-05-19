export-env {
    $env.Path = ($env.Path | split row (char esep)
        | append $"C:\\Program Files\\LLVM\\bin"
    )
    $env.YAZI_FILE_ONE = "C:\\Program Files\\Git\\usr\\bin\\file.exe"
}
