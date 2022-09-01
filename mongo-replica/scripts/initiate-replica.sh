#!/bin/bash

until mongo --host mongo1 --eval "print(\"waited for connection\")"
do
    sleep 2
done

echo "creating replica set"
mongo --host mongo1 <<EOF
var config = {
  _id : 'rs0',
  version: 1,
  members: [
    { _id : 0, host : "mongo1:27017", priority: 1 },
    { _id : 1, host : "mongo2:27017", priority: 0 },
    { _id : 2, host : "mongo3:27017", priority: 0 },
  ],
}
rs.initiate(config, { force: true });
EOF
echo "replica set created"