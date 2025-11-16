
resource "google_compute_network" "vpc" {
  name                    = "stc-d2-vpc"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet" {
  name          = "stc-d2-subnet"
  ip_cidr_range = "10.110.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}
resource "google_compute_firewall" "egress" {
  name    = "stc-d2-egress"
  network = google_compute_network.vpc.name
  direction = "EGRESS"
  allow { protocol = "tcp"; ports = ["443"] }
  destination_ranges = ["0.0.0.0/0"]
}
resource "google_compute_instance" "vm" {
  name         = "stc-d2-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  boot_disk { initialize_params { image = "debian-cloud/debian-12" } }
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    # No public IP by default
  }
  metadata = {
    enable-oslogin = "TRUE"
    block-project-ssh-keys = "TRUE"
  }
  tags = ["secure-egress"]
}
