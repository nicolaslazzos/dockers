#!/bin/bash

/usr/bin/mongod &

until mongo --eval "print(\"waited for connection\")"
do
    sleep 2
done

echo "creating user"
mongo <<EOF
use admin
db.createUser({ user: "admin", pwd: "admin", roles: [{ role: "readWriteAnyDatabase", db: "admin" }] });
EOF
echo "user created"

mongo admin --eval "db.shutdownServer()"

/usr/bin/mongod --bind_ip_all --replSet rs0

