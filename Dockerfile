FROM mikefaille/etcd:latest
MAINTAINER Michaël Faille <michael.faille@nuagebec.ca>
ADD supervisor-confd.conf /etc/supervisor/conf.d/confd.conf

# go get confd and prepare confd directories
RUN go get github.com/kelseyhightower/confd  && mkdir -p /etc/confd/conf.d && mkdir -p /etc/confd/templates


CMD ["/data/run.sh"]
