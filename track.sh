#!/usr/bin/env bash

USER="$1"
PROJECT="$2"

if [[ -z "$USER" || -z "$PROJECT" ]]
then
  echo Invalid parameters.
  echo Usage: ./track.sh user_name project_name
  exit 1
fi

DATE=$( date "+%Y-%m-%d-%H-%M" )
FILE_NAME="data/${DATE}-${USER}-${PROJECT}.json"

# Download stargazers data
# FIXME handle pagination https://developer.github.com/v3/#pagination
curl --silent "https://api.github.com/repos/$USER/$PROJECT/stargazers?per_page=100" > "$FILE_NAME"
# The easiest is to create a couple of requests just in case
# curl "https://api.github.com/repos/$USER/$PROJECT/stargazers?per_page=100&page=2" >> "$FILE_NAME"

if [[ $? -ne 0 ]]
then
  echo "Error retrieving stargazers data" >&2
  exit 1
fi

# Print summary
function summary()
{
  local COUNT=$( cat "$FILE_NAME" | sed -n '/login/p' | wc -l | xargs printf )
  local PREVIOUS=data/$( ls -1r data/ | head -n2 | tail -n1 )

  echo "SUMMARY:"
  echo
  echo "Stargazers count: $COUNT"
  echo "File: $FILE_NAME"

  if [[ -f "$PREVIOUS" && `md5 -q "$PREVIOUS"` != `md5 -q "$FILE_NAME"` ]]
  then
    echo ">> There are changes! <<"
  fi

  echo "---------------------"
}

summary

# Reschedule to twelve hours
echo "$0" "$USER" "$PROJECT" | at now + 12 hours
