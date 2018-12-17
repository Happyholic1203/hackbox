FROM ubuntu:xenial
MAINTAINER Yu-Cheng (Henry) Huang

SHELL ["/bin/bash", "-c"]

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y man git git-core tmux bash-completion curl wget \
        python-pip python3-pip python-dev build-essential cmake unzip \
        xz-utils nmap john strace ltrace gcc g++ libc6-dev-i386 \
        gdbserver lib32stdc++6 libxml2-dev libxslt1-dev libssl-dev nasm \
        libboost1.58-dev libpython2.7-dev libc6-dbg libc6-dbg:i386 sudo \
        net-tools dnsutils iputils-ping netcat binutils gcc-multilib \
        g++-multilib qemu gdb libcapstone3 libcapstone-dev ruby-dev socat && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN pip install --upgrade pip setuptools && \
    pip install --upgrade ipython && \
    pip install --upgrade pwntools && \
    pip install --upgrade ipython && \
    pip install --upgrade ropgadget && \
    pip3 install --upgrade setuptools && \
    pip3 install --upgrade ipython && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN cd ~ && \
    git clone https://github.com/longld/peda ~/peda && \
    git clone https://github.com/Happyholic1203/Pwngdb ~/Pwngdb && \
    git clone https://github.com/JonathanSalwan/ROPgadget ~/ROPgadget && \
    cp ~/Pwngdb/.gdbinit ~/ && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN pushd ~ && \
    git clone https://github.com/Happyholic1203/dotfiles && \
    pushd ~/dotfiles && \
    chmod +x ./install.sh && \
    ./install.sh --with-ycm --with-ranger && \
    rm -rf ~/.vim/bundle/YouCompleteMe//third_party/ycmd/clang_archives/ && \
    echo "#!/bin/bash" > ~/init && \
    echo "TERM=xterm-256color tmux" >> ~/init && \
    echo "bash" >> ~/init && \
    chmod +x ~/init && \
    popd && \
    popd && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN export tmp=$(mktemp -d) && \
    pushd $tmp && \
    wget https://github.com/vim/vim/archive/v8.1.0593.zip && \
    unzip *.zip && \
    pushd vim-* && \
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
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 && \
    make install && \
    rm -f /usr/bin/vi && \
    ln -sf `which vim` /usr/bin/vi && \
    popd && \
    popd && \
    rm -rf $tmp && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget https://bitbucket.org/LaNMaSteR53/recon-ng/get/v4.9.4.tar.gz && \
    tar -zxvf v*.tar.gz && \
    mv LaNMaSteR53-recon-ng* ~/recon-ng && \
    popd && \
    rm -rf $tmp && \
    pushd ~/recon-ng && \
    bash -c 'pip install -r REQUIREMENTS || pip install -r REQUIREMENTS || pip install -r REQUIREMENTS' && \
    ln -sf ~/recon-ng/recon-ng /usr/local/bin/recon-ng && \
    popd && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN pushd ~ && \
    git clone https://github.com/radare/radare2 && \
    pushd radare2 && \
    ./sys/install.sh && \
    find . -type f -name '*.o' -exec rm -f {} \; && \
    find . -type f -name '*.a' -exec rm -f {} \; && \
    popd && \
    popd && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN export tmp=$(mktemp -d) && \
    pushd $tmp && \
    wget https://github.com/Z3Prover/z3/tarball/z3-4.8.3 && \
    tar zxvf z3-* && \
    mv Z3Prover-z3-* z3 && \
    pushd z3 && \
    python scripts/mk_make.py --python && \
    pushd build && \
    make && \
    make install && \
    popd && \
    popd && \
    popd && \
    rm -rf $tmp && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget https://github.com/Happyholic1203/qira/tarball/09c65a5c26fd0aab2e9997e6e17e720af7c280be && \
    tar -zxvf 09c65a5c26fd0aab2e9997e6e17e720af7c280be && \
    mv *-qira-* ~/qira && \
    popd && \
    rm -rf $tmp && \
    pushd ~/qira && \
    ./install.sh && \
    pushd ~/qira/tracers/qemu ; \
    for q in qira-*; do mv $(readlink $q) $q; done ; \
    rm -rf qemu-* ; \
    popd ; \
    popd ; \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget http://downloads.metasploit.com/data/releases/metasploit-latest-linux-x64-installer.run && \
    chmod +x metasploit-latest-linux-x64-installer.run && \
    ./metasploit-latest-linux-x64-installer.run --mode unattended --unattendedmodeui none && \
    popd && \
    rm -rf $tmp && \
    rm -f /var/lib/apt/lists/*;  rm -rf /tmp/*; rm -rf ~/.cache

RUN export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget http://software.intel.com/sites/landingpage/pintool/downloads/pin-2.14-71313-gcc.4.4.7-linux.tar.gz && \
    tar xvzf pin-*linux.tar.gz && \
    mv pin-*linux ~/pin && \
    popd && \
    rm -rf $tmp && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN export tmp=`mktemp -d` && \
    pushd $tmp && \
    wget https://github.com/JonathanSalwan/Triton/tarball/master && \
    tar -zxvf master && \
    mv JonathanSalwan-Triton-* ~/pin/source/tools/Triton && \
    popd && \
    rm -rf $tmp && \
    pushd ~/pin/source/tools/Triton && \
    mkdir build && \
    pushd build && \
    cmake -DPINTOOL=on -DKERNEL4=on .. && \
    make -j$(grep processor < /proc/cpuinfo | wc -l) install && \
    popd && \
    find . -type f -name '*.o' -exec rm -f {} \; && \
    popd && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN cd ~ && \
    wget https://github.com/sqlmapproject/sqlmap/tarball/master --output-document=sqlmap.tar.gz && \
    tar -zxvf sqlmap.tar.gz && \
    mv sqlmapproject-sqlmap-* sqlmap && \
    ln -sf `pwd`/sqlmap/sqlmap.py /usr/local/bin/sqlmap && \
    rm -f sqlmap.tar.gz && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN command curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    \curl -sSL https://get.rvm.io | bash -s stable --ruby && \
    source /usr/local/rvm/scripts/rvm && \
    echo 'source /etc/profile.d/rvm.sh' >> ~/.bashrc_custom && \
    gem install one_gadget && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN export tmp=$(mktemp -d) && \
    pushd $tmp && \
    wget https://github.com/ReFirmLabs/binwalk/archive/v2.1.1.tar.gz && \
    tar -zxvf v2.1.1.tar.gz && \
    cd binwalk-* && \
    python setup.py install && \
    popd && \
    rm -rf $tmp && \
    rm -f /var/lib/apt/lists/*; rm -rf /tmp/*; rm -rf ~/.cache

RUN echo "#!/bin/bash" > ~/msfconsole && \
    echo "pass=`sed -n 's/\s*password:\s*\"\([0-9a-z]*\)\"$/\1/p' /opt/metasploit/apps/pro/ui/config/database.yml | sort | uniq`" >> ~/msfconsole && \
    echo 'msf=/opt/metasploit/ctlscript.sh' >> ~/msfconsole && \
    echo '$msf status | grep "already running" || $msf start' >> ~/msfconsole && \
    echo '/usr/local/bin/msfconsole --quiet -x "db_disconnect; db_connect msf3:$pass@localhost:7337/msf3"' >> ~/msfconsole && \
    echo 'export PATH="$PATH:~/pin/source/tools/Triton/build"' >> ~/.bashrc_custom && \
    chmod +x ~/msfconsole && \
    echo "alias msfconsole='~/msfconsole'" >> ~/.aliases && \
    rm -rf /tmp/* && \
    rm -rf ~/.cache ; \
    rm -f ~/.bash_history ; \
    rm -f ~/.config/radare2/history ; \
    rm -rf ~/.pwntools-cache ; \
    rm -f ~/.gdb_history ; \
    rm -f ~/.viminfo ; \
    rm -f ~/.config/ranger/history ; \
    rm -f ~/.config/radare2/history; \
    ipython profile create && \
    sed -i "s/.*\(c\.TerminalInteractiveShell\.editing_mode\).*/\1 = 'vi'/g" ~/.ipython/profile_default/ipython_config.py

# qira
EXPOSE 3002 3003 4000

CMD ["/root/init"]
