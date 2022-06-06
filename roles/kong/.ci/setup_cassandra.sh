#!/bin/bash

CASSANDRA_BASE=apache-cassandra-$CASSANDRA_VERSION

sudo rm -rf /var/lib/cassandra/*
curl http://apache.arvixe.com/cassandra/$CASSANDRA_VERSION/$CASSANDRA_BASE-bin.tar.gz | tar xz
sudo sh $CASSANDRA_BASE/bin/cassandra