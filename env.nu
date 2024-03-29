# Nushell Environment Config File
#
# version = "0.88.1"

# os compat
let is_win = ($nu.os-info.name == "windows")
let is_mac = ($nu.os-info.name == "macos")
let username = (
    if $is_win { $env.USERNAME } else { $env.USER }
)
let hostname = (
    if $is_win { hostname | str trim } else { hostname -s | str trim }
)
let path_cell = (
    (if $is_win { [Path] } else { [PATH] }) | into cell-path
)
def get_path [] { $env | get $path_cell | split row (char esep) }

# let good_emo = [ '😎', '🥰', '🤤', '😘' ]
# let bad_emo = [ '😭 ', '😅 ', '🤣👉 ', '💀 ', '🤡 ', '🥵 ' ]

def with_home_char [] {
    if ($in | path split | zip ($nu.home-path | path split) | all { $in.0 == $in.1 }) {
        ($in | str replace $nu.home-path "~")
    } else {
        $in
    }
}

def with_tail_dir [c: int = 3] {
    $in | path split | last $c | path join
}

def create_left_prompt [] {
    let home =  $nu.home-path

    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    let dir = $env.PWD | with_home_char | with_tail_dir

    let sep_color = ansi black_bold
    let path_color = ansi green_bold
    let path_sep_color = ansi cyan_bold

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

    let git_color = ansi blue_bold
    let git = (
        if (( do { git branch --show-current } | complete ).exit_code != 0 ) { "" }
        else {
            let d = git rev-parse --show-toplevel | with_home_char | with_tail_dir 2
            [
                $sep_color, "("
                $git_color, (git branch --show-current)
                $sep_color, ($d | path_leader)
                $git_color, $d
                $sep_color, ")"
        ] | str join }
    )

    let unm_color = ansi light_yellow_bold
    let unm = $"($unm_color)($username)($sep_color)@($unm_color)($hostname)"

    let power_char = (
        if (is-admin) {
            $"(ansi light_red_bold)#"
        } else {
            $"(ansi light_purple_bold)$"
        }
    )

    [$unm, ($dir | path_leader), $path, " ", $git, (char newline), $power_char] | str join
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    # let time_segment = ([
    #     (ansi reset)
    #     (ansi magenta)
    #     (date now | format date '%x %X %p') # try to respect user's locale
    # ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
    #     str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

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

# OS-specific env setting
if $is_mac {
    source $"($nu.default-config-dir)/envs/macos.nu"
} else if $is_win {
    source $"($nu.default-config-dir)/envs/windows.nu"
}

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
