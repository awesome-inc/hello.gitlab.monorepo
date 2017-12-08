#!/bin/bash
folder=${1}
ref=${2:-HEAD~}

echo "Checking for changes of folder '${folder}' from ref '${ref}'..."

changes=`git diff ${ref} --name-only | grep -q ${folder}`
if [[ ${changes} -eq 0 ]]; then
  echo "Folder '${folder}' has changed."
else
  echo "Folder '${folder}' has not changed."
fi
exit ${changes}
