 
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y; \
 apt-get install -y  wget curl xvfb git file sudo python-lzma mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract cramfsprogs cramfsswap squashfs-tools sleuthkit default-jdk lzop srecord python-crypto libqt4-opengl python-opengl python-qt4 python-qt4-gl python-numpy python-scipy python-pip

# Download binwalk
RUN git clone https://github.com/devttys0/binwalk.git /opt/binwalk
WORKDIR /opt/binwalk

# Install sasquatch to extract non-standard SquashFS images
RUN apt-get install -y zlib1g-dev liblzma-dev liblzo2-dev
RUN git clone https://github.com/devttys0/sasquatch /opt/sasquatch
WORKDIR /opt/sasquatch
RUN ./build.sh

# Install jefferson to extract JFFS2 file systems
RUN git clone https://github.com/sviehb/jefferson /opt/jefferson
WORKDIR /opt/jefferson
RUN python setup.py install

# Install ubi_reader to extract UBIFS file systems
RUN apt-get install -y liblzo2-dev python-lzo
RUN git clone https://github.com/jrspruitt/ubi_reader /opt/ubi_reader
WORKDIR /opt/ubi_reader
RUN python setup.py install

# Install yaffshiv to extract YAFFS file systems
RUN git clone https://github.com/devttys0/yaffshiv /opt/yaffshiv
WORKDIR /opt/yaffshiv
RUN python setup.py install

# Install unstuff (closed source) to extract StuffIt archive files
RUN mkdir /opt/stuffit
WORKDIR /opt/stuffit
RUN wget -O - http://my.smithmicro.com/downloads/files/stuffit520.611linux-i386.tar.gz | tar -zxv
RUN cp bin/unstuff /usr/local/bin/

# Install additional python dependencies
RUN pip install pyqtgraph capstone nose coverage cstruct

# Install binwalk
WORKDIR /opt/binwalk
RUN python setup.py install

WORKDIR /root/extracted/

ENTRYPOINT ["binwalk", "-e"]

