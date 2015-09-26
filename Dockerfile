FROM ubuntu:14.04
MAINTAINER Yu-Cheng (Henry) Huang

# Installed Packages:
#   Essentials:
#       - gcc
#       - g++
#       - git
#       - Vim with lots of plugins
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
	apt-get install -y man vim tmux nmap git gdb curl python-pip python-dev build-essential john strace ltrace ipython gcc g++ wget && \
	pip install --upgrade pip && \
    pip install pwntools && \
	git clone https://github.com/Happyholic1203/dotfiles && \
	cd dotfiles && \
	git checkout -b vim origin/vim && \
	chmod +x ./install.sh && \
	./install.sh && \
	cd /tmp && \
	git clone https://github.com/Z3Prover/z3 && \
	cd z3 && \
	python scripts/mk_make.py && \
	cd build && \
	make && \
	make install && \
	cd ../.. && \
	rm -rf z3 && \
	wget -qO- qira.me/dl | unxz | tar x && \
	cd qira && \
	sed -i 's/apt-get install/apt-get install -y/g' install.sh && \
	sed -i 's/apt-get install/apt-get install -y/g' qemu_build.sh && \
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
    cd /opt && \
    git clone https://bitbucket.org/LaNMaSteR53/recon-ng && \
    ln -sf /opt/recon-ng/recon-ng /usr/local/bin/recon-ng && \
	echo 'alias msfconsole="/opt/metasploit/ctlscript.sh start >/dev/null 2>&1 & msfconsole"' >> ~/.bash_aliases && \
	echo "#!/bin/bash" >> ~/init && \
	echo "TERM=xterm-256color tmux" >> ~/init && \
	echo "bash" >> ~/init && \
	chmod +x ~/init

# qira
EXPOSE 3002 3003 4000

CMD ["/root/init"]