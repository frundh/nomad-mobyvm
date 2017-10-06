job "traefik" {
  region = "global"
  datacenters = ["dc1"]

  type = "service"

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "traefik" {
    count = 1

    task "traefik" {
      
      driver = "docker"

      config {
        image = "traefik:1.3.3"
        args  = ["--web", "--consulcatalog", "--consulcatalog.endpoint=${attr.unique.network.ip-address}:8500", "--consulcatalog.constraints=tag==api"]

        port_map {
          proxy  = 80
          web    = 8080
        }
      }

      service {       
        name = "traefik"
        port = "proxy"

        check {
          type     = "http"
          port     = "web"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }      

      resources {
        cpu    = 100
        memory = 256

        network {
          port "proxy"  { static = "8080" }
          port "web"    { static = "8081" }
        }
      }
    }
  }
}