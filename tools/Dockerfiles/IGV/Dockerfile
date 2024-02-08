FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y software-properties-common wget unzip glib-networking-common libxrender1 libxtst6 libxi6
RUN apt-get install -y openjdk-8-jdk
RUN mkdir -p /igv && \
	cd /igv && \
	wget http://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.11.zip && \
	unzip IGV_2.4.11.zip && \
	cd IGV_2.4.11/ && \
	cd /usr/bin && \
	ln -s /igv/IGV_2.4.11/igv.sh ./igv
RUN useradd -ms /bin/bash ec2-user
USER ec2-user
WORKDIR /home/ec2-user    
CMD ["/usr/bin/igv"]


