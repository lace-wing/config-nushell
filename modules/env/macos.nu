export-env {
    $env.PATH = ($env.PATH | split row (char esep)
        | prepend "/opt/homebrew/bin" # homebrew
        | prepend "/opt/homebrew/sbin" # also homebrew
        | prepend "/nix/var/nix/profiles/default/bin" # nix
        | prepend $"($nu.home-path)/.nix-profile/bin" # nix-env path
        | prepend $"($nu.home-path)/.dotnet/tools" # dotnet tools
        | prepend $"($nu.home-path)/.ghcup/ghc/9.10.1/bin" # ghcup tools
        | prepend $"($nu.home-path)/.local/share/nvim/mason/bin" # mason bin
        | prepend $"($nu.home-path)/.cargo/bin" # cargo bin
        # | prepend "/opt/homebrew/opt/python@3.12/libexec/bin" # homebrew python symlinks
        | prepend "/opt/homebrew/opt/python@3.13/libexec/bin" # homebrew python symlinks
        # | append $"($nu.home-path)/Library/Python/3.11/bin" # python user site packages
        | append "/usr/local/texlive/2024/bin/universal-darwin" # MacTex bin
        | append $"($nu.home-path)/.local/bin" # user bin
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

    # ghostty envs
    $env.GHOSTTY_RESOURCES_DIR = $"($nu.home-path)/src/ghostty/zig-out/share/ghostty"
}
