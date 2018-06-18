FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y ca-certificates
ADD apiserver .
ADD controller-manager .
