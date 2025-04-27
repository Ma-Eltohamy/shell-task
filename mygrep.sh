#!/usr/bin/bash 

if [[ "$1" == "--help" ]]; then
  echo "Usage: mygrep.sh [OPTIONS] SEARCH_STRING FILE"
  echo "  -n    Show line numbers"
  echo "  -v    Invert match"
  echo "  -i    Case insensitive search"
  exit 0
fi

searchWrod() {
  OPTIND=1
  shopt -s nocasematch

  local showLineNumber=false
  local invertMatch=false

  while getopts ":nv" opt; do
    case $opt in
      n) showLineNumber=true ;;
      v) invertMatch=true ;;
      \?) echo "Usage: searchWrod [-n] [-v] <pattern> <file>" >&2; 
          shopt -u nocasematch; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ -z "$userInput" || -z "$filePath" ]]; then
    echo "Usage: searchWrod [-n] [-v] <pattern> <file>" >&2
    shopt -u nocasematch; return 1
  fi

  if [[ ! -f "$filePath" ]]; then
    echo "File not found: $filePath" >&2
    shopt -u nocasematch; return 1
  fi

  local userInput="$1"
  local filePath="$2"

  if [[ ! -f "$filePath" ]]
  then
    echo "File not found: $filePath"
    shopt -u nocasematch
    return 1
  fi

  local lineNumber=0
  while IFS= read -r line
  do    
    # I should add the line number each time weather -n or -v or both
    # line number at the file not the number of the printed line
  ((lineNumber++))
  if [[ "$line" == *"$userInput"* ]]
  then
    matched=true
  else
    matched=false
  fi

  if [[ "$matched" != "$invertMatch" ]]
  then
    if [[ "$showLineNumber" == true ]]
    then
      echo -n "${lineNumber}: "
    fi
    echo "$line"
  fi

  done < "$filePath"
  shopt -u nocasematch
}

searchWrod "$@"
