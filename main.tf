resource "local_file" "services" {
  for_each = local.grouped

  content  = join("\n", [for s in each.value : s.node_address])
  filename = "${each.key}.txt"
}

resource "local_file" "all_addresses" {
  content  = join("\n", local.addresses)
  filename = "addresses.txt"
}

locals {
  # Create a list of ip:port address strings
  addresses = [for id, s in var.services :
    "${s.node_address}:${s.port}"
  ]

  # Create a map of service names to instance IDs
  service_ids = transpose({ for id, s in var.services : id => [s.name] })

  # Group service instances by name
  grouped = { for name, ids in local.service_ids : name => [for id in ids : var.services[id]] }
}
