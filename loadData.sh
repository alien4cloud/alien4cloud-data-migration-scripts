#!/bin/bash -e
# ./loadData.sh >> loadData.log & tail -f loadData.log
script_dir="$(dirname $0)"
echo "Moving to $script_dir"
cd $script_dir
source ./env.sh

for file_name in $data_folder/*.json
do
  index_name="$(basename -s .json $file_name)"
  url="$es_dest_url/$index_name/_doc"
  echo "Loading $file_name into $url"
  cmd="$(getCommand) --input ${file_name} --output ${url}"
  echo "$cmd"
  eval "$cmd"
done

echo "End of load !"
