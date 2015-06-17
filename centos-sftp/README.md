centos-sftp
=============

Docker Image of CentOS-6 6.5 x86\_64, with SSH and SFTP.

This will create a container with the name sftp and with a SSH/SFTP user with
the name `user1`:

    $ docker run -d -P --name sftp -e SSH_USER=user1 viklund/centos-sftp

To find out the password, check the logs:

    $ docker logs sftp

You can also specify the password on the command-line by adding
`-e SSH_PASSWORD=fnurken` to the command.

To sftp to the machine, find out the port-mapping for ssh:

    $ docker port sftp
    22/tcp -> 0.0.0.0:49159

Then connect like this (you have to change the port of course):

    $ sftp -P 49159 user1@localhost

If you are running on a mac with `boot2docker`, do this:

    $ sftp -P 49159 user1@`boot2docker ip`

And if you don't wnat to store any information about the host in your `.ssh` settings:

    $ sftp -o "CheckHostIP no" -o "StrictHostKeyCHecking no" -o "UserKnownHostsFile /dev/null" -P 49159 test2@`boot2docker ip`


If you want you can mount a local directory as the home directory for the user,
that way you can have a starting environment for SFTP. Then you will have to
use this `run` command:

    $ docker run -d -P --name sftp2 --hostname sftp -v /tmp/t2:/home/test2 -e SSH_USER=test2 viklund/centos-sftp

That mounts the local directory /tmp/t2 as the home directory for the test2 user.
