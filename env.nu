# Nushell Environment Config File
#
# version = "0.88.1"

# os compat
use $"($nu.default-config-dir)/modules/os.nu" *
# OS-specific env setting
use $"($nu.default-config-dir)/modules/env/($nu.os-info.name).nu"

# gstat
plugin add ((which nu_plugin_gstat).path.0)

# let good_emo = [ '😎', '🥰', '🤤', '😘' ]
# let bad_emo = [ '😭 ', '😅 ', '🤣👉 ', '💀 ', '🤡 ', '🥵 ' ]

# convert raw path to one with '~' for $nu.home-path
def with-home-char [] {
    if ($in | path split | zip ($nu.home-path | path split) | all { $in.0 == $in.1 }) {
        ($in | str replace $nu.home-path "~")
    } else {
        $in
    }
}

# trim the path to the last $count segments
def with-tail-dir [count: int = 3] {
    $in | path split | last $count | path join
}

def create_left_prompt [] {
    let home =  $nu.home-path
    let dir = $env.PWD | with-home-char | with-tail-dir

    let sep_color = ansi black_bold
    let path_color = ansi green_bold
    let path_sep_color = $sep_color
    let unm_color = $path_color
    let git_color = ansi blue_bold

    def path_leader [] = {
        if (($in | str starts-with "~") or ($in | str starts-with "/")) {
            $"($sep_color):"
        } else {
            $"($sep_color)::"
        }
    }

    let path = (
        $"($path_color)($dir)" | str replace --all (char path_sep) $"($path_sep_color)(char path_sep)($path_color)"
    )

    let stats = gstat
    let git = (
        if ($stats.repo_name == "no_repository") { "" }
        else {
            let sts = $stats.stashes != 0
            let wt = (
                $stats.wt_untracked != 0
                or $stats.wt_modified != 0
                or $stats.wt_deleted != 0
                or $stats.wt_type_changed != 0
                or $stats.wt_renamed != 0
            )
            let idx = (
                $stats.idx_added_staged != 0
                or $stats.idx_modified_staged != 0
                or $stats.idx_deleted_staged != 0
                or $stats.idx_renamed != 0
                or $stats.idx_type_changed != 0
            )
            let unsy = (
                $stats.ahead != 0
                or $stats.behind != 0
            )
            let cnft = $stats.conflicts != 0
            [
                $"($sep_color)  ($git_color)", $stats.branch
                (if $sts { $"(ansi light_yellow) " })
                (if $wt or $idx { $"(ansi light_red) " })
                (if $unsy { $"(ansi light_red) " })
                (if $cnft { $"(ansi light_red) " })
            ] | str join
        }
    )

    let unm = $"($unm_color)(username)($sep_color)@($unm_color)(hostname-short)"

    let power_char = (
        if (is-admin) {
            $"(ansi light_red_bold)#"
        } else {
            $"(ansi light_purple_bold)$"
        }
    )

    [$unm, ($dir | path_leader), $path, $git, (char newline), $power_char] | str join
}

def create_right_prompt [] {
    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        # ($bad_emo | get (random int 0..5))
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    }
        # else { ($good_emo | get (random int 0..3)) }

    ([$last_exit_code, (char space)] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "| " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
$env.TRANSIENT_PROMPT_INDICATOR = {|| "< " }
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "< " }
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "< " }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# lang settings
# nvim will not function properly on UTF-8 chars without these settings
$env.LC_ALL = 'en_GB.UTF-8'
$env.LANG = 'en_GB.UTF-8'

# TERM
if "TMUX" in $env { $env.TERM = "tmux-256color" } else { $env.TERM = "xterm-256color" }

# setup EDITOR
$env.EDITOR = 'nvim'

# setup mdp
$env.MDP_LIST_OPEN1 = '    '
$env.MDP_LIST_OPEN2 = '    '
$env.MDP_LIST_OPEN3 = '    '
$env.MDP_LIST_HEAD1 = ' ⦿  '
$env.MDP_LIST_HEAD2 = ' •  '
$env.MDP_LIST_HEAD3 = ' ◦  '
