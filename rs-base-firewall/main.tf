resource "google_compute_firewall" "rs-bastion-direct" {
  name    = "${var.rule_prefix}rs-bastion-direct"
  network = var.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "3389", "5985-5986"]
  }

  source_ranges = var.rax_ranges
  disabled = var.disabled
}


resource "google_compute_firewall" "rs-bastion-ext" {
  name    = "${var.rule_prefix}rs-bastion-ext"
  network = var.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "3389", "5985-5986"]
  }

  source_ranges = var.rax_ranges

  target_tags = ["rs-bastion"]
  disabled = var.disabled
}


resource "google_compute_firewall" "rs-bastion-int" {
  name    = "${var.rule_prefix}rs-bastion-int"
  network = var.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "3389", "5985-5986"]
  }

  source_tags = ["rs-bastion"]
  disabled = var.disabled
}

resource "google_compute_firewall" "rs-bastion-iap" {
  name    = "${var.rule_prefix}rs-bastion-iap"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "3389", "5985-5986"]
  }

  source_ranges = ["35.235.240.0/20"]
  disabled = var.disabled
}