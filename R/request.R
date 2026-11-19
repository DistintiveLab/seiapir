.sei_req <- function(metodo, caminho, corpo = list(), query = list(),
                     multipart = FALSE, caminho_escapado = FALSE,
                     exigir_token = TRUE, ...) {
  if (exigir_token) .sei_exige_token()
  if (!caminho_escapado) {
    caminho <- paste0(
      vapply(strsplit(caminho, "/")[[1]], utils::URLencode, "", reserved = TRUE),
      collapse = "/"
    )
  }
  url <- paste0(sub("/+$", "", .sei_env$base_api), "/", sub("^/+", "", caminho))
  req <- httr2::request(url)
  if (!is.null(.sei_env$token)) {
    req <- httr2::req_headers(req, token = .sei_env$token)
  }
  if (!is.null(.sei_env$unidade)) {
    req <- httr2::req_headers(req, unidade = as.character(.sei_env$unidade))
  }
  if (length(query)) req <- httr2::req_url_query(req, !!!query)
  if (multipart && length(corpo)) {
    req <- httr2::req_body_multipart(req, !!!corpo)
  } else if (length(corpo)) {
    req <- httr2::req_body_form(req, !!!corpo)
  }
  req <- httr2::req_method(req, metodo)
  req <- httr2::req_error(req, is_error = function(resp) FALSE)
  resp <- httr2::req_perform(req, ...)
  .sei_decodificar(resp)
}

.sei_decodificar <- function(resp) {
  txt <- suppressWarnings(httr2::resp_body_string(resp))
  out <- tryCatch(jsonlite::fromJSON(txt, simplifyVector = FALSE), error = function(e) NULL)
  if (is.null(out)) {
    stop(sprintf(
      "Resposta nao-JSON (HTTP %s): %s",
      httr2::resp_status(resp), substr(txt, 1, 200)
    ), call. = FALSE)
  }
  if (isFALSE(out$sucesso)) {
    stop(sprintf("SEI: %s", out$mensagem %||% "erro sem mensagem"), call. = FALSE)
  }
  out
}

.sei_get <- function(caminho, query = list(), ...) {
  .sei_req("GET", caminho, query = query, ...)
}

.sei_post <- function(caminho, corpo = list(), ...) {
  .sei_req("POST", caminho, corpo = corpo, ...)
}

`%||%` <- function(a, b) if (is.null(a)) b else a
