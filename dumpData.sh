#!/bin/bash -e
script_dir="$(dirname $0)"
echo "Moving to $script_dir"
cd $script_dir
source ./env.sh

indexes="$(cat indexes.txt | grep -v '#')"
# source env.sh && curl -k --key "$client_key_path" --cert "$client_cert_path"  "$es_source_url/_cat/indices?v"

mkdir -p "$data_folder"

while read -r line; do
    words=($line)
    # the first word is the index name
    index="${words[0]}"
    # the second word is the type name
    type="${words[1]}"
    # the third stuff indicates if the index has TTL in source ES (in this case we'll drop the TTL field)
    ttl="${words[2]}"
    file_name="$data_folder/$type.json"
    echo "Dumping $index:$type into $file_name"
    cmd="$(getCommand) --input ${es_source_url} --input-index $index/$type --output ${file_name} --type=data"
    if [ "$ttl" == "1" ]; then
      cmd="$cmd --transform 'delete doc.fields'"
    fi
    echo "$cmd"
    eval "$cmd"
    file_size=$(du -k "$file_name" | cut -f1)
    if [ "$file_size" == "0" ]; then
      echo "Dump $file_name is empty, removing it !"
      rm $file_name
    else
      file_size=$(du -h "$file_name" | cut -f1)
      echo "Dump $file_name contains $file_size of data"
    fi
done <<< "$indexes"

echo "End of dump !"
