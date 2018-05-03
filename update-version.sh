#!/bin/bash
set -ex
# read the value in version.txt increament the value if jenkins plugins needs to be updated

version=$(<plugins/version.txt)
echo "Current version is ${version}"
increament_version=$(($version + 1))
echo "increament to ${increament_version}"
sed -i "s/$version/$increament_version/g" plugins/version.txt

# check if it updated
cat plugins/version.txt
