FROM happyholic1203/devbox
MAINTAINER Yu-Cheng (Henry) Huang

# Installed Packages:
#   Essentials:
#       - gcc
#       - g++
#       - git
#       - Vim with lots of plugins
#       - ctags (for NerdTree)
#   PenTest Tools:
#       - Metasploit
#       - sqlmap
#       - nmap
#       - Recon-ng
#   Reversing Tools:
#       - qira
#       - GDB with Peda
#   Misc:
#       - Z3Prover
#       - Tmux
#       - John the Ripper
#       - PwnTools

RUN apt-get update && \
    apt-get install -y nmap gdb john strace ltrace gcc g++ libc6-dev-i386 \
        ctags gdbserver python-dbg lib32stdc++6 libxml2-dev libxslt1-dev \
        libssl-dev nasm && \
    pip install pwntools && \
    cd /tmp && \
    git clone https://github.com/Z3Prover/z3 && \
    cd z3 && \
    git checkout -b z3-4.4.1 z3-4.4.1 && \
    python scripts/mk_make.py && \
    cd build && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf z3 && \
    cd ~ && \
    git clone https://github.com/BinaryAnalysisPlatform/qira && \
    cd qira && \
    git checkout -b stable ac26ea54a7846fa40b131881a91532a3f400a510 && \
    ./install.sh && \
    wget http://downloads.metasploit.com/data/releases/metasploit-latest-linux-x64-installer.run && \
    chmod +x metasploit-latest-linux-x64-installer.run && \
    ./metasploit-latest-linux-x64-installer.run --mode unattended --unattendedmodeui none && \
    rm -f metasploit-latest-linux-x64-installer.run && \
    git clone https://github.com/longld/peda ~/peda && \
    echo "source ~/peda/peda.py" >> ~/.gdbinit && \
    cd ~ && \
    wget 'https://github.com/sqlmapproject/sqlmap/tarball/master' --output-document=sqlmap.tar.gz && \
    tar -zxvf sqlmap.tar.gz && \
    mv sqlmapproject-sqlmap-* sqlmap && \
    ln -sf `pwd`/sqlmap/sqlmap.py /usr/local/bin/sqlmap && \
    rm -f sqlmap.tar.gz && \
    cd /opt && \
    git clone https://bitbucket.org/LaNMaSteR53/recon-ng && \
    cd recon-ng && \
    pip install -r REQUIREMENTS && \
    ln -sf /opt/recon-ng/recon-ng /usr/local/bin/recon-ng && \
    cd /tmp && \
    wget http://www.capstone-engine.org/download/3.0.4/ubuntu-14.04/libcapstone3_3.0.4-0.1ubuntu1_amd64.deb && \
    dpkg -i libcapstone3_3.0.4-0.1ubuntu1_amd64.deb && \
    rm -f libcapstone3_3.0.4-0.1ubuntu1_amd64.deb && \
    echo "#!/bin/bash" > ~/msfconsole && \
    echo "pass=`sed -n 's/\s*password:\s*\"\([0-9a-z]*\)\"$/\1/p' /opt/metasploit/apps/pro/ui/config/database.yml | sort | uniq`" >> ~/msfconsole && \
    echo 'msf=/opt/metasploit/ctlscript.sh' >> ~/msfconsole && \
    echo '$msf status | grep "already running" || $msf start' >> ~/msfconsole && \
    echo '/usr/local/bin/msfconsole --quiet -x "db_disconnect; db_connect msf3:$pass@localhost:7337/msf3"' >> ~/msfconsole && \
    chmod +x ~/msfconsole && \
    echo "alias msfconsole='~/msfconsole'" >> ~/.bash_aliases

# qira
EXPOSE 3002 3003 4000
