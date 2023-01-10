locals {
  private_subnet_range = "10.20.20.0/24"
  public_subnet_range  = "10.20.21.0/24"
}

module "test_vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "6.0.0"
  network_name = "vpc-gcp-${local.bcg_org_name}-${local.product_name}-${local.env}"
  project_id   = module.test_project.project_id
  subnets = [
    {
      subnet_name           = "vpc-gcp-${local.bcg_org_name}-${local.product_name}-${local.env}-${local.region}-subnet-private"
      subnet_ip             = local.public_subnet_range
      subnet_region         = local.region
      subnet_private_access = "true"
      description           = "Private subnet"
    },
    {
      subnet_name           = "vpc-gcp-${local.bcg_org_name}-${local.product_name}-${local.env}-${local.region}-subnet-public"
      subnet_ip             = local.private_subnet_range
      subnet_region         = local.region
      subnet_private_access = "false"
      description           = "Public subnet"
    }
  ]
}

resource "google_compute_firewall" "allow_subnet" {
  name    = "fw-gcp-${local.bcg_org_name}-${local.product_name}-${local.env}-allow-ssh-rdp"
  project = module.test_project.project_id
  network = module.test_vpc.network_self_link
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["443", "22", "3389"]
  }
  allow {
    protocol = "udp"
    ports    = ["53"]
  }
  # https://cloud.google.com/iap/docs/using-tcp-forwarding#before_you_begin
  # 35.235.240.0/20 is the netblock needed to forward to the vm instances
  source_ranges = ["35.235.240.0/20"]
  target_tags   = local.vm_target_tags
}

resource "google_compute_router" "router" {
  name    = "rtr-gcp-${local.bcg_org_name}-${local.product_name}-${local.env}"
  project = module.test_project.project_id
  network = module.test_vpc.network_self_link
  region  = local.region
}

resource "google_compute_router_nat" "nat" {
  name                   = "nat-gcp-${local.bcg_org_name}-${local.product_name}-${local.env}"
  project                = module.test_project.project_id
  region                 = google_compute_router.router.region
  router                 = google_compute_router.router.name
  nat_ip_allocate_option = "AUTO_ONLY"
  # allow outboud internet access from the private subnet
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = module.test_vpc.subnets_self_links[0]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}