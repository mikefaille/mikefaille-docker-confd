FROM mikefaille/etcd:latest
MAINTAINER Michaël Faille <michael.faille@nuagebec.ca>
ADD supervisor-confd.conf /etc/supervisor/conf.d/confd.conf

RUN go get github.com/kelseyhightower/confd 


CMD ["run.sh"]
