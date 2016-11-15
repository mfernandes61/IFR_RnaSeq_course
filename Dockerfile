FROM foodresearch/bppc
MAINTAINER Mark Fernandes <mark.fernandes@ifr.ac.uk>
#
# Docker environment for intro to RnaSeq course
# Based upon http://www.ebi.ac.uk/training/online/course/ebi-next-generation-sequencing-practical-course/rna-sequencing/rna-seq-analysis-transcriptome 
#
USER root 
ENV   SIAB_USER=guest \
  SIAB_GROUP=guest \
  SIAB_PASSWORD=ngsintro \
  SIAB_HOME=/home/$SIAB_USER 
ENV COURSEDIR=/home/guest
# NB /home and below are a VOLUME in bppc Dockerfile

COPY welcome.txt /etc/motd
RUN mkdir /tools /course_material
RUN apt-get update && apt-get install -y samtools tophat r-base git

# Install Topha, cufflinks, samtools, igv viewer, htseqc-count, DESeq2, DEXXSeq, STAR, bowtie
# original course used Zebrafish data from http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE18508
# for igv update /etc/apt/sources.list to include multiverse
# deb http://us.archive.ubuntu.com/ubuntu vivid main multiverse & then apt-get install igv
# 
# Install STAR git clone https://github.com/alexdobin/STAR.git && cd STAR && make STAR
#
# instal htslib & bcftools from source (do for Samtools also?)
# add Biolinux ppa
#
RUN cd /tools && git clone https://github.com/alexdobin/STAR.git ./ && cd STAR && make STAR
# RUN cd /tools && git clone https://github.com/samtools/htslib.git  && git clone https://github.com/samtools/bcftools.git  
# RUN git clone https://github.com/samtools/samtools.git
RUN mkdir /usr/local/bin/plugins
# RUN cd /tools/htslib && make install
# RUN cd /tools/bcftools && make install
#RUN cd /course_material && git clone https://github.com/ecerami/samtools_primer.git ./

# Hopefully that's all pre-requisites in place
# RUN chown -R guest.guest $COURSEDIR

ENTRYPOINT ["/scripts/launchsiab.sh"]
CMD ["/bin/bash"]
