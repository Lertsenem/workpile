if [[ ! -o interactive ]]; then
    return
fi

compctl -K _workpile workpile

_workpile() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(workpile commands)"
  else
    completions="$(workpile completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
