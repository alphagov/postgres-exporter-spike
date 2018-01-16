## Postgres Exporter Spike ##

As part of research into Prometheus, we wanted try out a tool for producing
database metrics that are:
  - generic in nature, e.g. number of locks, number of connections
  - able to be customised, e.g. run specific database queries like number of tweets

We think a tool like this could form a pluggable library we can set up either
automatically for users or point them to some documentation they can follow.

We used the [postgres_exporter](https://github.com/wrouesnel/postgres_exporter)
tool for this spike, but there are a number available on
[this page](https://prometheus.io/docs/instrumenting/exporters/) that might be
useful.

### Steps we followed ###

Here are the steps we followed that should be repeatable:

```bash
# Install and run postgres:
brew install postgresql
brew services start postgresql

# Create a 'twitter' database with some 'tweets':
psql postgres < setup.sql

# Download and install postgres_exporter:
wget https://github.com/wrouesnel/postgres_exporter/releases/download/v0.4.1/postgres_exporter_v0.4.1_darwin-386.tar.gz
tar xvfz postgres_exporter_v0.4.1_darwin-386.tar.gz
mv postgres_exporter_v0.4.1_darwin-386/postgres_exporter postgres_exporter

# Run postgres_exporter:
export DATA_SOURCE_NAME="user=$(whoami) database=twitter sslmode=disable"
./postgres_exporter --extend.query-path=queries.yml

# Open the metrics endpoint in your browser:
open http://localhost:9187/metrics
```

You should then be able to search for `number_of_tweets` in your browser.

### Example metrics ###

Here's a snippet from that page:

```
# HELP pg_locks_count Number of locks
# TYPE pg_locks_count gauge
pg_locks_count{datname="twitter",mode="accessexclusivelock"} 0
pg_locks_count{datname="twitter",mode="accesssharelock"} 1
pg_locks_count{datname="twitter",mode="exclusivelock"} 0
pg_locks_count{datname="twitter",mode="rowexclusivelock"} 0
pg_locks_count{datname="twitter",mode="rowsharelock"} 0
pg_locks_count{datname="twitter",mode="sharelock"} 0
pg_locks_count{datname="twitter",mode="sharerowexclusivelock"} 0
pg_locks_count{datname="twitter",mode="shareupdateexclusivelock"} 0

# HELP my_awesome_metrics_number_of_tweets The number of tweets in the database.
# TYPE my_awesome_metrics_number_of_tweets gauge
my_awesome_metrics_number_of_tweets{my_custom_dimension="123"} 2
```

As you can see, the tool provides generic metrics and lets you write custom SQL
queries for metrics as demonstrated in the [queries.yml](queries.yml) file.
