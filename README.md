# parsedmarc-docker
To configure the davmail.properties file see here:
http://davmail.sourceforge.net/serversetup.html

---
Example docker-compose file:

```
version: '3.0'
services:
  elasticsearch:
    container_name: elasticsearch
    image: docker.elastic.co/elasticsearch/elasticsearch:7.3.1
    environment:
      - discovery.type=single-node
        #- bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xmx2g -Xms2g"
    volumes:
      - ./data/esnode0:/usr/share/elasticsearch/data
    restart: always
 
  davmail:
    container_name: davmail
    image: jberrenberg/davmail
    expose:
      - 1143
    volumes:
      - ./config/davmail.properties:/etc/davmail/davmail.properties:ro
    restart: always

  parsedmarc:
    container_name: parsedmarc
    image: bongoeadgc6/parsedmarc:stable
    links:
      - elasticsearch
      - davmail
    volumes:
      - ./config/parsedmarc.ini:/etc/parsedmarc.ini:ro
    restart: always

  kibana:
    container_name: kibana
    image: docker.elastic.co/kibana/kibana:7.3.1
    links:
      - elasticsearch
    ports:
      - 5601:5601
    environment:
      - SERVER_NAME=dmarc.example.com
      #- ELASTICSEARCH_HOSTS=http://elasticsearch:
      - VIRTUAL_HOST=dmarc.example.com
      - VIRTUAL_NETWORK=proxy-ssl
      - VIRTUAL_PORT=5601
      - CERT_NAME=shared
        #volumes:
            #- ./config/kibana.yml:/usr/share/kibana/config/kibana.yml
    restart: always
    networks:
      - front
      - default

networks:
  front:
    external:
      name: proxy-ssl   
```
