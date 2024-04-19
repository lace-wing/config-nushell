export-env {
    $env.PATH = ($env.PATH | split row (char esep)
        | prepend "/opt/homebrew/bin" # add homebrew
        | prepend "/opt/homebrew/sbin" # homebrew
        | prepend "/nix/var/nix/profiles/default/bin" # add nix
        | prepend $"($nu.home-path)/.nix-profile/bin" # add nix-env path
        | prepend $"($nu.home-path)/.dotnet/tools" # add dotnet tools
        | prepend "/opt/homebrew/opt/python@3.12/libexec/bin" # add homebrew python symlinks
    )

    # XDG CONFIG
    $env.XDG_CONFIG_HOME = $"($nu.home-path)/.config"

    # homebrew dotnet
    $env.DOTNET_ROOT = '/opt/homebrew/bin/dotnet'

    # omnisharp config home
    $env.OMNISHARPHOME = $"($nu.home-path)/.config/"

    # find dylib at runtime in /usr/local/lib
    $env.DYLD_LIBRARY_PATH = "/usr/local/lib"
}
