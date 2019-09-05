FROM ubuntu

# ADD packages /root/packages
#WORKDIR /root
RUN apt-get update
RUN apt-get install -y python3-pip geoipupdate libemail-outlook-message-perl
RUN geoipupdate
RUN pip3 install -U parsedmarc

CMD ["parsedmarc", "-c", "/etc/parsedmarc.ini"]
