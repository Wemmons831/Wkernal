
# Wkernal

A simple x86_64 based kernal that can write colored text to the screen using vga text mode




## Installation

Install Wkernal with git

```bash
  git clone https://github.com/Wemmons831/Wkernal
  cd Wkernal
```

    
## Building
If you wish to build this I recomend using this docker
```bash
    docker build buildenv -t myos-buildenv
```
to isntall image and
```bash
    Windows: docker run --rm -it -v "%cd%":/root/env myos-buildenv
    Mac & Linux: docker run --rm -it -v "$(pwd)":/root/env myos-buildenv
```
to activate the docker image. Finaly to build simply run
```bash
    ./make.sh
```
## Usage
After building a ISO can be found in dist/x86_64. To run this iso you can load it on your hardware by flashing it to a usb drive. Or you can use Qemu. If you go with Qemu you will have to run
```Bash
    qemu-system-x86_64 -cdrom dist/x86_64/kernel.iso
``` 
To run the emulated os.
<br>
To change what is being printed you can play around with the contents of src/impl/kernal/mainc.cpp
