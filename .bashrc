LANG=en_GB.utf-8

alias ll="ls -la"

function ga {
  { git ls-files -o  --exclude-standard --full-name | while read -r file; do
      read -u 3 -n 1 -p "Do you wish to add new file \"$file\"? (y/n)  " answer
      if echo "$answer" | grep -iq "^y" ;then
          git add $file
          echo $'\nAdded file\n'
      else
          echo $'\nSkipping file\n'
      fi
  done; } 3<&0

  git add -p
}
alias gs="git status"
alias gp="git push"
alias gpr="git pull --rebase"
function gc {
  git commit -m "$1"
}

export GOPATH=~/source/gopath
export PATH=$GOPATH/bin:$PATH

source ~/.xsh
