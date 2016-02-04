#!/usr/bin/env bash

apt-get update

apt-get install openjdk-7-jre-headless -y

wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.1.1/elasticsearch-2.1.1.deb
dpkg -i elasticsearch-2.1.1.deb

# ES 2.1
/usr/share/elasticsearch/bin/plugin install license
/usr/share/elasticsearch/bin/plugin install shield

cp /vagrant/certs/server/server.jks /etc/elasticsearch
chown -c elasticsearch /etc/elasticsearch/server.jks

echo "192.168.33.10 vagrant-es-server" >> /etc/hosts 
echo "192.168.33.1 vagrant-es-client" >> /etc/hosts

echo "network.host: vagrant-es-server" >> /etc/elasticsearch/elasticsearch.yml
echo "cluster.name: es-syslog-ng" >> /etc/elasticsearch/elasticsearch.yml

echo "shield.ssl.keystore.path: /etc/elasticsearch/server.jks" >> /etc/elasticsearch/elasticsearch.yml
echo "shield.ssl.keystore.password:      qqq123" >> /etc/elasticsearch/elasticsearch.yml
echo "shield.transport.ssl:              true" >> /etc/elasticsearch/elasticsearch.yml
echo "shield.ssl.hostname.verification.resolve.name: false" >> /etc/elasticsearch/elasticsearch.yml
echo "transport.profiles.client.shield.ssl.client.auth: no" >> /etc/elasticsearch/elasticsearch.yml

/usr/share/elasticsearch/bin/shield/esusers useradd es_admin -p qqq123
/usr/share/elasticsearch/bin/shield/esusers roles es_admin -a admin

service elasticsearch start
