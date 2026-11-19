#' Autentica na API do SEI (mod-wssei)
#'
#' Envia sigla de usuario e senha (a mesma do login web do SEI) para
#' `POST /autenticar` e guarda o token retornado para as demais chamadas.
#' No MTE, a sigla e a parte local do e-mail institucional (ex.:
#' `nome.sobrenome`). A senha pode ser informada por argumento, pela variavel
#' de ambiente `SEI_SENHA` ou, de forma interativa, via `askpass::askpass()`.
#'
#' O id do orgao pode ser descoberto no formulario de login do SIP (valor do
#' `selOrgao`; ex.: MTE = 3).
#'
#' @param usuario Sigla do usuario (default: variavel `SEI_USUARIO`).
#' @param senha Senha (default: `SEI_SENHA`, senao interativo).
#' @param orgao Id do orgao (default: valor de `sei_configurar()`).
#' @param contexto Id do contexto (opcional).
#' @return Lista com os dados do login (token, usuario, unidades).
#' @export
sei_autenticar <- function(usuario = Sys.getenv("SEI_USUARIO"),
                           senha = NULL,
                           orgao = .sei_env$orgao,
                           contexto = .sei_env$contexto) {
  cfg <- .sei_config_obter()
  if (!nchar(usuario)) stop("Informe o usuario (argumento ou SEI_USUARIO).", call. = FALSE)
  if (is.null(senha)) {
    senha <- if (nchar(Sys.getenv("SEI_SENHA"))) Sys.getenv("SEI_SENHA") else
      if (interactive()) askpass::askpass("Senha do SEI:") else
        stop("Senha ausente: use o argumento senha ou a variavel SEI_SENHA.", call. = FALSE)
  }
  corpo <- list(usuario = usuario, senha = senha, orgao = as.character(orgao))
  if (!is.null(contexto)) corpo$contexto <- as.character(contexto)
  out <- .sei_post("/autenticar", corpo, exigir_token = FALSE)
  if (!isTRUE(out$sucesso)) {
    stop(sprintf("Autenticacao falhou: %s", out$mensagem %||% "erro desconhecido"), call. = FALSE)
  }
  .sei_env$token <- out$data$token
  .sei_env$login <- out$data$login
  .sei_env$unidades <- out$data$unidades
  invisible(out$data)
}

#' Unidades disponiveis para o usuario autenticado
#' @return data.frame (ou lista) de unidades.
#' @export
sei_unidades <- function() {
  .sei_exige_token()
  .sei_env$unidades
}

#' Define a unidade ativa da sessao
#' @param id Id numerico da unidade (veja `sei_unidades()`).
#' @export
sei_definir_unidade <- function(id) {
  .sei_exige_token()
  out <- .sei_post("/usuario/alterar/unidade", list(unidade = as.character(id)))
  if (isTRUE(out$sucesso)) .sei_env$unidade <- id
  invisible(out)
}
