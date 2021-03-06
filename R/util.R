`%||%` <- function(a, b) {
  if (is.null(a)) b else a
}


`%&&%` <- function(a, b) {
  if (is.null(a)) a else b
}


vlapply <- function(X, FUN, ...) {
  vapply(X, FUN, logical(1), ...)
}


viapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  ## Because we might bump into things like large image sizes that are
  ## essentially integers but overflow what R can store as integers
  ## (2^31 - 1) we need to be careful when requesting integers.  This
  ## adds a fair bit of logic but should handle things somewhat
  ## gracefully:
  ##
  ## * If everything is integer, return that
  ## * If everything is _representable_ as integer, coerce to integer
  ##   and return that (this is necessary because fromJSON may convert
  ##   6-digit integers to numeric)
  ## * If we would overflow, coerce to numeric because for all intents
  ##   that's usable in R
  dat <- lapply(X, FUN, ...)
  if (!USE.NAMES) {
    names(dat) <- NULL
  }
  is_integer <- vlapply(dat, is.integer)
  if (all(is_integer)) {
    vapply(dat, "[[", integer(1), 1L)
  } else {
    ## NOTE: super strict here, but I think this holds right up to max
    ## double for text->numeric types
    is_integer_like <- vnapply(dat, `%%`, 1) == 0
    is_in_integer_range <- vnapply(dat, abs) < .Machine$integer.max
    if (!all(is_integer_like)) {
      stop("Result not integer-like")
    }
    if (all(is_in_integer_range)) {
      vapply(dat, as.integer, integer(1))
    } else {
      vnapply(dat, "[[", 1L)
    }
  }
}


vnapply <- function(X, FUN, ...) {
  vapply(X, FUN, numeric(1), ...)
}


vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}


## Version of vapply that will cope with integer overflow
vapply2 <- function(X, FUN, FUN.VALUE, ...) {
  if (is.integer(FUN.VALUE) && length(FUN.VALUE) == 1L) {
    viapply(X, FUN, ...)
  } else {
    vapply(X, FUN, FUN.VALUE, ...)
  }
}


substr_len <- function(x, start, len) {
  substr(x, start, start + len - 1L)
}


as_na <- function(x) {
  x[] <- NA
  x
}


pick <- function(x, el, missing) {
  if (el %in% names(x)) {
    x[[el]] %||% missing
  } else {
    missing
  }
}


set_attributes <- function(x, attr) {
  for (i in names(attr)) {
    attr(x, i) <- attr[[i]]
  }
  x
}


download_file <- function(url, dest, quiet = FALSE) {
  if (!file.exists(dest)) {
    tmp <- tempfile("stevedore_download_")
    on.exit(unlink(tmp))
    curl::curl_download(url, tmp, quiet = quiet, mode = "wb")
    file.copy(tmp, dest)
  }
  dest
}


RE_PASCAL_START <- local({
  special <- c("CA", "CPU", "DNS", "GID", "ID", "IO", "IP", "IPAM",
               "OOM", "OS", "PID", "RW", "SELinux", "TLS", "TTY",
               "UID", "URL", "UTS")
  sprintf("^([A-Z]|%s)", paste(special, collapse = "|"))
})


## TODO: this is actually a major timesink (up to 40% of total time
## building the docker client - 0.5s), so we cache result of this in
## the pascal_to_snake_cached and use that wherever possible.
pascal_to_snake <- function(x) {
  len <- attr(regexpr(RE_PASCAL_START, x), "match.length")
  i <- len > 0L
  if (any(i)) {
    x[i] <- paste0(tolower(substr(x[i], 1L, len[i])),
                   substr(x[i], len[i] + 1L, nchar(x[i])))
  }
  camel_to_snake(x)
}


pascal_to_snake_cached <- function(x) {
  nms <- .stevedore$names
  ret <- nms[, "to"][match(x, nms[, "from"])]
  i <- is.na(ret)
  if (any(i)) {
    from <- x[i]
    ret[i] <- to <- pascal_to_snake(from)
    .stevedore$names <- rbind(nms, cbind(from, to, deparse.level = 0))
  }
  ret
}


