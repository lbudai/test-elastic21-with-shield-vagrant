#!/usr/bin/env bash

sudo apt-get update

sudo apt-get install expect -y
sudo apt-get install openjdk-7-jre-headless -y

wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.1.1/elasticsearch-2.1.1.deb
sudo dpkg -i elasticsearch-2.1.1.deb

# ES 2.1
sudo /usr/share/elasticsearch/bin/plugin install license
sudo /usr/share/elasticsearch/bin/plugin install shield

sudo echo "192.168.33.10 vagrant-es-server" >> /etc/hosts 
sudo echo "192.168.33.1 vagrant-es-client" >> /etc/hosts

sudo echo "network.host: vagrant-es-server" >> /etc/elasticsearch/elasticsearch.yml
sudo echo "cluster.name: es-syslog-ng" >> /etc/elasticsearch/elasticsearch.yml

sudo echo "shield.ssl.keystore.path: /vagrant/certs/server/server.jks" >> /etc/elasticsearch/elasticsearch.yml
sudo echo "shield.ssl.keystore.password:      qqq123" >> /etc/elasticsearch/elasticsearch.yml
sudo echo "shield.transport.ssl:              true" >> /etc/elasticsearch/elasticsearch.yml
sudo echo "shield.ssl.hostname.verification.resolve.name: false" >> /etc/elasticsearch/elasticsearch.yml
sudo echo "transport.profiles.client.shield.ssl.client.auth: no" >> /etc/elasticsearch/elasticsearch.yml

sudo /usr/share/elasticsearch/bin/shield/esusers useradd es_admin -p qqq123

sudo service elasticsearch start
