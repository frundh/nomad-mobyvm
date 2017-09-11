job "hello-world" {
  region = "global"
  datacenters = ["dc1"]

  type = "service"

  # Specify this job to have rolling updates, two-at-a-time, with
  # 30 second intervals.
  update {
    stagger      = "30s"
    max_parallel = 1
  }

  # A group defines a series of tasks that should be co-located
  # on the same client (host). All tasks within a group will be
  # placed on the same host.
  group "web" {
    # Specify the number of these tasks we want.
    count = 2

    # Create an individual task (unit of work). This particular
    # task utilizes a Docker container to front a web application.
    task "app" {
      
      driver = "docker"

      config {
        image = "tutum/hello-world"

        port_map {
          http = 80
        }
      }

      # The service block tells Nomad how to register this service
      # with Consul for service discovery and monitoring.
      service {
        # This tells Consul to monitor the service on the port
        # labled "http". Since Nomad allocates high dynamic port
        # numbers, we use labels to refer to them.
        name = "hello-world"
        port = "http"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      # Specify the maximum resources required to run the job,
      # include CPU, memory, and bandwidth.
      resources {
        network {
          port "http" {}
        }
      }
    }
  }
}