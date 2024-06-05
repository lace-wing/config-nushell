export-env {
    $env.PATH = ($env.PATH | split row (char esep)
        | prepend "/opt/homebrew/bin" # homebrew
        | prepend "/opt/homebrew/sbin" # also homebrew
        | prepend "/nix/var/nix/profiles/default/bin" # nix
        | prepend $"($nu.home-path)/.nix-profile/bin" # nix-env path
        | prepend $"($nu.home-path)/.dotnet/tools" # dotnet tools
        | prepend "/opt/homebrew/opt/python@3.12/libexec/bin" # homebrew python symlinks
    )

    # XDG
    $env.XDG_CONFIG_HOME = $"($nu.home-path)/.config"
    $env.XDG_DATA_HOME = $"($nu.home-path)/.local/share"
    $env.XDG_STATE_HOME = $"($nu.home-path)/.local/state"

    # homebrew dotnet
    $env.DOTNET_ROOT = '/opt/homebrew/bin/dotnet'

    # omnisharp config home
    $env.OMNISHARPHOME = $"($nu.home-path)/.config/"

    # find dylib at runtime in /usr/local/lib
    $env.DYLD_LIBRARY_PATH = "/usr/local/lib"
}
