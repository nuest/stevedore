## ---
## title: "Examples and use-cases"
## author: "Rich FitzJohn"
## date: "`r Sys.Date()`"
## output: rmarkdown::html_vignette
## vignette: >
##   %\VignetteIndexEntry{Examples and use-cases}
##   %\VignetteEngine{knitr::rmarkdown}
##   %\VignetteEncoding{UTF-8}
## ---

##+ include = FALSE
knitr::opts_chunk$set(error = FALSE)
lang_output <- function(x, lang) {
  cat(c(sprintf("```%s", lang), x, "```"), sep="\n")
}
c_output <- function(x) lang_output(x, "cc")
r_output <- function(x) lang_output(x, "r")
plain_output <- function(x) lang_output(x, "plain")

## ## Using a database in testing

## This example requires the `redux` package, which is available on
## CRAN and can be installed with
##
## ```r
## install.packages("redux")
## ```
docker <- stevedore::docker_client()

redis <- docker$container$run("redis", name = "redis", ports = "6379",
                              detach = TRUE, rm = TRUE)

## We now have a Redis server running on `r redis$ports()$host_port`
redis$ports()

## Make a connection to the Redis server:
con <- redux::hiredis(port = redis$ports()$host_port)

## and we can communicate with the Redis server:
con$PING()

## Because this is a brand new container we can write data without
## worrying about clobbering data that already exists:
con$SET("key", "hello redis")
con$GET("key")

## And we can get a fresh copy of Redis by simply starting a new copy
## of redis
redis$kill()
redis <- docker$container$run("redis", name = "redis", ports = "6379",
                              detach = TRUE, rm = TRUE)
con <- redux::hiredis(port = redis$ports()$host_port)
con$KEYS("*")

redis$kill()

## The same approach works for other database that might be large or
## awkward to install, such as Postgres or MySQL.

## ## Testing shiny apps

## (this section is not actually run because doing anything with it
## requires looking in a web browser)

## The rocker project has a shiny container that provides an easy to
## use version of the shiny server.  If we have a directory `app`
## that contains a shiny application we can map this with:
##+ eval = FALSE
volumes <- sprintf("%s:%s", normalizePath("app"), "/srv/shiny-server/")

## (see the [shiny docker image
## documentation](https://hub.docker.com/r/rocker/shiny) for the
## destination path.

## We can start this with
##+ eval = FALSE
shiny <- docker$container$run("rocker/shiny", name = "shiny", ports = "3838",
                              volumes = volumes,
                              detach = TRUE, rm = TRUE)

## In an interactive session, you can visit the shiny server:
##+ eval = FALSE
browseURL(sprintf("http://localhost:%s", shiny$ports()$host_port))

## ## Package testing

## You can build an image that contains all the bits required to test
## your package and then run tests using that image.  This ensures
## that you're running in a totally clean environment (and that you
## really know what all the dependencies of your package are)
##+ include = FALSE
local({
  p <- system.file("images/tester", package = "stevedore", mustWork = TRUE)
  stopifnot(file.copy(p, ".", recursive = TRUE))
})

## For this we have a Dockerfile, which contains
##+ echo = FALSE, results = "asis"
plain_output(readLines("tester/Dockerfile"))

## And the script `tester.sh` (copied into the docker image above)
## which contains:
lang_output(readLines("tester/tester.sh"), "shell")

img <- docker$image$build("tester", tag = "richfitz/tester")

## With this image we can then test packages off github:
invisible(docker$container$run(img, "https://github.com/richfitz/ids",
                               rm = TRUE, stream = stdout()))

##+ echo = FALSE
unlink("tester", recursive = TRUE)

## (I have cheated here and put all of the dependencies of `ids` into
## the docker image via the Dockerfile).

## The same approach would work by mounting the package source
## directory into the container and passing the path (within the
## container) to `$run()`.
