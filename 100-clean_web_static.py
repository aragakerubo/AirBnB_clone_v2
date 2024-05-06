#!/usr/bin/python3
"""
Fabric script that distributes an archive to your web servers
"""


from fabric.api import env, put, run
from os.path import exists

env.hosts = ["34.232.69.100", "100.26.173.88"]
env.user = "ubuntu"
env.key_filename = "~/id_rsa"


def do_deploy(archive_path):
    """distributes an archive to your web servers"""
    if exists(archive_path) is False:
        return False
    try:
        put(archive_path, "/tmp/")
        run(
            "sudo mkdir -p /data/web_static/releases/{}/".format(
                archive_path[9:-4]
            )
        )
        run(
            "sudo tar -xzf /tmp/{} -C /data/web_static/releases/{}/".format(
                archive_path[9:], archive_path[9:-4]
            )
        )
        run("sudo rm /tmp/{}".format(archive_path[9:]))
        run(
            "sudo mv /data/web_static/releases/{}/web_static/* /data/web_static/releases/{}/".format(
                archive_path[9:-4], archive_path[9:-4]
            )
        )
        run(
            "sudo rm -rf /data/web_static/releases/{}/web_static".format(
                archive_path[9:-4]
            )
        )
        run("sudo rm -rf /data/web_static/current")
        run(
            "sudo ln -s /data/web_static/releases/{}/ /data/web_static/current".format(
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
