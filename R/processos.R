#' Pesquisa processos na base do SEI
#'
#' Wrapper de `GET /processo/pesquisar`. Use `palavrasChave` (busca completa,
#' estilo SOLR) ou `buscaRapida` (protocolo/interessado). Combine `dataInicio`
#' e `dataFim` (formato DD/MM/AAAA) com `staTipoData`.
#'
#' @param palavrasChave Palavras-chave para pesquisa textual.
#' @param buscaRapida Termo de busca rapida (ex.: numero do processo).
#' @param descricao Filtro por descricao do processo.
#' @param dataInicio,dataFim Datas no formato DD/MM/AAAA.
#' @param staTipoData Tipo de filtro por data (ver swagger).
#' @param idUnidadeGeradora Id da unidade geradora.
#' @param idAssunto Id do assunto.
#' @param limit,start Paginacao (registros por pagina / offset).
#' @param ... Parametros adicionais repassados como query string.
#' @return Resposta da API (lista; resultados em `data`).
#' @export
sei_pesquisar <- function(palavrasChave = NULL, buscaRapida = NULL, descricao = NULL,
                          dataInicio = NULL, dataFim = NULL, staTipoData = NULL,
                          idUnidadeGeradora = NULL, idAssunto = NULL,
                          limit = 50L, start = 0L, ...) {
  query <- .sei_sem_null(list(
    palavrasChave = palavrasChave, buscaRapida = buscaRapida, descricao = descricao,
    dataInicio = dataInicio, dataFim = dataFim, staTipoData = staTipoData,
    idUnidadeGeradora = idUnidadeGeradora, idAssunto = idAssunto,
    limit = limit, start = start, ...
  ))
  .sei_get("/processo/pesquisar", query = query)
}

.sei_sem_null <- function(x) x[!vapply(x, is.null, logical(1))]

#' Consulta um processo pelo numero de protocolo
#'
#' Usa `GET /processo/consultar` (parametro `protocoloFormatado`), pois o
#' formato `99999.999999/9999-99` contem `/` e nao cabe como segmento de path.
#'
#' @param protocolo Numero no formato 99999.999999/9999-99.
#' @return Resposta da API com dados do processo (inclui `IdProcedimento`).
#' @export
sei_processo <- function(protocolo) {
  .sei_get("/processo/consultar", query = list(protocoloFormatado = protocolo))
}

#' Lista documentos de um processo
#' @param procedimento Id do processo (inteiro interno; veja `sei_processo()`).
#' @param ... Query params adicionais (ex.: `sinSomenteAssinados = "S"`).
#' @return Resposta da API com os documentos do processo.
#' @export
sei_documentos <- function(procedimento, ...) {
  query <- .sei_sem_null(list(...))
  .sei_get(file.path("/documento/listar", as.character(procedimento)), query = query)
}

#' Retorna o conteudo HTML de um documento interno
#' @param documento Id do documento interno.
#' @return String com o conteudo do documento.
#' @export
sei_documento_visualizar <- function(documento) {
  .sei_get(file.path("/documento", as.character(documento), "interno/visualizar"))
}

#' Baixa o anexo de um documento
#'
#' Apesar do nome do endpoint (`/documento/baixar/anexo/{protocolo}`), o
#' parametro e o **id do documento** (inteiro, campo `id` de `sei_documentos()`).
#'
#' @param documento Id do documento anexado.
#' @param destino Caminho do arquivo de saida.
#' @return Invisivelmente, o caminho gravado.
#' @export
sei_documento_baixar <- function(documento, destino = tempfile(fileext = ".bin")) {
  .sei_exige_token()
  url <- paste0(sub("/+$", "", .sei_env$base_api), "/documento/baixar/anexo/", documento)
  req <- httr2::request(url)
  req <- httr2::req_headers(req, token = .sei_env$token)
  resp <- httr2::req_perform(req)
  writeBin(httr2::resp_body_raw(resp), destino)
  invisible(destino)
}

#' Lista andamentos de um processo
#' @param procedimento Id do processo.
#' @param ... Query params adicionais (ex.: `limit`, `start`).
#' @return Resposta da API com as atividades.
#' @export
sei_andamentos <- function(procedimento, ...) {
  query <- .sei_sem_null(list(...))
  .sei_get(file.path("/atividade/listar"), query = c(query, list(procedimento = procedimento)))
}

#' Lista tipos (series) de processo disponiveis
#' @param ... Query params adicionais (ex.: `inicio`, `limite` para filtrar por nome).
#' @return Resposta da API com os tipos de processo.
#' @export
sei_tipos_processo <- function(...) {
  .sei_get("/processo/tipo/listar", query = .sei_sem_null(list(...)))
}

#' Lista tipos (series) de documento disponiveis
#' @param ... Query params adicionais (ex.: `inicio`, `limite`, `idUnidade`).
#' @return Resposta da API com as series.
#' @export
sei_tipos_documento <- function(...) {
  .sei_get("/documento/tipo/pesquisar", query = .sei_sem_null(list(...)))
}
