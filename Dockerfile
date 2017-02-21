FROM dorowu/ubuntu-desktop-lxde-vnc
MAINTAINER Mark Fernandes <mark.fernandes@ifr.ac.uk>
# Environment to deliver EBI RNAseq course using  LXDE and VNC server under Docker
# Based uponn http://www.ebi.ac.uk/training/online/course/ebi-next-generation-sequencing-practical-course/rna-sequencing/rna-seq-analysis-transcriptome 
#
RUN REL="$(lsb_release -c -s)"
# Add the appropriate repositories including CRAN
RUN \
	  apt-get update && \
	  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
	   apt-get install -y  software-properties-common && \
#   add-apt-repository  "deb http://archive.ubuntu.com/ubuntu '$REL' universe" && \
#	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu '$REL' main restricted universe multiverse" && \
#	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu '$REL'-updates main restricted universe multiverse" && \
#	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu '$REL'-backports main restricted universe multiverse" && \
#  add-apt-repository  "deb http://cran.ma.imperial.ac.uk/bin/linux/ubuntu '$REL'/" && \
	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu trusty universe" && \
	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse" && \
	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse" && \
	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" && \
	add-apt-repository  "deb http://cran.ma.imperial.ac.uk/bin/linux/ubuntu trusty/"

RUN	apt-get update && apt-get install -y wget git unzip default-jre r-base r-base-dev samtools fastqc  libcurl4-openssl-dev \
	libxml2-dev igv bowtie2 tophat cufflinks evince build-essential python-numpy python-matplotlib python-pip ipython \
	ipython-notebook python2.7-dev && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
#
# create our folders incl. fastqc folder & files that are not installed by apt-get install fastqc :-(
RUN mkdir /etc/fastqc && mkdir /etc/fastqc/Configuration && mkdir /scripts && mkdir /course_material && mkdir /tools && \
	mkdir /course_material/genome && mkdir /course_material/data
ADD fastqc/* /etc/fastqc/Configuration/
ADD genome/*.zip /course_material/genome
ADD *.pynb /course_material
RUN cd /course_material/genome && unzip *.zip && rm *.zip && chmod o+x /usr/bin/ipython

# RUN cd /tools && wget http://www.bioinformatics.babraham.ac.uk/projects/seqmonk/seqmonk_v1.37.0.zip && \
# 	wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.0.5-Linux_x86_64.zip && unzip seq*.zip && \
# 	unzip hisat*.zip && rm /tools/*.zip && chmod 755 /tools/Seq*/seqmonk && ln -s /tools/Seq*/seqmonk /usr/local/bin/ && \
# 	ln -s /tools/hisat2*/* /usr/local/bin/ && mkdir /tools/examples && cd /tools/examples && \
# 	wget http://www.bioinformatics.babraham.ac.uk/projects/seqmonk/example_seqmonk_data.smk
# cd /tools/SeqMonk chmod 755 seqmonk and ln -s  to /usr/local/bin/.  ln -s /tools/hisat2*/hisat2 /usr/local/bin/


USER root
#RUN R -e \"source('https://bioconductor.org/biocLite.R'); biocLite('DESeq2')\"
# RUN bash - -c "R -e \"source('http://bioconductor.org/biocLite.R'); biocLite('DESeq2')\""
# -c means commands read from string 

RUN cd /course_material && wget ftp://ftp.ebi.ac.uk/pub/training/Train_online/RNA-seq_exercise/* && mv *.fastq /course_material/data/
ADD Welcome.txt /etc/motd
ADD /scripts/*.sh /scripts/
RUN chmod +x /scripts/*.sh && ln -s /scripts/add2R /usr/local/bin/
# RUN add2R.sh

EXPOSE 22 8888
VOLUME /Coursedata
#-----------------------------

# Install Tophat, cufflinks, samtools, igv viewer, htseqc-count, DESeq2, DEXXSeq, STAR, bowtie

# Install STAR git clone https://github.com/alexdobin/STAR.git && cd STAR && make STAR

#
RUN cd /tools && git clone https://github.com/alexdobin/STAR.git ./ && pwd &&  ls && cd source && make && \
	ln -s /tools/bin/Linux_x86_64/*  /usr/local/bin
# RUN cd /tools && git clone https://github.com/samtools/htslib.git  && git clone https://github.com/samtools/bcftools.git  
# RUN git clone https://github.com/samtools/samtools.git
RUN mkdir /usr/local/bin/plugins
# RUN cd /tools/htslib && make install
# RUN cd /tools/bcftools && make install
#RUN cd /course_material && git clone https://github.com/ecerami/samtools_primer.git ./

# Hopefully that's all pre-requisites in place
