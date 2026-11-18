#' Autentica na sessao web do SEI (fallback para instancias sem API)
#'
#' Reproduz o login do SIP (formulario `frmLogin`: `txtUsuario`, `pwdSenha`,
#' opcional `selOrgao`) mantendo os cookies de sessao. Retorne o objeto para
#' usar nas raspagens subsequentes (`rvest::session_jump_to()` etc.).
#'
#' @param url URL raiz da instalacao do SEI (ex.: `https://sei.df.gov.br`).
#' @param usuario Sigla do usuario.
#' @param senha Senha (interativa se omitida e `askpass` disponivel).
#' @param sigla_orgao Sigla do orgao do sistema (default: detecta da URL
#'   ou usa "GDF"; ajuste conforme o banner do SEI local).
#' @param orgao_sel Valor do campo `selOrgao`, se o formulario exigir.
#' @return Objeto `rvest::session` autenticado (invisivel).
#' @export
sei_web_login <- function(url, usuario = Sys.getenv("SEI_USUARIO"), senha = NULL,
                          sigla_orgao = "GDF", orgao_sel = NULL) {
  if (is.null(senha)) {
    senha <- if (nchar(Sys.getenv("SEI_SENHA"))) Sys.getenv("SEI_SENHA") else
      askpass::askpass("Senha do SEI:")
  }
  login_url <- sprintf(
    "%s/sip/login.php?sigla_orgao_sistema=%s&sigla_sistema=SEI",
    sub("/+$", "", url), sigla_orgao
  )
  sess <- rvest::session(login_url)
  formularios <- rvest::html_form(rvest::read_html(sess$response))
  form <- formularios[[which(vapply(formularios, function(f) f$name, "") == "frmLogin")[1]]]
  campos <- list(txtUsuario = usuario, pwdSenha = senha)
  if (!is.null(orgao_sel) && "selOrgao" %in% names(form$fields)) {
    campos$selOrgao <- as.character(orgao_sel)
  }
  form <- do.call(rvest::html_form_set, c(list(form = form), campos))
  sess <- rvest::session_submit(sess, form)
  if (grepl("login\\.php", sess$url, fixed = TRUE)) {
    stop("Login web falhou (permaneceu na tela de login). Verifique credenciais/orgao.", call. = FALSE)
  }
  invisible(sess)
}
