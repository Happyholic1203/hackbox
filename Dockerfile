FROM ubuntu:14.04
MAINTAINER Yu-Cheng (Henry) Huang

# Installed Packages:
#   Essentials:
#       - gcc
#       - g++
#       - git
#       - Vim with lots of plugins
#       - ranger
#   PenTest Tools:
#       - Metasploit
#       - sqlmap
#       - nmap
#       - Recon-ng
#   Reversing Tools:
#       - qira
#       - GDB with Peda/symgdb/Pwngdb
#   Symbolic Execution:
#       - Z3Prover
#       - Triton
#   Misc:
#       - Tmux
#       - John the Ripper
#       - PwnTools

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y man git git-core tmux bash-completion curl wget \
        python-pip python-dev build-essential ipython cmake unzip \
        xz-utils nmap john strace ltrace gcc g++ libc6-dev-i386 \
        gdbserver lib32stdc++6 libxml2-dev libxslt1-dev libssl-dev nasm \
        libboost1.55-dev libpython2.7-dev && \
    export tmp=`mktemp -d` && \
    pushd $tmp && \
	wget https://github.com/Happyholic1203/dotfiles/tarball/master && \
    tar -zxvf master && \
    mv Happyholic1203-dotfiles-* ~/dotfiles && \
	pushd ~/dotfiles && \
	chmod +x ./install.sh && \
	./install.sh --with-ycm --with-ranger && \
	echo "#!/bin/bash" >> ~/init && \
	echo "TERM=xterm-256color tmux" >> ~/init && \
	echo "bash" >> ~/init && \
	chmod +x ~/init && \
    popd && \
    popd && \
    rm -rf $tmp && \
    pip install --upgrade pip && \
    pip install pwntools && \
    export tmp=$(mktemp -d) && \
    pushd $tmp && \
    wget https://github.com/vim/vim/archive/v8.0.1098.zip && \
    unzip v8.0.1098.zip && \
    pushd vim-8.0.1098 && \
    ./configure --with-features=huge \
                --enable-multibyte \
                --enable-rubyinterp=yes \
                --enable-pythoninterp=yes \
                --with-python-config-dir=/usr/lib/python2.7/config \
                --enable-python3interp=yes \
                --with-python3-config-dir=/usr/lib/python3.5/config \
                --enable-perlinterp=yes \
                --enable-luainterp=yes \
                --enable-gui=gtk2 \
                --enable-cscope \
                --prefix=/usr/local && \
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim80 && \
    make install && \
    popd && \
    popd && \
    rm -rf $tmp && \
    export tmp=$(mktemp -d) && \
    pushd $tmp && \
    wget https://github.com/Z3Prover/z3/tarball/z3-4.5.0 && \
    tar zxvf z3-4.5.0 && \
    mv Z3Prover-z3-* z3 && \
    pushd z3 && \
    python scripts/mk_make.py && \
    pushd build && \
    make && \
    make install && \
    popd && \
    popd && \
    popd && \
    rm -rf $tmp && \
    cd ~ && \
    wget https://github.com/BinaryAnalysisPlatform/qira/tarball/ac26ea54a7846fa40b131881a91532a3f400a510 && \
    tar -zxvf ac26ea54a7846fa40b131881a91532a3f400a510 && \
    mv BinaryAnalysisPlatform-qira-ac26ea5 qira && \
    cd qira && \
    ./install.sh && \
    export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget http://downloads.metasploit.com/data/releases/metasploit-latest-linux-x64-installer.run && \
    chmod +x metasploit-latest-linux-x64-installer.run && \
    ./metasploit-latest-linux-x64-installer.run --mode unattended --unattendedmodeui none && \
    popd && \
    rm -rf $tmp && \
    export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget https://github.com/SQLab/symgdb/tarball/master && \
    tar -zxvf master && \
    mv SQLab-symgdb-* ~/symgdb && \
    pushd ~/symgdb && \
    ./install && \
    echo "source ~/symgdb/symgdb.py" >> ~/.gdbinit && \
    popd && \
    popd && \
    rm -rf $tmp && \
    export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget https://github.com/longld/peda/tarball/master && \
    tar -zxvf master && \
    rm -f master && \
    mv longld-peda-* ~/peda && \
    popd && \
    rm -rf $tmp && \
    export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget https://github.com/scwuaptx/Pwngdb/tarball/master && \
    tar -zxvf master && \
    rm -f master && \
    mv scwuaptx-pwngdb-* ~/Pwngdb && \
    popd && \
    rm -rf $tmp && \
    cp ~/Pwngdb/.gdbinit ~/ && \
    cd ~ && \
    wget https://github.com/sqlmapproject/sqlmap/tarball/master --output-document=sqlmap.tar.gz && \
    tar -zxvf sqlmap.tar.gz && \
    mv sqlmapproject-sqlmap-* sqlmap && \
    ln -sf `pwd`/sqlmap/sqlmap.py /usr/local/bin/sqlmap && \
    rm -f sqlmap.tar.gz && \
    export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget https://bitbucket.org/LaNMaSteR53/recon-ng/tarball/master && \
    tar -zxvf master.tar.gz && \
    mv LaNMaSteR53-recon-ng* ~/recon-ng && \
    popd && \
    rm -rf $tmp && \
    cd ~/recon-ng && \
    pip install -r REQUIREMENTS && \
    ln -sf ~/recon-ng/recon-ng /usr/local/bin/recon-ng && \
    export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget http://www.capstone-engine.org/download/3.0.4/ubuntu-14.04/libcapstone3_3.0.4-0.1ubuntu1_amd64.deb && \
    wget 'http://www.capstone-engine.org/download/3.0.4/ubuntu-14.04/libcapstone-dev_3.0.4-0.1ubuntu1_amd64.deb' && \
    dpkg -i libcapstone3_3.0.4-0.1ubuntu1_amd64.deb && \
    dpkg -i libcapstone-dev_3.0.4-0.1ubuntu1_amd64.deb && \
    popd && \
    rm -rf $tmp && \
    cd ~ && \
    wget http://software.intel.com/sites/landingpage/pintool/downloads/pin-2.14-71313-gcc.4.4.7-linux.tar.gz && \
    tar xvzf pin-2.14-71313-gcc.4.4.7-linux.tar.gz && \
    mv pin-2.14-71313-gcc.4.4.7-linux pin && \
    cd pin/source/tools && \
    wget https://github.com/JonathanSalwan/Triton/tarball/master && \
    tar -zxvf master && \
    mv JonathanSalwan-Triton-* Triton && \
    cd Triton && \
    mkdir build && \
    cd build && \
    cmake -DPINTOOL=on .. && \
    make -j$(grep processor < /proc/cpuinfo | wc -l) install && \
    echo "#!/bin/bash" > ~/msfconsole && \
    echo "pass=`sed -n 's/\s*password:\s*\"\([0-9a-z]*\)\"$/\1/p' /opt/metasploit/apps/pro/ui/config/database.yml | sort | uniq`" >> ~/msfconsole && \
    echo 'msf=/opt/metasploit/ctlscript.sh' >> ~/msfconsole && \
    echo '$msf status | grep "already running" || $msf start' >> ~/msfconsole && \
    echo '/usr/local/bin/msfconsole --quiet -x "db_disconnect; db_connect msf3:$pass@localhost:7337/msf3"' >> ~/msfconsole && \
    echo 'export PATH="$PATH:~/pin/source/tools/Triton/build"' >> ~/.bashrc && \
    chmod +x ~/msfconsole && \
    echo "alias msfconsole='~/msfconsole'" >> ~/.bash_aliases

# qira
EXPOSE 3002 3003 4000

CMD ["/root/init"]
