# test-elastic21-with-shield-vagrant

Create an environment for testing Elasticsearch 2.1 with Shield 2.1 .

Java keystores are generated by scripts : https://github.com/lbudai/test-java-keystores-with-ca


## start the environment
`vagrant up`

## test with syslog-ng

### example syslog-ng conf

```
@version: 3.8
@include "scl.conf"


source s_network {
    network(port(5555));
};

destination d_elastic {
    elasticsearch2(
        client_lib_dir(/usr/share/elasticsearch/lib)
        client_mode("transport")
        cluster("es-syslog-ng")
        index("es-syslog-ng")
        port("9300")
        server("vagrant-es-server")
        type("slng_test_type")
        resource("/opt/syslog-ng-ose-3.8/etc/elasticsearch.yml")
    );
};


log {
   source(s_network);
   destination(d_elastic);
   flags(flow-control);
};

```

### elasticsearch config file for client (used by syslog-ng as a resource)
```
path.home: /usr/share/elasticsearch
shield.ssl.keystore.path: /home/test/es/certs/client/client.jks
shield.ssl.keystore.password: qqq123
shield.transport.ssl: true
shield.user: es_admin:qqq123
```

### send message
```
logger -s TEST-MSG-$RANDOM 2>&1 | nc localhost 5555
```

### check the index
```
curl -u es_admin:qqq123 -XGET 192.168.33.10:9200/_cat/indices/es-syslog-ng
```

### query the index

```
curl -u es_admin:qqq123 -XGET 192.168.33.10:9200/es-syslog-ng/
```
