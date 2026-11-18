#' Cria um novo processo
#'
#' Wrapper de `POST /processo/criar`. Descubra ids com `sei_tipos_processo()`
#' (idTipoProcedimento), e opcionalmente `sei_pesquisar()` de assuntos.
#'
#' @param tipo Id do tipo de processo (idTipoProcedimento).
#' @param especificacao Texto de especificacao do processo.
#' @param nivel_acesso 0 = publico, 1 = restrito, 2 = sigiloso.
#' @param hipotese_legal Id da hipotese legal (se nivel_acesso > 0).
#' @param assuntos Ids de assuntos (vetor numerico ou de caracteres).
#' @param interessados Ids de interessados (vetor).
#' @param ... Campos adicionais do formulario (ver swagger).
#' @return Resposta da API com o processo criado.
#' @export
sei_criar_processo <- function(tipo, especificacao = NULL, nivel_acesso = 0L,
                               hipotese_legal = NULL, assuntos = NULL,
                               interessados = NULL, ...) {
  corpo <- list(
    idTipoProcedimento = as.character(tipo),
    especificacao = especificacao,
    nivelAcesso = as.character(nivel_acesso)
  )
  if (!is.null(hipotese_legal)) corpo$hipoteseLegal <- as.character(hipotese_legal)
  if (!is.null(assuntos)) corpo$assuntos <- jsonlite::toJSON(
    lapply(assuntos, function(x) list(id = as.character(x))), auto_unbox = TRUE
  )
  if (!is.null(interessados)) corpo$interessados <- jsonlite::toJSON(
    lapply(interessados, function(x) list(id = as.character(x))), auto_unbox = TRUE
  )
  corpo <- c(corpo, list(...))
  .sei_post("/processo/criar", corpo)
}

#' Inclui documento externo (arquivo) em um processo
#'
#' Wrapper de `POST /documento/{procedimento}/externo/criar` (multipart).
#'
#' @param procedimento Id do processo destino.
#' @param arquivo Caminho do arquivo a anexar.
#' @param id_serie Id do tipo de documento (veja `sei_tipos_documento()`).
#' @param data_elaboracao Data do documento (Date ou string DD/MM/AAAA).
#' @param nome_arvore Nome exibido na arvore do processo.
#' @param nivel_acesso 0 = publico, 1 = restrito, 2 = sigiloso.
#' @param ... Campos adicionais (ex.: `numero`, `idTipoConferencia`).
#' @return Resposta da API com o documento incluido.
#' @export
sei_incluir_documento_externo <- function(procedimento, arquivo, id_serie,
                                          data_elaboracao = Sys.Date(),
                                          nome_arvore = NULL, nivel_acesso = 0L, ...) {
  corpo <- list(
    idSerie = as.character(id_serie),
    dataElaboracao = if (inherits(data_elaboracao, "Date")) {
      format(data_elaboracao, "%d/%m/%Y")
    } else data_elaboracao,
    nivelAcesso = as.character(nivel_acesso),
    anexo = curl::form_file(arquivo)
  )
  if (!is.null(nome_arvore)) corpo$nomeArvore <- nome_arvore
  corpo <- c(corpo, list(...))
  .sei_req("POST", file.path("/documento", as.character(procedimento), "externo/criar"),
           corpo = corpo, multipart = TRUE)
}

#' Inclui documento interno (gerado pelo editor do SEI) em um processo
#'
#' Wrapper de `POST /documento/{procedimento}/interno/criar`. Campos:
#' `idSerie`, `descricao`, `nivelAcesso`, `observacao`, `assuntos`,
#' `interessados`, `destinatarios`, `idTextoPadraoInterno`, `idHipoteseLegal`.
#'
#' @param procedimento Id do processo destino.
#' @param id_serie Id do tipo de documento.
#' @param descricao Descricao/conteudo do documento.
#' @param ... Campos adicionais do formulario.
#' @return Resposta da API com o documento incluido.
#' @export
sei_incluir_documento_interno <- function(procedimento, id_serie, descricao = NULL, ...) {
  corpo <- c(list(idSerie = as.character(id_serie), descricao = descricao), list(...))
  .sei_post(file.path("/documento", as.character(procedimento), "interno/criar"), corpo)
}

#' Envia (tramita) um processo para outras unidades
#'
#' Wrapper de `POST /processo/enviar`.
#'
#' @param numero_processo Numero do processo (protocolo).
#' @param unidades_destino Ids das unidades destino (vetor).
#' @param manter_aberto Manter processo aberto na unidade atual ("S"/"N").
#' @param ... Campos adicionais (ex.: `sinReabrir`, `diasRetornoProgramado`).
#' @return Resposta da API.
#' @export
sei_enviar_processo <- function(numero_processo, unidades_destino,
                                manter_aberto = "S", ...) {
  corpo <- c(list(
    numeroProcesso = numero_processo,
    unidadesDestino = paste(unidades_destino, collapse = ","),
    sinManterAbertoUnidade = manter_aberto
  ), list(...))
  .sei_post("/processo/enviar", corpo)
}
