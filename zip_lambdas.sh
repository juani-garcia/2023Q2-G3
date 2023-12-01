#!/bin/bash

directory="./terraform/resources/lambdas"
cd "$directory" || exit
for file in *.py; do
    base_name="${file%.py}"
    zip "${base_name}.zip" "$file"
done

echo "Zip files created successfully."
