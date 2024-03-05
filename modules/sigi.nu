use lens.nu *

export def did [
    ...stacks: string # other stacks to run sigi on
] {
    let s = (match (($stacks | length) > 0) {
        true => ($stacks | each {|e| $"($e)_history"}),
        false => (sigi stacks | str trim | split row (char newline) | where {|e| | str ends-with "_history"})
    })
    print $s
    let l = ($s | each { |e| sigi -t $e list | str trim | split row (char newline) | wrap $e })

    mut t = $l.0
    for i in (range $l) {
        if $i == 0 { continue }
        $t = ($t | merge ($l | get $i))
    }
    $t
}

export def done [
    stack: string = "sigi" # stack to run sigi on
    ...stacks: string # other stacks to run sigi on
] {
    sigi -t $stack complete
    for s in $stacks {
        sigi -t $s complete
    }
}

export def wdo [
    stack: string = "sigi" # stack to run sigi on
    ...stacks: string # other stacks to run sigi on
] {
    sigi -t $stack push
    for s in $stacks {
        sigi -t $s complete
    }
}
