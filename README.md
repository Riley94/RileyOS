# RileyOS
Originally forked from: https://github.com/FRosner/FrOS/tree/88aaf8a1aa7c3f913ad0cba2eb9df93e4913c752
## Description

This is a 32 bit operating system designed for an x86 cpu architecture. So far includes:

1. Boot loader
2. Operating system kernel, including
    1. ISRs to handle CPU interrupts
    2. VGA driver
    3. Keyboard driver
    4. Shell
    5. Dynamic memory allocation

## Setup

### Install Assembler, Emulator, and Dependencies for Cross Compiler

```bash
sudo apt update
sudo apt install qemu-system nasm build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
```

### Build Cross Compiler

### download latest releases
https://ftp.gnu.org/gnu/gdb/ \
https://ftp.gnu.org/gnu/gcc/ \
https://ftp.gnu.org/gnu/binutils/

```
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"
```

### Build Binutils and GDB for debugging
```
cd $HOME/src
 
mkdir build-binutils
cd build-binutils
../binutils-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

../gdb.x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-werror
make all-gdb
make install-gdb
```

### Build GCC
```
cd $HOME/src
mkdir build-gcc
cd build-gcc
../gcc-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
```

### Set Path to Built Compiler (If using a new shell session)
this is already done in 'make_and_run.sh'
```
export PATH="$HOME/opt/cross/bin:$PATH"
```

## Usage

### Boot

```
cd RileyOS/
./make_and_run.sh
```

### Debug

```
make debug
```

In GDB shell:

- Set breakpoint at function (e.g. `start_kernel`): `b start_kernel`
- Start execution: `c`
- Jump to next instruction: `n`
- Print variable: `p <variable_name>`
