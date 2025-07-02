#!/bin/sh
value=$(/opt/homebrew/bin/emacsclient -n -e "(> (length (frame-list)) 1)")
echo $value
if [ "$value" = "t" ]; then
  echo "Abrido o emacs"
  open -a Emacs.app
else
  echo "está aberto, usando o emacsclient" >>/tmp/log.log
  /opt/homebrew/bin/emacsclient -cn
  open -a Emacs.app
fi
