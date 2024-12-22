########################################################
# VPC
########################################################

resource "google_compute_network" "vpc" {
  name = "vpc-${var.env}"
  project = var.project
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public1" {
  name = "${var.env}-public-subnet-1"
  region = var.region
  network = google_compute_network.vpc.id
  ip_cidr_range = cidrsubnet(var.vpc_cidr_range, 8, 0)
}

resource "google_compute_subnetwork" "private1" {
  name = "${var.env}-private-subnet-1"
  region = var.region
  network = google_compute_network.vpc.id
  ip_cidr_range = cidrsubnet(var.vpc_cidr_range, 8, 1)
}

resource "google_compute_subnetwork" "protected1" {
  name = "${var.env}-protected-subnet-1"
  region = var.region
  network = google_compute_network.vpc.id
  ip_cidr_range = cidrsubnet(var.vpc_cidr_range, 8, 2)
}

########################################################
# NAT
########################################################

resource "google_compute_router" "nat_router" {
  name = "${var.env}-nat-router"
  network = google_compute_network.vpc.id
  region = var.region
}

resource "google_compute_router_nat" "nat" {
  name = "${var.env}-nat"
  region = var.region
  router = google_compute_router.nat_router.name
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.protected1.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

########################################################
# Firewall
########################################################

# GCPは全サブネットがデフォルトでインターネットに接続できるようになっているので、ファイアウォールルールを追加すればパブリックサブネットになる
# このルールはタグ"web"を持つリソースに適用される
resource "google_compute_firewall" "this" {
  name = "allow-http-https"
  allow {
    ports    = ["80", "443"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

########################################################
# Output
########################################################

output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "public_subnets" {
  value = [google_compute_subnetwork.public1.id]
}

output "private_subnets" {
  value = [google_compute_subnetwork.private1.id]
}

output "protected_subnets" {
  value = [google_compute_subnetwork.protected1.id]
}