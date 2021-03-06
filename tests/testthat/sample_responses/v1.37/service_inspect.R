## version: 1.37
## method: get
## path: /services/{id}
## code: 200
## response: {"ID":"9mnpnzenvg8p8tdbtq4wvbkcz","Version":{"Index":19},"CreatedAt":"2016-06-07T21:05:51.880065305Z","UpdatedAt":"2016-06-07T21:07:29.962229872Z","Spec":{"Name":"hopeful_cori","TaskTemplate":{"ContainerSpec":{"Image":"redis"},"Resources":{"Limits":{},"Reservations":{}},"RestartPolicy":{"Condition":"any","MaxAttempts":0},"Placement":{},"ForceUpdate":0},"Mode":{"Replicated":{"Replicas":1}},"UpdateConfig":{"Parallelism":1,"Delay":1000000000,"FailureAction":"pause","Monitor":15000000000,"MaxFailureRatio":0.15},"RollbackConfig":{"Parallelism":1,"Delay":1000000000,"FailureAction":"pause","Monitor":15000000000,"MaxFailureRatio":0.15},"EndpointSpec":{"Mode":"vip","Ports":[{"Protocol":"tcp","TargetPort":6379,"PublishedPort":30001}]}},"Endpoint":{"Spec":{"Mode":"vip","Ports":[{"Protocol":"tcp","TargetPort":6379,"PublishedPort":30001}]},"Ports":[{"Protocol":"tcp","TargetPort":6379,"PublishedPort":30001}],"VirtualIPs":[{"NetworkID":"4qvuz4ko70xaltuqbt8956gd1","Addr":"10.255.0.2/16"},{"NetworkID":"4qvuz4ko70xaltuqbt8956gd1","Addr":"10.255.0.3/16"}]}}
NULL

data_frame <- function(...) {
  data.frame(..., stringsAsFactors = FALSE)
}

ports <- data_frame(name = NA_character_,
                    protocol = "tcp",
                    target_port = 6379,
                    published_port = 30001,
                    publish_mode = NA_character_)
networks <- data_frame(target = character(),
                       aliases = I(list()))

container_spec <- list(
  image = "redis",
  labels = NULL,
  command = character(0),
  args = character(0),
  hostname = NA_character_,
  env = character(0),
  dir = NA_character_,
  user = NA_character_,
  groups = character(0),
  privileges = NULL,
  tty = NA,
  open_stdin = NA,
  read_only = NA,
  mounts = data_frame(
    target = character(0),
    source = character(0),
    type = character(0),
    read_only = logical(0),
    consistency = character(0),
    bind_options = I(list()),
    volume_options = I(list()),
    tmpfs_options = I(list())),
  stop_signal = NA_character_,
  stop_grace_period = NA_integer_,
  health_check = NULL,
  hosts = character(0),
  dns_config = NULL,
  secrets = data_frame(
    file = I(list()),
    secret_id = character(0),
    secret_name = character(0)),
  configs = data_frame(
    file = I(list()),
    config_id = character(0),
    config_name = character(0)),
  isolation = NA_character_)

task_template <- list(
  plugin_spec = NULL,
  container_spec = container_spec,
  resources = list(
    limits = list(
      nano_cpus = NA_integer_,
      memory_bytes = NA_integer_,
      generic_resources = data_frame(
        named_resource_spec = I(list()),
        discrete_resource_spec = I(list()))),
    reservation = NULL),
  restart_policy = list(
    condition = "any",
    delay = NA_integer_,
    max_attempts = 0L,
    window = NA_integer_),
  placement = list(
    constraints = character(0),
    preferences = data_frame(spread = I(list())),
    platforms = data_frame(architecture = character(0),
                           os = character(0))),
  force_update = 0L,
  runtime = NA_character_,
  networks = networks,
  log_driver = NULL)

spec <- list(
  name = "hopeful_cori",
  labels = NULL,
  task_template = task_template,
  mode = list(
    replicated = list(replicas = 1L),
    global = NULL),
  update_config = list(
    parallelism = 1L,
    delay = 1000000000L,
    failure_action = "pause",
    monitor = 1.5e+10,
    max_failure_ratio = 0.15,
    order = NA_character_),
  rollback_config = list(
    parallelism = 1L,
    delay = 1000000000L,
    failure_action = "pause",
    monitor = 1.5e+10,
    max_failure_ratio = 0.15,
    order = NA_character_),
  networks = networks,
  endpoint_spec = list(
    mode = "vip",
    ports = ports))

endpoint <- list(
  spec = list(
    mode = "vip",
    ports = ports),
  ports = ports,
  virtual_ips = data_frame(
    network_id = c("4qvuz4ko70xaltuqbt8956gd1", "4qvuz4ko70xaltuqbt8956gd1"),
    addr = c("10.255.0.2/16", "10.255.0.3/16")))

list(
  id = "9mnpnzenvg8p8tdbtq4wvbkcz",
  version = list(index = 19L),
  created_at = "2016-06-07T21:05:51.880065305Z",
  updated_at = "2016-06-07T21:07:29.962229872Z",
  spec = spec,
  endpoint = endpoint,
  update_status = NULL)
