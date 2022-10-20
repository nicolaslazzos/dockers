#!/bin/bash

/usr/bin/mongod &

until mongosh --eval "print(\"waited for connection\")"
do
    sleep 2
done

echo "creating user"
mongosh <<EOF
use admin
db.createUser({ user: "admin", pwd: "admin", roles: [{ role: "readWriteAnyDatabase", db: "admin" }] });
EOF
echo "user created"

mongosh admin --eval "db.shutdownServer()"

/usr/bin/mongod --bind_ip_all --replSet rs0

