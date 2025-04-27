#!/usr/bin/bash 

showUsage() {
  echo "Usage: mygrep.sh [OPTIONS] SEARCH_STRING FILE"
  echo "  -n    Show line numbers"
  echo "  -v    Invert match"
  echo "  -i    Case insensitive search"
}

parseOptions() {
  OPTIND=1
  showLineNumber=false
  invertMatch=false

  while getopts ":nvi" opt
  do
    case $opt in
      n) showLineNumber=true ;;
      v) invertMatch=true ;;
      \?) 
        echo "Invalid option: -$OPTARG" >&2
        showUsage
        exit 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  userInput="$1"
  filePath="$2"
}

validateInput() {
  if [[ -z "$userInput" || -z "$filePath" ]]; then
    echo "Error: Missing pattern or file." >&2
    showUsage
    exit 1
  fi

  if [[ ! -f "$filePath" ]]; then
    echo "Error: File not found: $filePath" >&2
    exit 1
  fi
}

searchFile() {
  shopt -s nocasematch

  local lineNumber=0
  while IFS= read -r line
  do
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

main() {
  if [[ "$1" == "--help" ]]
  then
    showUsage
    exit 0
  fi

  parseOptions "$@"
  validateInput
  searchFile
}

main "$@"
