locals {
  master = {
    node1 = {
      name       = "1"
      datacenter = "nbg1-dc3"
    }
    node2 = {
      name       = "2"
      datacenter = "hel1-dc2"
    }
  }
  worker = {
    node1 = {
      name       = "1"
      datacenter = "nbg1-dc3"
    }
    node2 = {
      name       = "2"
      datacenter = "hel1-dc2"
    }
    node3 = {
      name       = "3"
      datacenter = "fsn1-dc14"
    }
    node4 = {
      name       = "4"
      datacenter = "fsn1-dc14"
    }

  }
}


resource "hcloud_server" "master" {
  for_each = local.master

  name        = "master-${each.value.name}"
  image       = "ubuntu-24.04"
  server_type = "cpx21"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  datacenter = each.value.datacenter

  labels = {
    "node-role.kubernetes.io/master" = "true"
  }

  ssh_keys = ["mav000"]
}

resource "hcloud_server" "worker" {
  for_each = local.worker

  name        = "worker-${each.value.name}"
  image       = "ubuntu-24.04"
  server_type = "cpx31"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  datacenter = each.value.datacenter

  labels = {
    "node-role.kubernetes.io/worker" = "true"
  }

  ssh_keys = ["mav000"]
}