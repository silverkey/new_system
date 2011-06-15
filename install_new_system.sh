#!/bin/sh
#
# Created by Remo Sanges on 6/15/11.
# Copyright 2011 Stzione Zoologica Anton Dohrn. All rights reserved.
#
# MANDATORY BITS TO READ BEFORE TO LAUNCH THIS SCRIPT:
#
# 0) THE SCRIPT NEEDS TO BE LAUNCHED WITHOUT nohup AND WILL PROMPT
#    THE USER SOME QUESTIONS, SO THE USER HAS TO BE CLOSE TO THE SYSTEM
#
# 1) LAUNCH THIS SCRIPT USING sudo!!!
#
# 2) EDIT THE FILE /etc/apt/source.list AND UNCOMMENT THE 'partner' REPOSITORIES
#
# 3) YOU CAN CREATE THE FILE packages.txt
#    ON A WORKING UBUNTU SYSTEM THAT HAVE ALREADY EVERYTHING INSTALLED
#    USING THE COMMAND:
#    sudo dpkg --get-selections > packages.txt
#    OR YOU CAN USE THE ONE IN THE FOLDER CONTAINING THIS SCRIPT
#
# 4) CHECK THE LAST VERSION AND ADDRESS OF BLASTPLUS AND PAML TO DOWNLOAD
#    CURRENTLY THIS HAS TO BE DONE MANUALLY FROM THE FTP SITE THEN YOU CAN
#    CHANGE THE RELATIVE VALUES IN THE LINES BELOW
#
# RANDOM NOTES
#
# Package names are defined by using the command
# apt-cache --names-only search [program name to search]
#
# To see information about a specific package use
# apt-cache show [package name]
#
# Be sure you are installing also recommended packages
# apt-config dump
#
# To search for R-project try to use  apt-cache search r-cran
# but before read the bioconductor and r-project website
# http://cran.at.r-project.org/bin/linux/ubuntu/
#
# AND ALSO WORK ON PERMITTING TO APT-GET TO WORK ON OTHER
# REPOSITORIES [uncomment all]
# EDITING THE FILE /etc/apt/source.list

##################################
# TO BE DONE ONCE FOR THE SYSTEM #
##################################

apt-get update && apt-get upgrade

apt-get -y install dselect

# ADD THE REPOSITORIES
echo '' >> /etc/apt/sources.list
echo 'deb http://cran.at.r-project.org/bin/linux/ubuntu lucid/' >> /etc/apt/sources.list
gpg --keyserver subkeys.pgp.net --recv-key E2A11821
gpg -a --export E2A11821 | sudo apt-key add -
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
apt-get update && apt-get upgrade

# INSTALL APT PACKAGES
dpkg --set-selections < packages.txt
# NEXT LINE WILL ASK INTERACTIONS WITH THE USER
dselect
apt-get update && apt-get upgrade
apt-get -y autoremove

# INSTALL MS OFFICE FONTS
# NEXT LINE WILL ASK INTERACTION WITH THE USER
apt-get -y install msttcorefonts
fc-cache -fv

# INSTALL BIOCONDUCTOR
echo 'source("http://bioconductor.org/biocLite.R")' > BIOC_INSTALL1
echo 'biocLite()' >> BIOC_INSTALL1
R CMD BATCH BIOC_INSTALL1
echo 'source("http://bioconductor.org/biocLite.R")' > BIOC_INSTALL2
echo 'biocLite("GEOquery")' >> BIOC_INSTALL2
R CMD BATCH BIOC_INSTALL2

# UGENE http://ugene.unipro.ru
add-apt-repository ppa:iefremov/ppa
apt-get update && apt-get upgrade
apt-get -y install ugene

############################
# TO BE DONE IN EACH HOME! #
############################

mkdir ~/src

# ENSEMBL
cd ~/src
wget ftp://ftp.ensembl.org/pub/ensembl-api.tar.gz
tar -zxvf ensembl-api.tar.gz

# BIOPERL LIVE
cd ~/src
git clone git://github.com/bioperl/bioperl-live.git

# BIOPERL-RUN
cd ~/src
git clone git://github.com/bioperl/bioperl-run.git

# MEME
cd ~
echo '                                    ' >> .profile
echo '# ----------------------------------' >> .profile
echo '# ADDED BY REMO                     ' >> .profile
echo '# ----------------------------------' >> .profile
echo 'PATH="$PATH:$HOME/src/meme/bin"     ' >> .profile
cd ~/Download
mkdir pre_meme
cd pre_meme
wget http://meme.nbcr.net/downloads/meme_current.tar.gz
tar -zxvf meme_current.tar.gz
rm meme_current.tar.gz
MEME=`ls`
cd $MEME
./configure --prefix=$HOME/src/meme --with-url="http://meme.nbcr.net/meme" --with-procs=6 --enable-opt
make
make test
make install

# PAML http://abacus.gene.ucl.ac.uk/software/paml.html
cd ~/src
wget http://abacus.gene.ucl.ac.uk/software/paml4.4e.tar.gz
tar -zxvf paml4.4d.tar.gz
cd paml44/
rm bin/*.exe
cd src
make -f Makefile
ls -lF
mv baseml basemlg codeml pamp evolver yn00 chi2 ../bin
cd ..
ls -lF bin
bin/baseml
bin/codeml
cd ~
echo 'PATH="$PATH:$HOME/src/paml44/bin"     ' >> .profile

# BLASTPLUS
# blast ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST
# In the repository there is blast identified as blast2
# Here we use blast+ so we have to download it
# Here is the manual ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/user_manual.pdf
cd ~/src
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.2.25+-x64-linux.tar.gz
tar -zxvf ncbi-blast-2.2.25+-x64-linux.tar.gz

apt-get update && apt-get upgrade
apt-get -y autoremove
