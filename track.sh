#!/usr/bin/env bash

USER="$1"
PROJECT="$2"

if [ -z "$USER" -o -z "$PROJECT" ]
then
  echo Invalid parameters.
  echo Usage: ./track.sh user_name project_name
  exit 1
fi

DATE=$( date "+%Y-%m-%d-%H-%M" )
FILE_NAME="${DATE}_${USER}_${PROJECT}"

# Download stargazers data
curl "https://api.github.com/repos/$USER/$PROJECT/stargazers" > "data/$FILE_NAME"

if [ $? -ne 0 ]
then
  echo "Error retrieving stargazers data" >&2
  exit 1
fi

# Reschedule to twelve hours
echo "$0" "$USER" "$PROJECT" | at now + 12 hours
