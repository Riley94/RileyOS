# RileyOS

## Description

This is a simple x86 32 bit operating system including the following components

1. Boot loader
2. Operating system kernel, including
    1. ISRs to handle CPU interrupts
    2. VGA driver
    3. Keyboard driver
    4. Shell
    5. Dynamic memory allocation

## Setup

### Install Assembler and Emulator

```bash
sudo apt update
sudo apt install qemu-system nasm build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
```

### Build Cross Compiler

# download latest releases
https://ftp.gnu.org/gnu/gdb/
https://ftp.gnu.org/gnu/gcc/
https://ftp.gnu.org/gnu/binutils/

```
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"
```

# Build Binutils and GDB for debugging
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

# Build GCC
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

# Set Path to Built Compiler (If using a new shell session)
```
export PATH="$HOME/opt/cross/bin:$PATH"
```

## Usage

### Boot

```
make run
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
