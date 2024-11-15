#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 directory_name"
  exit 1
fi

DIRECTORY=$1

if [ ! -d "$DIRECTORY" ]; then
  mkdir "$DIRECTORY"
  echo "Directory '$DIRECTORY' created."

  touch "$DIRECTORY/README.md"
  touch "$DIRECTORY/notes.txt"

  echo "Files 'README' and 'notes.txt' created in '$DIRECTORY'."

  git add $DIRECTORY
  git cim "initial commit for new project"
else
  echo "Directory '$DIRECTORY' already exists."
fi



