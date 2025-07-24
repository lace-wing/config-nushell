# rc alias

# edit TMUX config
export alias trc = nvim $"($env.XDG_CONFIG_HOME)/tmux/tmux.conf"
# edit Neovim config
export alias nrc = nvim $"($env.XDG_CONFIG_HOME)/nvim/init.lua"

# cd export alias

# cd to Documents
export alias cddoc = cd `~/Documents/`
# cd to Downloads
export alias cddow = cd `~/Downloads/`
# cd to Desktop
export alias cddes = cd `~/Desktop/`
# cd to Saved Pictures
export alias cdpic = cd `~/Pictures/Saved Pictures/`
# cd to Screen Shot
export alias cdshot = cd `~/Pictures/Screen Shot/`
# cd to Movies
export alias cdmov = cd `~/Movies/`
# cd to Application Support
export alias cdaps = cd `~/Library/Application Support/`
#cd to com~apple~CloudDocs (iCloud Documents)
export alias cdic = cd `~/Library/Mobile Documents/com~apple~CloudDocs`

# cd to tModLoader/ModSources
export alias cdtm = cd `~/Library/Application Support/Terraria/tModLoader/ModSources/`

# program alias

# macOS' open
export alias open = ^open
export alias op = ^open
# open after fzf
export alias fp = ^open (fzf) 
# plover
export alias plover = /Applications/Plover.app/Contents/MacOS/Plover