pascal_to_snake_cache_reset <- function() {
  .stevedore$names <- as.matrix(
    utils::read.csv(stevedore_file("spec/names.csv"), stringsAsFactors = FALSE))
}


snake_to_pascal <- function(x) {
  x <- snake_to_camel(x)
  paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
}


camel_to_snake <- function(x) {
  if (length(x) != 1L) {
    return(vcapply(x, camel_to_snake, USE.NAMES = FALSE))
  }
  re <- "(?<=[^A-Z])([A-Z]+)"
  repeat {
    m <- regexec(re, x, perl = TRUE)[[1]]
    i <- m[[1]]
    j <- i + attr(m, "match.length")[[1]] - 1L
    if (i > 0) {
      x <- sub(re, paste0("_", tolower(substr(x, i, j))), x, perl = TRUE)
    } else {
      break
    }
  }
  x
}


snake_to_camel <- function(x) {
  if (length(x) != 1L) {
    return(vcapply(x, snake_to_camel, USE.NAMES = FALSE))
  }
  re <- "_([a-z])"
  repeat {
    m <- regexec(re, x, perl = TRUE)[[1]][[1]] + 1L
    if (m > 0) {
      x <- sub(re, toupper(substr(x, m, m)), x, perl = TRUE)
    } else {
      break
    }
  }
  x
}


## As above, but for header case (X-Kebab-Case) to snake_case
x_kebab_to_snake <- function(x) {
  sub("^x_", "", gsub("-", "_", tolower(x)))
}


lock_environment <- function(env) {
  for (nm in ls(env)) {
    lockBinding(as.name(nm), env)
  }
  lockEnvironment(env)
  invisible(env)
}


set_names <- function(x, nms) {
  names(x) <- nms
  x
}


from_json <- function(x) {
  jsonlite::fromJSON(x, simplifyVector = FALSE)
}


raw_to_char <- function(bin) {
  ## iconv(readBin(bin, character()), from = "UTF-8", to = "UTF-8")
  rawToChar(bin)
}


raw_to_json <- function(bin) {
  from_json(raw_to_char(bin))
}


as_call <- function(...) {
  as.call(list(...))
}


dollar <- function(...) {
  f <- function(a, b) {
    as_call(quote(`$`), a, b)
  }
  args <- list(...)
  ret <- args[[1]]
  for (i in seq_along(args)[-1L]) {
    ret <- f(ret, args[[i]])
  }
  ret
}


string_starts_with <- function(x, sub) {
  substr(x, 1, nchar(sub)) == sub
}


reset_line <- function(stream, width, newline_if_not_tty = FALSE,
                       is_tty = isatty(stream)) {
  if (is_tty) {
    cat(paste0(c("\r", strrep(" ", width), "\r"), collapse = ""), file = stream)
  } else if (newline_if_not_tty) {
    cat("\n", file = stream)
  }
}


## Previously this did a deparse(args(f)) with a width cutoff, but
## that does not format long arg/default pairs nicely, eventually
## walking off the right edge.  This version will not go past
## options("width") at the cost of being potentially slower (though I
## don't think it's much worse than strwrap).
capture_args <- function(f, name, indent = 4, width = getOption("width"),
                         exdent = 4L) {
  args <- formals(f)

  if (length(args) == 0L) {
    return(sprintf("%s%s()", strrep(" ", indent), name))
  }

  args_default <- vcapply(args, deparse)
  args_str <- sprintf("%s = %s", names(args), args_default)
  args_str[!nzchar(args_default)] <- names(args)[!nzchar(args_default)]
  args_str[[1]] <- sprintf("%s(%s", name, args_str[[1]])
  args_str[[length(args)]] <- paste0(args_str[[length(args)]], ")")

  w <- width - indent - 2L
  ret <- character()
  s <- ""

  for (i in args_str) {
    ns <- nchar(s)
    ni <- nchar(i)
    if (ns == 0) {
      s <- paste0(strrep(" ", indent + if (length(ret) > 0L) exdent else 0L), i)
    } else if (ns + ni + 2 < w) {
      s <- paste(s, i, sep = ", ")
    } else {
      ret <- c(ret, paste0(s, ","))
      s <- paste0(strrep(" ", indent + exdent), i)
    }
  }

  ret <- c(ret, s)

  paste0(trimws(ret, "right"), collapse = "\n")
}


