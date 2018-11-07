<!-- -*-markdown-*- -->
# stevedore

[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Travis-CI Build Status](https://travis-ci.org/richfitz/stevedore.svg?branch=master)](https://travis-ci.org/richfitz/stevedore)
[![codecov.io](https://codecov.io/github/richfitz/stevedore/coverage.svg?branch=master)](https://codecov.io/github/richfitz/stevedore?branch=master)

A docker client for R



![hello world example of stevedore](https://raw.githubusercontent.com/richfitz/stevedore/master/demo/hello.gif)


## Background

**What is docker?** Docker is a platform for "containerising" applications - running them in isolation from one another, removing differences of how they are built, what they are built from, and what resources they need (disk, ports, users, etc).  It's similar conceptually to virtualisation, but much more light weight.

**Why would one want to use docker from R?** Whenever you need to control external processes from an R script or package, it might be useful to interact with this process from in containers using docker

- *package authors* might want a clean environment to test their code (similar to travis)
- *a developer using an external database* in a package or in an analysis script might use docker to create disposable copies of the database, or to create a copy isolated from their production database
- *a researcher* might use docker to do a reproducible analysis, or preserve the artefacts that were created along with a copy of the environment that created them

These are discussed further in the [applications vignette](https://richfitz.github.io/stevedore/articles/examples.html)


## Usage

The main function in the package is `docker_client`; this will construct an object with which we can talk with the docker server.


```r
docker <- stevedore::docker_client()
docker
```

```
## <docker_client>
##   config: Manage docker swarm configs
##   container: Work with docker containers
##   image: Work with docker images
##   network: Work with docker networks
##   node: Manage docker swarm nodes
##   plugin: Work with docker plugins
##   secret: Manage docker swarm secrets
##   service: Work with docker services
##   swarm: Manage the docker swarm
##   task: Work with docker tasks
##   volume: Work with docker volumes
##   types: Methods for building complex docker types
##   api_version()
##   connection_info()
##   cp(src, dest)
##   df()
##   events(since = NULL, until = NULL, filters = NULL)
##   help(help_type = getOption("help_type"))
##   info()
##   login(username = NULL, password = NULL, email = NULL,
##       serveraddress = NULL)
##   ping()
##   request(verb, path, query = NULL, body = NULL, headers = NULL,
##       stream = NULL)
##   version()
```

With this you can run containers:


```r
docker$container$run("alpine:3.1", c("echo", "hello world"))
```

```
## Unable to find image 'alpine:3.1' locally
```

```
## Pulling from library/alpine 3.1
## Pulling fs layer 54b8a1828d4a
## 54b8a1828d4a: Downloading 23.6 kB/2.3 MB 1%
## 54b8a1828d4a: Downloading 195.44 kB/2.3 MB 8%
## 54b8a1828d4a: Downloading 572.14 kB/2.3 MB 25%
## 54b8a1828d4a: Downloading 989.93 kB/2.3 MB 43%
## 54b8a1828d4a: Downloading 1.51 MB/2.3 MB 66%
## 54b8a1828d4a: Downloading 1.83 MB/2.3 MB 80%
## 54b8a1828d4a: Downloading 2.03 MB/2.3 MB 88%
## Verifying Checksum 54b8a1828d4a
## Download complete 54b8a1828d4a
## 54b8a1828d4a: Extracting 32.77 kB/2.3 MB 1%
## 54b8a1828d4a: Extracting 327.68 kB/2.3 MB 14%
## 54b8a1828d4a: Extracting 1.41 MB/2.3 MB 61%
## 54b8a1828d4a: Extracting 2.3 MB/2.3 MB 100%
## Pull complete 54b8a1828d4a
## Digest: sha256:2f9dfa6adf602d3d7379f11f3d4fd0b7b4d1c526616ee7c0fd5e553a72e4bf79
## Status: Downloaded newer image for alpine:3.1
## O> hello world
```

```
## <docker_run_output>
##   $container:
##     <docker_container>
##       id: 696acebaecf4ffae26c017ec46c108b85ca25c0b67454630b4803c8aca9e8419
##       name: wizardly_franklin
##
##   $logs:
##     O> hello world
```

Or run containers in the background


```r
docker$container$run("bfirsh/reticulate-splines", detach = TRUE)
```

```
## <docker_container>
##   commit(repo = NULL, tag = NULL, author = NULL, changes = NULL,
##       comment = NULL, pause = NULL, hostname = NULL, domainname = NULL,
##       user = NULL, attach_stdin = NULL, attach_stdout = NULL,
##       attach_stderr = NULL, exposed_ports = NULL, tty = NULL,
##       open_stdin = NULL, stdin_once = NULL, env = NULL, cmd = NULL,
##       healthcheck = NULL, args_escaped = NULL, image = NULL,
##       volumes = NULL, working_dir = NULL, entrypoint = NULL,
##       network_disabled = NULL, mac_address = NULL, on_build = NULL,
##       labels = NULL, stop_signal = NULL, stop_timeout = NULL,
##       shell = NULL)
##   cp_in(src, dest)
##   cp_out(src, dest)
##   diff()
##   exec(cmd, stdin = NULL, stdout = TRUE, stderr = TRUE,
##       detach_keys = NULL, tty = NULL, env = NULL, privileged = NULL,
##       user = NULL, detach = FALSE, stream = stdout())
##   exec_create(cmd, stdin = NULL, stdout = TRUE, stderr = TRUE,
##       detach_keys = NULL, tty = NULL, env = NULL, privileged = NULL,
##       user = NULL)
##   export()
##   get_archive(path, dest)
##   help(help_type = getOption("help_type"))
##   id()
##   image()
##   inspect(reload = TRUE)
##   kill(signal = NULL)
##   labels(reload = TRUE)
##   logs(follow = NULL, stdout = TRUE, stderr = TRUE, since = NULL,
##       timestamps = NULL, tail = NULL, stream = stdout())
##   name()
##   path_stat(path)
##   pause()
##   ports(reload = TRUE)
##   put_archive(src, path, no_overwrite_dir_non_dir = NULL)
##   reload()
##   remove(delete_volumes = NULL, force = NULL, link = NULL)
##   rename(name)
##   resize(h = NULL, w = NULL)
##   restart(t = NULL)
##   start(detach_keys = NULL)
##   stats()
##   status(reload = TRUE)
##   stop(t = NULL)
##   top(ps_args = NULL)
##   unpause()
##   update(cpu_shares = NULL, memory = NULL, cgroup_parent = NULL,
##       blkio_weight = NULL, blkio_weight_device = NULL,
##       blkio_device_read_bps = NULL, blkio_device_write_bps = NULL,
##       blkio_device_read_iops = NULL, blkio_device_write_iops = NULL,
##       cpu_period = NULL, cpu_quota = NULL, cpu_realtime_period = NULL,
##       cpu_realtime_runtime = NULL, cpuset_cpus = NULL,
##       cpuset_mems = NULL, devices = NULL, device_cgroup_rules = NULL,
##       disk_quota = NULL, kernel_memory = NULL,
##       memory_reservation = NULL, memory_swap = NULL,
##       memory_swappiness = NULL, nano_cpus = NULL,
##       oom_kill_disable = NULL, pids_limit = NULL, ulimits = NULL,
##       cpu_count = NULL, cpu_percent = NULL, io_maximum_iops = NULL,
##       io_maximum_bandwidth = NULL, restart_policy = NULL)
##   wait()
```

You can manage containers


```r
docker$container$list()
```

```
##                                                                 id
## 1 6320140ceb34645e43dfcfdb923afdb23a3a55e5519045f642f847fa05a893d3
##       names
## 1 kind_bell
##                                                                     image
## 1 sha256:b1666055931f332541bda7c425e624764de96c85177a61a0b49238a42b80b7f9
##                                                                  image_id
## 1 sha256:b1666055931f332541bda7c425e624764de96c85177a61a0b49238a42b80b7f9
##                 command    created        ports size_rw size_root_fs
## 1 /usr/local/bin/run.sh 1534489839 characte....      NA           NA
##   labels   state                status host_config network_settings
## 1        running Up Less than a second     default     list(bri....
##         mounts      name
## 1 characte.... kind_bell
```

```r
id <- docker$container$list(limit = 1L)$id
container <- docker$container$get(id)
container
```

```
## <docker_container>
##   commit(repo = NULL, tag = NULL, author = NULL, changes = NULL,
##       comment = NULL, pause = NULL, hostname = NULL, domainname = NULL,
##       user = NULL, attach_stdin = NULL, attach_stdout = NULL,
##       attach_stderr = NULL, exposed_ports = NULL, tty = NULL,
##       open_stdin = NULL, stdin_once = NULL, env = NULL, cmd = NULL,
##       healthcheck = NULL, args_escaped = NULL, image = NULL,
##       volumes = NULL, working_dir = NULL, entrypoint = NULL,
##       network_disabled = NULL, mac_address = NULL, on_build = NULL,
##       labels = NULL, stop_signal = NULL, stop_timeout = NULL,
##       shell = NULL)
##   cp_in(src, dest)
##   cp_out(src, dest)
##   diff()
##   exec(cmd, stdin = NULL, stdout = TRUE, stderr = TRUE,
##       detach_keys = NULL, tty = NULL, env = NULL, privileged = NULL,
##       user = NULL, detach = FALSE, stream = stdout())
##   exec_create(cmd, stdin = NULL, stdout = TRUE, stderr = TRUE,
##       detach_keys = NULL, tty = NULL, env = NULL, privileged = NULL,
##       user = NULL)
##   export()
##   get_archive(path, dest)
##   help(help_type = getOption("help_type"))
##   id()
##   image()
##   inspect(reload = TRUE)
##   kill(signal = NULL)
##   labels(reload = TRUE)
##   logs(follow = NULL, stdout = TRUE, stderr = TRUE, since = NULL,
##       timestamps = NULL, tail = NULL, stream = stdout())
##   name()
##   path_stat(path)
##   pause()
##   ports(reload = TRUE)
##   put_archive(src, path, no_overwrite_dir_non_dir = NULL)
##   reload()
##   remove(delete_volumes = NULL, force = NULL, link = NULL)
##   rename(name)
##   resize(h = NULL, w = NULL)
##   restart(t = NULL)
##   start(detach_keys = NULL)
##   stats()
##   status(reload = TRUE)
##   stop(t = NULL)
##   top(ps_args = NULL)
##   unpause()
##   update(cpu_shares = NULL, memory = NULL, cgroup_parent = NULL,
##       blkio_weight = NULL, blkio_weight_device = NULL,
##       blkio_device_read_bps = NULL, blkio_device_write_bps = NULL,
##       blkio_device_read_iops = NULL, blkio_device_write_iops = NULL,
##       cpu_period = NULL, cpu_quota = NULL, cpu_realtime_period = NULL,
##       cpu_realtime_runtime = NULL, cpuset_cpus = NULL,
##       cpuset_mems = NULL, devices = NULL, device_cgroup_rules = NULL,
##       disk_quota = NULL, kernel_memory = NULL,
##       memory_reservation = NULL, memory_swap = NULL,
##       memory_swappiness = NULL, nano_cpus = NULL,
##       oom_kill_disable = NULL, pids_limit = NULL, ulimits = NULL,
##       cpu_count = NULL, cpu_percent = NULL, io_maximum_iops = NULL,
##       io_maximum_bandwidth = NULL, restart_policy = NULL)
##   wait()
```

And control containers


```r
container$inspect()$config$image
```

```
## [1] "sha256:b1666055931f332541bda7c425e624764de96c85177a61a0b49238a42b80b7f9"
```

```r
container$logs()
```

```
## O> Reticulating spline 1...
```

```r
container$stop(t = 0)
```

```
## NULL
```

```r
container$remove()
```

```
## NULL
```

And manage images


```r
head(docker$image$list())
```

```
##                                                                        id
## 1 sha256:6f8a01c2945dd97b2049009c75e20f0aa9c1aa54698e17178d2a2227bae1bf6d
## 2 sha256:fa71c69b809a376f6e6b1e1bd2895e703d457c754c93aad46e07e1e6907d9355
## 3 sha256:d02d78cfb867be8de09e9f417113079fdc88b668e7583eeb08416c637a1e4b56
## 4 sha256:ac7af30183dcb8a7457b8da75f34f2fbbeb9fab93c4b9d4ffd854d685788dc34
## 5 sha256:347d8774196233a53060062d39a9bc000fe461be5297ce7404e564511a2b2f1b
## 6 sha256:4e81466b1e0246b3993abe447d1bab9f6499523c9626e5bf8d56a16401064cc9
##                                                                 parent_id
## 1
## 2 sha256:5c2ba59b3cc86f63525abe0e02f69507e1a80a37990bd2108c87c1f363841283
## 3 sha256:2d1afcaacfbda21d659342cc38c103acc8b3ce63ebf4a9c5b728d92a32b47c2a
## 4 sha256:58f4d0fb24ea4cab793352ad333ac1f75fa19c995186e0c7edf4b31dac43781e
## 5 sha256:de8213fe854720122a32faa6b57a582c4d18bb6cc81792d211b3acb9c8598f10
## 6 sha256:03e6108b87ee007e7430f4bc363d039a0397abb702f19f1ca73ae010c831d0b8
##      repo_tags repo_digests    created    size shared_size virtual_size
## 1   alpine:3.1 alpine@s.... 1530886487 5046821          -1      5046821
## 2 richfitz....              1530520055 4148087          -1      4148087
## 3 <none>:<.... <none>@<.... 1530520054 4148087          -1      4148087
## 4 <none>:<.... <none>@<.... 1530520052 4148087          -1      4148087
## 5 <none>:<.... <none>@<.... 1530520051 4148087          -1      4148087
## 6 <none>:<.... <none>@<.... 1530520050 4148087          -1      4148087
##   labels containers
## 1                -1
## 2  0.0.1         -1
## 3  0.0.1         -1
## 4  0.0.1         -1
## 5  0.0.1         -1
## 6  0.0.1         -1
```

Some of these functions have many arguments, but `stevedore` includes help inline:


```r
docker$container$create
```

```
## function(image, cmd = NULL, hostname = NULL, domainname = NULL,
##     user = NULL, attach_stdin = NULL, attach_stdout = NULL,
##     attach_stderr = NULL, ports = NULL, tty = NULL, open_stdin = NULL,
##     stdin_once = NULL, env = NULL, health_check = NULL,
##     args_escaped = NULL, volumes = NULL, working_dir = NULL,
##     entrypoint = NULL, network_disabled = NULL, mac_address = NULL,
##     on_build = NULL, labels = NULL, stop_signal = NULL,
##     stop_timeout = NULL, shell = NULL, host_config = NULL,
##     network = NULL, name = NULL)
## ----------------------------------------------------------------------
## Create a container. Similar to the cli command `docker create` or
##   `docker container create`.
## ----------------------------------------------------------------------
##   image: The name of the image to use when creating the container
##   cmd: Command to run specified as a string or an array of
##         strings.
##   hostname: The hostname to use for the container, as a valid RFC
##         1123 hostname.
##   domainname: The domain name to use for the container.
##   user: The user that commands are run as inside the container.
##   attach_stdin: Whether to attach to `stdin`.
##   attach_stdout: Whether to attach to `stdout`.
##   attach_stderr: Whether to attach to `stderr`.
##   ports: A character vector of port mappings between the container
##         and host, in (1) the form `<host>:<container>` (e.g.,
##         `10080:80` to map the container's port 80 to the host's
##         port 10080), (2) the form `<port>` as shorthand for
##         `<port>:<port>`, or (3) a single logical value `TRUE`
##         indicating to map all container ports to random available
##         ports on the host.  You can use the `$ports()` method in
##         the `?docker_container` object to query the port mapping
##         of a running container.
##   tty: Attach standard streams to a TTY, including `stdin` if it
##         is not closed.
##   open_stdin: Open `stdin`
##   stdin_once: Close `stdin` after one attached client disconnects
##   env: A list of environment variables to set inside the container
##         in the form `["VAR=value", ...]`. A variable without `=`
##         is removed from the environment, rather than to have an
##         empty value.
##   health_check: A test to perform to check that the container is
##         healthy. Construct with `$types$health_config()`
##   args_escaped: Command is already escaped (Windows only)
##   volumes: A character vector of mappings of mount points on the
##         host (or in volumes) to paths on the container.  Each
##         element must be of the form
##         `<path_host>:<path_container>`, possibly followed by `:ro`
##         for read-only mappings (i.e., the same syntax as the
##         docker command line client).
##         `?docker_volume` objects have a `$map` method to help with
##         generating these paths for volume mappings.
##   working_dir: The working directory for commands to run in.
##   entrypoint: The entry point for the container as a string or an
##         array of strings.
##
##         If the array consists of exactly one empty string (`[""]`)
##         then the entry point is reset to system default (i.e., the
##         entry point used by docker when there is no `ENTRYPOINT`
##         instruction in the `Dockerfile`).
##   network_disabled: Disable networking for the container.
##   mac_address: MAC address of the container.
##   on_build: `ONBUILD` metadata that were defined in the image's
##         `Dockerfile`.
##   labels: User-defined key/value metadata.
##   stop_signal: Signal to stop a container as a string or unsigned
##         integer.
##   stop_timeout: Timeout to stop a container in seconds.
##   shell: Shell for when `RUN`, `CMD`, and `ENTRYPOINT` uses a
##         shell.
##   host_config: Container configuration that depends on the host we
##         are running on
##   network: This container's networking configuration.
##   name: Assign the specified name to the container. Must match
##         `/?[a-zA-Z0-9_-]+`.
```

as well as via an `help()` method on each object (e.g., `docker$help()`, `docker$container$help()`) which will display help for the API version that you are using.

## Approach

Docker publishes a [machine-readable API specification](https://docs.docker.com/engine/api/v1.29).  Rather than manually write wrappers that fit the output docker gives, `stevedore` _generates_ an interface directly from the spefification.  Currently `stevedore` supports docker API versions 1.25 to 1.37 (defaulting to 1.29).

This approach means that the output will be type-stable - there is no inference on what to return based on what the server chooses to return.  With a given API version, the same fields will always be returned.  Some of this information is very rich, for example, for the backgrounded container above:


```r
container$inspect(reload = FALSE)
```

```
## $id
## [1] "6320140ceb34645e43dfcfdb923afdb23a3a55e5519045f642f847fa05a893d3"
##
## $created
## [1] "2018-08-17T07:10:39.9699819Z"
##
## $path
## [1] "/usr/local/bin/run.sh"
##
## $args
## character(0)
##
## $state
## $state$status
## [1] "running"
##
## $state$running
## [1] TRUE
##
## $state$paused
## [1] FALSE
##
## $state$restarting
## [1] FALSE
##
## $state$oom_killed
## [1] FALSE
##
## $state$dead
## [1] FALSE
##
## $state$pid
## [1] 10547
##
## $state$exit_code
## [1] 0
##
## $state$error
## [1] ""
##
## $state$started_at
## [1] "2018-08-17T07:10:40.5257006Z"
##
## $state$finished_at
## [1] "0001-01-01T00:00:00Z"
##
##
## $image
## [1] "sha256:b1666055931f332541bda7c425e624764de96c85177a61a0b49238a42b80b7f9"
##
## $resolv_conf_path
## [1] "/var/lib/docker/containers/6320140ceb34645e43dfcfdb923afdb23a3a55e5519045f642f847fa05a893d3/resolv.conf"
##
## $hostname_path
## [1] "/var/lib/docker/containers/6320140ceb34645e43dfcfdb923afdb23a3a55e5519045f642f847fa05a893d3/hostname"
##
## $hosts_path
## [1] "/var/lib/docker/containers/6320140ceb34645e43dfcfdb923afdb23a3a55e5519045f642f847fa05a893d3/hosts"
##
## $log_path
## [1] "/var/lib/docker/containers/6320140ceb34645e43dfcfdb923afdb23a3a55e5519045f642f847fa05a893d3/6320140ceb34645e43dfcfdb923afdb23a3a55e5519045f642f847fa05a893d3-json.log"
##
## $node
## NULL
##
## $name
## [1] "/kind_bell"
##
## $restart_count
## [1] 0
##
## $driver
## [1] "overlay2"
##
## $mount_label
## [1] ""
##
## $process_label
## [1] ""
##
## $app_armor_profile
## [1] ""
##
## $exec_ids
## [1] NA
##
## $host_config
## $host_config$cpu_shares
## [1] 0
##
## $host_config$memory
## [1] 0
##
## $host_config$cgroup_parent
## [1] ""
##
## $host_config$blkio_weight
## [1] 0
##
## $host_config$blkio_weight_device
## [1] path   weight
## <0 rows> (or 0-length row.names)
##
## $host_config$blkio_device_read_bps
## [1] path rate
## <0 rows> (or 0-length row.names)
##
## $host_config$blkio_device_write_bps
## [1] path rate
## <0 rows> (or 0-length row.names)
##
## $host_config$blkio_device_read_iops
## [1] path rate
## <0 rows> (or 0-length row.names)
##
## $host_config$blkio_device_write_iops
## [1] path rate
## <0 rows> (or 0-length row.names)
##
## $host_config$cpu_period
## [1] 0
##
## $host_config$cpu_quota
## [1] 0
##
## $host_config$cpu_realtime_period
## [1] 0
##
## $host_config$cpu_realtime_runtime
## [1] 0
##
## $host_config$cpuset_cpus
## [1] ""
##
## $host_config$cpuset_mems
## [1] ""
##
## $host_config$devices
## [1] path_on_host       path_in_container  cgroup_permissions
## <0 rows> (or 0-length row.names)
##
## $host_config$device_cgroup_rules
## character(0)
##
## $host_config$disk_quota
## [1] 0
##
## $host_config$kernel_memory
## [1] 0
##
## $host_config$memory_reservation
## [1] 0
##
## $host_config$memory_swap
## [1] 0
##
## $host_config$memory_swappiness
## [1] NA
##
## $host_config$nano_cpus
## [1] NA
##
## $host_config$oom_kill_disable
## [1] FALSE
##
## $host_config$pids_limit
## [1] 0
##
## $host_config$ulimits
## [1] name soft hard
## <0 rows> (or 0-length row.names)
##
## $host_config$cpu_count
## [1] 0
##
## $host_config$cpu_percent
## [1] 0
##
## $host_config$io_maximum_iops
## [1] 0
##
## $host_config$io_maximum_bandwidth
## [1] 0
##
## $host_config$binds
## character(0)
##
## $host_config$container_idfile
## [1] ""
##
## $host_config$log_config
## $host_config$log_config$type
## [1] "json-file"
##
## $host_config$log_config$config
## character(0)
##
##
## $host_config$network_mode
## [1] "default"
##
## $host_config$port_bindings
## NULL
##
## $host_config$restart_policy
## $host_config$restart_policy$name
## [1] ""
##
## $host_config$restart_policy$maximum_retry_count
## [1] 0
##
##
## $host_config$auto_remove
## [1] FALSE
##
## $host_config$volume_driver
## [1] ""
##
## $host_config$volumes_from
## character(0)
##
## $host_config$mounts
## [1] target         source         type           read_only
## [5] consistency    bind_options   volume_options tmpfs_options
## <0 rows> (or 0-length row.names)
##
## $host_config$cap_add
## character(0)
##
## $host_config$cap_drop
## character(0)
##
## $host_config$dns
## character(0)
##
## $host_config$dns_options
## character(0)
##
## $host_config$dns_search
## character(0)
##
## $host_config$extra_hosts
## character(0)
##
## $host_config$group_add
## character(0)
##
## $host_config$ipc_mode
## [1] "shareable"
##
## $host_config$cgroup
## [1] ""
##
## $host_config$links
## character(0)
##
## $host_config$oom_score_adj
## [1] 0
##
## $host_config$pid_mode
## [1] ""
##
## $host_config$privileged
## [1] FALSE
##
## $host_config$publish_all_ports
## [1] FALSE
##
## $host_config$readonly_rootfs
## [1] FALSE
##
## $host_config$security_opt
## character(0)
##
## $host_config$storage_opt
## NULL
##
## $host_config$tmpfs
## NULL
##
## $host_config$uts_mode
## [1] ""
##
## $host_config$userns_mode
## [1] ""
##
## $host_config$shm_size
## [1] 67108864
##
## $host_config$sysctls
## NULL
##
## $host_config$runtime
## [1] "runc"
##
## $host_config$console_size
## [1] 0 0
##
## $host_config$isolation
## [1] ""
##
##
## $graph_driver
## $graph_driver$name
## [1] "overlay2"
##
## $graph_driver$data
##                                                                                                                                                                                                                                                                                                                                                                                          lower_dir
## "/var/lib/docker/overlay2/7a9eec2602e203e010feff25873b999258ece124fce5a49481eca3bf7ee027e9-init/diff:/var/lib/docker/overlay2/77cdc2da69d8f65ded5c4351c5ea3b95aab5e887f30b0345121ae9b44b54af98/diff:/var/lib/docker/overlay2/61797179126c3628eabe9f686d2404e75903024a7c585bf733cba7515d689e9f/diff:/var/lib/docker/overlay2/1d21be0bce813352b9211279ad029a021d46e8b05efb027861c146bc65d5f87b/diff"
##                                                                                                                                                                                                                                                                                                                                                                                         merged_dir
##                                                                                                                                                                                                                                                                                                 "/var/lib/docker/overlay2/7a9eec2602e203e010feff25873b999258ece124fce5a49481eca3bf7ee027e9/merged"
##                                                                                                                                                                                                                                                                                                                                                                                          upper_dir
##                                                                                                                                                                                                                                                                                                   "/var/lib/docker/overlay2/7a9eec2602e203e010feff25873b999258ece124fce5a49481eca3bf7ee027e9/diff"
##                                                                                                                                                                                                                                                                                                                                                                                           work_dir
##                                                                                                                                                                                                                                                                                                   "/var/lib/docker/overlay2/7a9eec2602e203e010feff25873b999258ece124fce5a49481eca3bf7ee027e9/work"
##
##
## $size_rw
## [1] NA
##
## $size_root_fs
## [1] NA
##
## $mounts
## [1] type        name        source      destination driver      mode
## [7] rw          propagation
## <0 rows> (or 0-length row.names)
##
## $config
## $config$hostname
## [1] "6320140ceb34"
##
## $config$domainname
## [1] ""
##
## $config$user
## [1] ""
##
## $config$attach_stdin
## [1] FALSE
##
## $config$attach_stdout
## [1] FALSE
##
## $config$attach_stderr
## [1] FALSE
##
## $config$exposed_ports
## NULL
##
## $config$tty
## [1] FALSE
##
## $config$open_stdin
## [1] FALSE
##
## $config$stdin_once
## [1] FALSE
##
## $config$env
## [1] "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
##
## $config$cmd
## [1] "/usr/local/bin/run.sh"
##
## $config$healthcheck
## NULL
##
## $config$args_escaped
## [1] TRUE
##
## $config$image
## [1] "sha256:b1666055931f332541bda7c425e624764de96c85177a61a0b49238a42b80b7f9"
##
## $config$volumes
## NULL
##
## $config$working_dir
## [1] ""
##
## $config$entrypoint
## character(0)
##
## $config$network_disabled
## [1] NA
##
## $config$mac_address
## [1] NA
##
## $config$on_build
## character(0)
##
## $config$labels
## character(0)
##
## $config$stop_signal
## [1] NA
##
## $config$stop_timeout
## [1] NA
##
## $config$shell
## character(0)
##
##
## $network_settings
## $network_settings$bridge
## [1] ""
##
## $network_settings$gateway
## [1] "172.17.0.1"
##
## $network_settings$address
## [1] NA
##
## $network_settings$ip_prefix_len
## [1] 16
##
## $network_settings$mac_address
## [1] "02:42:ac:11:00:02"
##
## $network_settings$port_mapping
## [1] NA
##
## $network_settings$ports
## list()
```


## Windows support

The support for windows is not as comprehensive as for other platforms (but I'm not sure how common using docker is on windows yet).  The reason for this is that [`curl`](https://cran.r-project.org/package=curl) (and the underlying `libcurl` library) do not support communicating over "named pipes" which is how docker works on windows.  There is partial support for this in the package using the package [`httppipe`](http://github.com/richfitz/httppipe).

### Installation

You will need a python installation (both python2 and python3 should work), along with [`reticulate`](https://cran.r-project.org/package=reticulate).  Whatever python you use needs to be able to find the python packages `requests`, `six` and `pipywin32`.  You can test if everything is working by running

```
stevedore:::httppipe_available(verbose = TRUE)
```

which will return `TRUE` if everything is OK, and otherwise print some information about errors loading the package.  In the case of error consult the reticulate documentation (`vignette("versions", package = "reticulate")` will be especially useful).  Improvements to installation documentation and process are welcome!

### Limitations

The primary limitation of the `httppipe` interface is that streaming connections are not supported.  This affects the following methods

* container logs with `follow = TRUE`: completely unsupported
* container run - works completely with `detach = TRUE`, and with `detach = FALSE` works but prints output only at the end (not streaming output)
* image build - works but information printed only at end of build rather than streaming
* image pull - works but information printed only at end of pull
* exec start - works but information printed only at end of execution


## Roadmap

There is still a lot of work to do here:

* windows support needs work (see above for details)
* endpoints that require http hijacking are not fully supported (i.e., attach) but the foundations are there to support this - stdin is likely to be a major hassle though and I'm not sure if it's possible from within R's REPL.  The websockets approach might be better but stands very little chance of working on windows.


## Development and testing

See the [development guide](development.md) if you want to get started developing `stevedore` - it provides pointers to the core objects.


## Installation

Currently, `stevedore` is not on CRAN, but can be installed directly from GitHub using devtools

```r
devtools::install_github("richfitz/stevedore", upgrade_dependencies = FALSE)
```

On windows you will also need

```r
devtools::install_github("richfitz/httppipe", upgrade_dependencies = FALSE)
```

(see [above](#windows-support)).

Once installed, find out if everything is set up to use docker by running


```r
stevedore::docker_available()
```

```
## [1] TRUE
```


## Licence

MIT © [Rich FitzJohn](https://github.com/richfitz).

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
