devbox-agda
===========

Docker image for [agda](https://github.com/BILS/agda/) development.

It's based on
[viklund/devbox-slurm](https://github.com/viklund/docker/tree/master/devbox-slurm).

# Instructions

1. Clone agda somewhere

    $ git clone https://github.com/BILS/agda.git

    $ cd agda

2. Start the container with the agda checkout mounted at /srv/agda

    $ docker run -P -d --name 'agda-dev' --hostname 'agda-dev' -v `pwd`:/srv/agda viklund/devbox-agda

3. Agda will now run through the django http server on port 8000 in the
   container. Check the port that 8000 maps to:

    $ docker port agda-dev | grep 8000
