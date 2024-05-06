#!/usr/bin/python3
"""
Fabric script that distributes an archive to your web servers
"""

# Write a Fabric script (based on the file 2-do_deploy_web_static.py) that creates and distributes an archive to your web servers, using the function deploy:

# Prototype: def deploy():
# The script should take the following steps:
# Call the do_pack() function and store the path of the created archive
# Return False if no archive has been created
# Call the do_deploy(archive_path) function, using the new path of the new archive
# Return the return value of do_deploy
# All remote commands must be executed on both of web your servers (using env.hosts = ['<IP web-01>', 'IP web-02'] variable in your script)
# You must use this script to deploy it on your servers: xx-web-01 and xx-web-02
# In the following example, the SSH key and the username used for accessing to the server are passed in the command line. Of course, you could define them as Fabric environment variables (ex: env.user =…)

from fabric.api import env, put, run
from os.path import exists

env.hosts = ["34.232.69.100", "100.26.173.88"]
env.user = "ubuntu"
env.key_filename = "~/.ssh/holberton"


def do_deploy(archive_path):
    """distributes an archive to your web servers"""
    if exists(archive_path) is False:
        return False
    try:
        put(archive_path, "/tmp/")
        run("mkdir -p /data/web_static/releases/{}/".format(archive_path[9:-4]))
        run(
            "tar -xzf /tmp/{} -C /data/web_static/releases/{}/".format(
                archive_path[9:], archive_path[9:-4]
            )
        )
        run("rm /tmp/{}".format(archive_path[9:]))
        run(
            "mv /data/web_static/releases/{}/web_static/* /data/web_static/releases/{}/".format(
                archive_path[9:-4], archive_path[9:-4]
            )
        )
        run(
            "rm -rf /data/web_static/releases/{}/web_static".format(
                archive_path[9:-4]
            )
        )
        run("rm -rf /data/web_static/current")
        run(
            "ln -s /data/web_static/releases/{}/ /data/web_static/current".format(
                archive_path[9:-4]
            )
        )
        return True
    except:
        return False


def deploy():
    """creates and distributes an archive to your web servers"""
    archive_path = do_pack()
    if archive_path is None:
        return False
    return do_deploy(archive_path)


def do_pack():
    """generates a tgz archive"""
    from datetime import datetime
    from fabric.api import local
    from os.path import isdir

    try:
        date = datetime.now().strftime("%Y%m%d%H%M%S")
        if isdir("versions") is False:
            local("mkdir versions")
        file_name = "versions/web_static_{}.tgz".format(date)
        local("tar -cvzf {} web_static".format(file_name))
        return file_name
    except:
        return None
