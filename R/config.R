#' @keywords internal
#' @import httr2
"_PACKAGE"

.sei_env <- new.env(parent = emptyenv())

.sei_api_base <- function(url) {
  if (grepl("controlador_ws\\.php", url, fixed = FALSE)) {
    return(sub("/+$", "", url))
  }
  sub("/+$", "", paste0(url, "/sei/modulos/wssei/controlador_ws.php/api/v2"))
}

#' Configura a instância do SEI a ser usada
#'
#' Define a URL da instalação (ex.: `https://processoeletronico.trabalho.gov.br`)
#' e o id numérico do órgão usado na autenticação (o valor aparece no QRCode
#' "Configurações do Aplicativo" no menu lateral do SEI web; `0` funciona no MTE).
#'
#' @param url URL raiz da instalação do SEI (sem `/sei`).
#' @param orgao Id numérico do órgão para autenticação.
#' @param contexto Id do contexto (opcional; raramente usado).
#' @return Invisivelmente, a configuração atual.
#' @export
sei_configurar <- function(url, orgao = 0, contexto = NULL) {
  .sei_env$url <- sub("/+$", "", url)
  .sei_env$base_api <- .sei_api_base(.sei_env$url)
  .sei_env$orgao <- orgao
  .sei_env$contexto <- contexto
  .sei_env$token <- NULL
  .sei_env$unidade <- NULL
  invisible(.sei_config_obter())
}

#' @rdname sei_configurar
#' @export
sei_sair <- function() {
  .sei_env$token <- NULL
  .sei_env$unidade <- NULL
  invisible(NULL)
}

.sei_config_obter <- function() {
  if (is.null(.sei_env$base_api)) {
    stop("Chame sei_configurar(url, orgao) antes.", call. = FALSE)
  }
  as.list(.sei_env)
}

.sei_exige_token <- function() {
  if (is.null(.sei_env$token)) {
    stop("Nao autenticado: chame sei_autenticar() primeiro.", call. = FALSE)
  }
}

#' Detecta se uma instalacao do SEI expoe a API REST (mod-wssei)
#'
#' Sonda `GET /api/v2/versao`: resposta 401 indica modulo presente e exigindo
#' token; 404 indica modulo ausente naquela URL (fallback: backend web).
#'
#' @param url URL raiz da instalacao do SEI.
#' @return Lista com `api_disponivel` (logical) e `status` (codigo HTTP).
#' @export
sei_detectar_api <- function(url) {
  u <- file.path(.sei_api_base(url), "versao")
  resp <- tryCatch(
    httr2::request(u) |> httr2::req_error(is_error = function(r) FALSE) |> httr2::req_perform(),
    error = function(e) NULL
  )
  status <- if (is.null(resp)) NA_integer_ else as.integer(httr2::resp_status(resp))
  list(url_sondada = u, status = status, api_disponivel = identical(status, 401L))
}
