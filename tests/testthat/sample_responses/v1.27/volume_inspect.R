## version: 1.27
## method: get
## path: /volumes/{name}
## code: 200
## response: {"Name":"tardis","Driver":"custom","Mountpoint":"/var/lib/docker/volumes/tardis","Status":{"hello":"world"},"Labels":{"com.example.some-label":"some-value","com.example.some-other-label":"some-other-value"},"Scope":"local"}
list(name = "tardis",
     driver = "custom",
     mountpoint = "/var/lib/docker/volumes/tardis",
     status = list(hello = "world"),
     labels = c("com.example.some-label" = "some-value",
                "com.example.some-other-label" = "some-other-value"),
     scope = "local",
     options = NULL,
     usage_data = NULL)