is_directory <- function(x) {
  file.exists(x) & file.info(x, extra_cols = FALSE)$isdir
}


tolower1 <- function(x) {
  paste0(tolower(substr(x, 1, 1)), substr(x, 2, nchar(x)))
}


## The python command looks to split these up a bit; in
## types/containers.py there's a call to split_command which then goes
## through shlex.split(); we'll need to do something similar.
split_command <- function(x) {
  ## Just going to be exceedingly simple here and try to avoid writing
  ## a parser yet:
  if (grepl("[\"']", x)) {
    stop("A proper command splitter has not yet been written")
  }
  strsplit(x, "\\s+")[[1L]]
}


## Previously yaml read in overflowing integers without a warning -
## the currentl version converts to NA_integer_ with a warning - but I
## want a number out of theese; just because the number does not have
## a decimal doesn't mean we don't want it.  Practically this affects
## the examples in the yaml only.
yaml_handlers <- function() {
  list("int" = function(x) {
    nx <- as.numeric(x)
    if (abs(nx) < .Machine$integer.max) {
      nx <- as.integer(nx)
    }
    nx
  })
}


yaml_load_file <- function(path) {
  yaml::yaml.load_file(path, handlers = yaml_handlers())
}


yaml_load <- function(str) {
  yaml::yaml.load(str, handlers = yaml_handlers())
}


has_colour <- function(dest) {
  if (!is.null(dest) && !isatty(dest)) {
    FALSE
  } else {
    crayon::has_color()
  }
}


squote <- function(x) {
  sprintf("'%s'", x)
}


data_frame <- function(...) {
  data.frame(..., stringsAsFactors = FALSE)
}


is_integer_like <- function(x) {
  is.integer(x) ||
    (is.numeric(x) && all(max(abs(as.integer(x) - x)) < 1e-8))
}


sys_which <- function(name) {
  assert_scalar_character(name)
  ret <- Sys.which(name)
  if (!nzchar(ret)) {
    stop(sprintf("Did not find program '%s'", name))
  }
  unname(ret)
}


## From orderly:R/util.R
system3 <- function(command, args, check = FALSE) {
  res <- suppressWarnings(system2(command, args, stdout = TRUE, stderr = TRUE))
  code <- attr(res, "status") %||% 0
  attr(res, "status") <- NULL
  ret <- list(success = code == 0,
              code = code,
              output = res)
  if (check && !ret$success) {
    stop("Command failed: ", paste(ret$output, collapse = "\n"))
  }
  ret
}


is_windows <- function() {
  Sys.info()[["sysname"]] == "Windows"
}


nothing <- function(...) {
  invisible()
}


read_binary <- function(path) {
  readBin(path, raw(), file.size(path))
}


indent <- function(x, n) {
  paste0(strrep(" ", n), x)
}


sprintfn <- function(fmt, args) {
  switch(as.character(length(args)),
         "0" = fmt,
         "1" = sprintf(fmt, args),
         "2" = sprintf(fmt, args[[1]], args[[2]]),
         stop("Not implemented [stevedore bug]"))
}


version_check <- function(v, cmp) {
  v <- numeric_version(v)
  cmp <- numeric_version(cmp)
  (length(cmp) == 1 && cmp == v) ||
    (length(cmp) == 2 && v >= cmp[[1]] && v <= cmp[[2]])
}


