output "FIREWALL_IP_ADDRESS" {
  value = "https://${module.vm-series.firewall-ip}"
}

output "VULNERABLE_APP_SERVER" {
  value = module.vulnerable-vpc.instance_ips["victim"]
}

output "ATTACK_APP_SERVER" {
  value = module.attack-vpc.instance_ips["attacker"]
}