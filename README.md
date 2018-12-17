# hackbox
A lovely box packed with tools I've been using for playing CTFs, reverse-engineering, and development.

## Running
To start it, run:
`docker run -it happyholic1203/hackbox`

I use tmux a lot, so it enters tmux by default.

To use gdb, you need to add `--cap-add SYS_PTRACE`, so it goes like

```shell
docker run -it --cap-add SYS_PTRACE happyholic1203/hackbox
```

## List of Installed Packages

- Essentials:
  - gcc, g++, git
  - Vim with lots of plugins
- PenTest Tools:
  - Metasploit
  - sqlmap
  - nmap
  - Recon-ng
- Reversing/Pwn Tools:
  - radare2
  - GDB with Peda/Pwngdb
  - pwntools
  - one_gadget
  - ROPGadget
  - pintool
  - qemu
  - qira
- Symbolic Execution:
  - Z3Prover
  - Triton
- Misc:
  - Tmux
  - John the Ripper
  - binwalk
  - netcat
  - ranger

## Share as Well
If you happen to know another must-have tool, please let me know!!
