#!/bin/bash
folder=${1}
command=${@:2}

./changes.sh ${folder}
if [[ $? -ne 0 ]]; then
  echo "Skipping build for '${folder}'."
  exit 0
fi

echo
echo "Building '${folder}'..."
echo "Executing '${command}'..."
echo
pushd ${folder}
exec ${command}
exitCode=$?
popd

exit ${exitCode}
