export def range [
    list: list
    start: int = 0
] {
    $start..(($list | length) - 1)
}