version_at_least <- function(v, cmp) {
  is.null(cmp) || numeric_version(v) >= numeric_version(cmp)
}


atomic_types <- function() {
  type <- list("string"  = character(1),
               "number"  = numeric(1),
               "integer" = integer(1),
               "boolean" = logical(1))
  missing <- lapply(type, as_na)
  empty <- lapply(type, "[", 0L)
  validate_scalar <- list(string = assert_scalar_character,
                          number = assert_scalar_numeric,
                          integer = assert_scalar_integer,
                          boolean = assert_scalar_logical)
  validate_vector <- list(string = assert_character,
                          number = assert_numeric,
                          integer = assert_integer,
                          boolean = assert_logical)
  list(names = names(type),
       type = type,
       missing = missing,
       empty = empty,
       validate_scalar = validate_scalar,
       validate_vector = validate_vector)
}


stevedore_file <- function(path) {
  system.file(path, package = "stevedore", mustWork = TRUE)
}


pretty_bytes <- function(bytes) {
  unit <- c("", "k", "M", "G")
  exponent <- min(floor(log(bytes, 1000)), length(unit) - 1)
  sprintf("%s %sB", round(bytes / 1000^exponent, 2), unit[exponent + 1])
}


file_path <- function(a, b) {
  if (a != ".") {
    file.path(a, b)
  } else {
    b
  }
}


base64encode <- function(x, urlsafe = FALSE) {
  ret <- gsub("\n", "", jsonlite::base64_enc(x), fixed = TRUE)
  if (urlsafe) {
    ret <- chartr("+/", "-_", ret)
  }
  ret
}


base64decode <- function(x, urlsafe = FALSE) {
  if (urlsafe) {
    x <- chartr("-_", "+/", x)
  }
  rawToChar(jsonlite::base64_dec(x))
}


new_empty_env <- function() {
  new.env(parent = emptyenv())
}


new_base_env <- function() {
  new.env(parent = baseenv())
}


join_text_list <- function(x) {
  n <- length(x)
  if (n <= 1L) {
    x
  } else {
    sprintf("%s and %s", paste(x[seq_len(n - 1L)], collapse = ", "), x[[n]])
  }
}


## TODO: what does this do out of timezone?
parse_timestamp <- function(timestamp) {
  strptime(timestamp, "%Y-%m-%dT%H:%M:%OS", "GMT")
}


## TODO: consider full prettyunits::vague_dt here?
time_ago <- function(x, now = Sys.time()) {
  ago1 <- function(t) {
    dt <- now - parse_timestamp(t)
    sprintf("%s %s ago", round(dt), attr(dt, "units"))
  }
  vcapply(x, ago1, USE.NAMES = FALSE)
}


cat2 <- function(..., file) {
  if (!is.null(file)) {
    cat(..., file = file)
  }
}


na_drop <- function(x) {
  x[!is.na(x)]
}


## This is _only_ for the 1.xx versions that the docker api uses
version_range <- function(v_min, v_max) {
  min_version <- unclass(numeric_version(v_min))[[c(1, 2)]]
  max_version <- unclass(numeric_version(v_max))[[c(1, 2)]]
  sprintf("1.%d", min_version:max_version)
}


prompt_ask_yes_no <- function(reason) {
  utils::menu(c("no", "yes"), FALSE, title = reason) == 2 # nocov
}


Sys_getenv1 <- function(x) {
  ret <- Sys.getenv(x, NA_character_)
  if (is.na(ret)) NULL else ret
}


Sys_which <- function(x) {
  ret <- unname(Sys.which(x))
  if (!nzchar(ret)) {
    stop(sprintf("Command '%s' not found on PATH", x))
  }
  ret
}


client_output_options <- function(cl) {
  cl$.parent$.api_client$output_options
}


noop <- function(...) {
}


with_connection <- function(path, fn, ...) {
  con <- file(path, ...)
  on.exit(close(con))
  fn(con)
}
