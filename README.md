# A Docker Image to Mirror Software Repositories


## Goal

Provide a low-maintenance means to mirror software
repositories to removable media, so later it can be
attached to a Linux system without internet access, but
without relying on a permanently allocated
internet-connected system.


## Overview

1. Build a Docker image that runs the [Repositorio] software
   to mirror Linux software repositories.

2. Run the image as a Docker container on whichever
   internet-connected system is convenient, with an attached
   external drive.

3. Move the external drive to the isolated Linux system.

Configuration and data stays on the external drive, so the
Docker image can stay otherwise generic.

[Repositorio]: http://www.repositor.io/


## Requirements

* An external drive
* An internet-connected system that can run [Docker] and
  have a removable / external drive.
  * On Linux, no further requirements should be necessary.
  * Mac and Windows likely need more. One successful
    approach includes:
    * Docker [Toolbox]
    * Oracle [VirtualBox] with the [extension] pack for USB
      support

[Docker]:      https://www.docker.com/
[Toolbox]:     https://www.docker.com/products/overview#/docker_toolbox
[VirtualBox]:  https://www.virtualbox.org/
[extension]:   https://www.virtualbox.org/wiki/Downloads


## Hard Drive Preparation

2016-era releases of Windows, Mac, and Linux all support
[GPT] partitioning, but [MBR] will also work. There should
be a sufficiently large partition with a Linux-native file
system. There might also be another, smaller partition with
a more portable file system, such as [exFAT], to hold
installers for Docker and VirtualBox as well as the saved
image, for convenience even though those can be downloaded
since the system is necessarily internet-connected.

An example partitioning scheme:

|   # | Format                                          | Size         | Purpose               |
| ---:| ----------------------------------------------- | ------------ | --------------------- |
|   1 | [exFAT]                                         | about 100 GB | virtual machine files |
|   2 | any native Linux file system<br>e.g., ext4, xfs | remainder    | data volume           |

[GPT]:    https://en.wikipedia.org/wiki/GUID_Partition_Table
[MBR]:    https://en.wikipedia.org/wiki/Master_boot_record
[exFAT]:  https://en.wikipedia.org/wiki/ExFAT


## Windows and Mac Preparation

If the internet-connected system runs Windows or Mac OS X,
then running Docker will require additional setup.

**TODO**: See if the [still-in-beta] Docker for Windows and
Docker for Mac will simplify matters while still supporting
USB devices.

[still-in-beta]:  https://beta.docker.com/


### Docker Toolbox

An easy way to run Docker on Windows or Mac is to download
[Docker Toolbox]. Docker Toolbox is an installer for various
Docker components and VirtualBox. 

[Docker Toolbox]:  https://www.docker.com/products/docker-toolbox


### VirtualBox Extension Pack

After installing VirtualBox, either as part of Docker
Toolbox or [separately], be sure to install the VirtualBox
[extension pack], which adds support for USB devices.

[separately]:  https://www.virtualbox.org/wiki/Downloads
[extension]:   https://www.virtualbox.org/wiki/Downloads


### Docker VM Settings

Installation of Docker Toolbox will create a new virtual
machine named `default` to run the Docker Engine. In order
for a USB device to be available to the Docker containers
running inside the virtual machine, it first must be
available to the virtual machine itself.

To give the Docker virtual machine  access to a USB device:

1. Halt virtual machine:

   `docker-machine stop`

2. Attach the USB device.

3. Configure the virtual machine to see the external USB
   hard drive:

   * Open VirtualBox Manager
     * Edit settings for `default`
       * Ports
         * USB
           * [X] Enable USB Controller
           * [X] USB 3.0 (xHCI) Controller
           * Add new filter for external hard drive
         * Click OK to save settings

   Note: Repeat step 3 when using a new USB device.

   **TODO**: See if `VBoxManage` is more consistent than the GUI.

4. Restart the virtual machine:

   `docker-machine start`

5. Mount to the virtual machine:

   `docker-machine ssh default sudo mount -v /dev/sdb2 /mnt/sdb2`

   Note: Repeat step 5 whenever the Docker virtual machine
   restarts.

   **TODO**: Figure out how to circumvent TC overwriting fstab.


## Build the Docker image

**TODO**

```Shell
docker build \
  --build-arg=http_proxy='http://192.168.99.1:3128' \
  --rm=true \
  --tag=$image_tag \
  .
```


## Copy repositorio.conf to USB

**TODO**

```Shell
cp $src/example.repositorio.conf /mirror/etc/repositorio.conf
```


## Run the Docker container

**TODO**

```Shell
docker run \
  --rm \
  -it \
  --env=http_proxy='http://192.168.99.1:3128' \
  --volume='/mnt/sdb2':'/mirror' \
  $image_tag
```
