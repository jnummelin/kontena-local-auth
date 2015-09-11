#!/bin/sh

echo "Migrating user database... "
sequel -m db/migrations sqlite://${DB_PATH:-users.db}
echo "...done!"

exec puma -b "tcp://0.0.0.0:$PORT"
