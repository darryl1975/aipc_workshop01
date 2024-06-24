resource "docker_image" "bgg-database" {
    name = "chukmunnlee/bgg-database: ${var.database_version}"
}

resource "docker_image" "bgg-backend" {
    name = "chukmunnlee/bgg-backend: ${var.backend_version}"
}

resource "docker_network" "bgg-net" {
    name = "my-sgp-bgg-net"
}

resource "docker_volume" "data-vol" {
  name = "mg-sgp-data-vol"
}

resource "docker_container" "bgg-database" {

    networks_advanced {
        name = docker_network.bgg-net.id
    }

    ports {
        internal = 3306
        external = 3306
    }

    volumes {
        volume_name = docker_volume.data-vol.name
        container_path = "/var/lib/mysql"
    }
}

resource "docker_container" "bgg-backend" {
    count = var.backend_instance_count

    name = "my-sgp-bgg-backend-${count.index}" 

    image = docker_image.bgg-backend.image-id

    networks_advanced {
        name = docker_network.bgg-net.id
    }

    env = [
        "BGG_DB_USER=root",
        "BGG_DB_PASSWORD=changeit",
        "BGG_DB_HOST=${docker_container.bgg-database.name}"
    ]

    ports = {
        internal = 3000
    }
}

resource "local_file" "nginx-conf" {
    filename = "nginx.conf"
    content = templatefile("nginx.conf.tftpl", {
        docker_host = var.docker_host,
        ports = docker_container.bgg-backend[*].ports[*].external
    })
}

resource "digitalocean_droplet" "nginx" {
    name = "darryl-nginx"
    image = var.do_image
    region = var.do_region
    size = var.do_size

    ssh_keys = [ data.digitalocean_ssh_key.www-1.id ]

    connection {
        type = "ssh"
        user = "root"
        private_key = file(var.ssh_private_key)
        host = self.ipv4_address
    }

    provisioner "remote-exec" {
        inline = [
            "apt update -y",
            "apt install nginx -y"
        ]
    }

    provisioner "file" {
        source = local_file.nginx-conf.filename
        destination = "/etc/inginx/nginx.conf"
    }

    provisioner "remote-exec" {
        inline = [
            "systemctl enable nginx",
            "systemctl restart nginx"
        ]
    }
}

resource "local_file" "root_at_nginx" {
    filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
    content = ""
    file_permission = "0444"
}