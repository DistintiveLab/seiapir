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
#' @param simplificar Se `TRUE` (padrao), devolve um data.frame com uma linha
#'   por resultado; se `FALSE`, a resposta bruta da API (lista).
#' @param ... Parametros adicionais repassados como query string.
#' @return Com `simplificar = TRUE`, um data.frame com colunas `idProcedimento`,
#'   `protocolo`, `tipo`, `unidadeGeradora`, `dataGeracao`, `documentoId`,
#'   `documentoProtocolo`, `documentoSerie` e `documentoNome` (colunas de
#'   documento ficam `NA` quando o resultado nao traz documento destacado).
#'   O total de registros da busca fica no atributo `total`
#'   (`attr(res, "total")`).
#' @export
sei_pesquisar <- function(palavrasChave = NULL, buscaRapida = NULL, descricao = NULL,
                          dataInicio = NULL, dataFim = NULL, staTipoData = NULL,
                          idUnidadeGeradora = NULL, idAssunto = NULL,
                          limit = 50L, start = 0L, simplificar = TRUE, ...) {
  query <- .sei_sem_null(list(
    palavrasChave = palavrasChave, buscaRapida = buscaRapida, descricao = descricao,
    dataInicio = dataInicio, dataFim = dataFim, staTipoData = staTipoData,
    idUnidadeGeradora = idUnidadeGeradora, idAssunto = idAssunto,
    limit = limit, start = start, ...
  ))
  res <- .sei_get("/processo/pesquisar", query = query)
  if (!simplificar) {
    return(res)
  }
  df <- .sei_df_pesquisa(res$data)
  attr(df, "total") <- as.integer(res$total %||% NA)
  df
}

.sei_sem_null <- function(x) x[!vapply(x, is.null, logical(1))]

.sei_vchr <- function(itens, campo) {
  vapply(itens, function(i) {
    if (!is.list(i)) return(NA_character_)
    v <- i[[campo]]
    if (is.null(v)) NA_character_ else as.character(v)
  }, character(1))
}

.sei_df_pesquisa <- function(itens) {
  if (!length(itens)) {
    return(data.frame(
      idProcedimento = character(), protocolo = character(), tipo = character(),
      unidadeGeradora = character(), dataGeracao = character(),
      documentoId = character(), documentoProtocolo = character(),
      documentoSerie = character(), documentoNome = character(),
      stringsAsFactors = FALSE
    ))
  }
  docs <- lapply(itens, function(i) i$documento %||% list())
  data.frame(
    idProcedimento = .sei_vchr(itens, "idProcedimento"),
    protocolo = .sei_vchr(itens, "protocoloFormatadoProcedimento"),
    tipo = .sei_vchr(itens, "nomeTipoProcedimento"),
    unidadeGeradora = .sei_vchr(itens, "siglaUnidadeGeradora"),
    dataGeracao = .sei_vchr(itens, "dataGeracao"),
    documentoId = .sei_vchr(docs, "idDocumento"),
    documentoProtocolo = .sei_vchr(docs, "protocoloFormatadoDocumento"),
    documentoSerie = .sei_vchr(docs, "nomeSerieDocumento"),
    documentoNome = vapply(docs, function(d) {
      if (!is.list(d) || !is.list(d$dadosAnexo)) NA_character_
      else d$dadosAnexo$nome %||% NA_character_
    }, character(1)),
    stringsAsFactors = FALSE
  )
}

.sei_wrap_dica_documento <- function(expr) {
  tryCatch(expr, error = function(e) {
    msg <- conditionMessage(e)
    if (grepl("Acesso ao documento", msg, fixed = TRUE)) {
      msg <- paste(
        msg,
        "Dica: informe o id do DOCUMENTO (coluna `documentoId` de",
        "`sei_pesquisar()` ou coluna `id` de `sei_documentos()`), nao o id",
        "do protocolo (coluna `documentoProtocolo` da busca)."
      )
      e$message <- msg
    }
    stop(e)
  })
}

#' Consulta um processo pelo numero de protocolo
#'
#' Usa `GET /processo/consultar` (parametro `protocoloFormatado`), pois o
#' formato `99999.999999/9999-99` contem `/` e nao cabe como segmento de path.
#'
#' @param protocolo Numero no formato 99999.999999/9999-99.
#' @return data.frame de uma linha com `id`, `protocolo` e `tipo` do processo.
#' @export
sei_processo <- function(protocolo) {
  res <- .sei_get("/processo/consultar", query = list(protocoloFormatado = protocolo))
  d <- res$data
  data.frame(
    id = as.character(d$IdProcedimento %||% NA_character_),
    protocolo = as.character(d$ProtocoloProcedimentoFormatado %||% NA_character_),
    tipo = as.character(d$NomeTipoProcedimento %||% NA_character_),
    stringsAsFactors = FALSE
  )
}

#' Lista documentos de um processo
#'
#' @param procedimento Id do processo (coluna `id` de `sei_processo()` ou
#'   `idProcedimento` de `sei_pesquisar()`).
#' @param simplificar Se `TRUE` (padrao), devolve um data.frame com uma linha
#'   por documento; se `FALSE`, a resposta bruta da API (lista).
#' @param ... Query params adicionais (ex.: `sinSomenteAssinados = "S"`).
#' @return Com `simplificar = TRUE`, um data.frame com colunas `id`,
#'   `protocolo`, `nome`, `titulo`, `tipo`, `mimeType`, `tamanho`, `unidade`
#'   e `assinado` (logico). O total fica no atributo `total`
#'   (`attr(res, "total")`).
#' @export
sei_documentos <- function(procedimento, ..., simplificar = TRUE) {
  query <- .sei_sem_null(list(...))
  res <- .sei_get(file.path("/documento/listar", as.character(procedimento)), query = query)
  if (!simplificar) {
    return(res)
  }
  df <- .sei_df_documentos(res$data)
  attr(df, "total") <- as.integer(res$total %||% NA)
  df
}

.sei_df_documentos <- function(itens) {
  if (!length(itens)) {
    return(data.frame(
      id = character(), protocolo = character(), nome = character(),
      titulo = character(), tipo = character(), mimeType = character(),
      tamanho = character(), unidade = character(), assinado = logical(),
      stringsAsFactors = FALSE
    ))
  }
  atr <- lapply(itens, function(d) d$atributos %||% list())
  data.frame(
    id = .sei_vchr(itens, "id"),
    protocolo = .sei_vchr(atr, "protocoloFormatado"),
    nome = .sei_vchr(atr, "nome"),
    titulo = .sei_vchr(atr, "titulo"),
    tipo = .sei_vchr(atr, "tipo"),
    mimeType = .sei_vchr(atr, "mimeType"),
    tamanho = .sei_vchr(atr, "tamanho"),
    unidade = .sei_vchr(atr, "siglaUnidade"),
    assinado = vapply(atr, function(a) {
      if (!is.list(a) || !is.list(a$status)) return(FALSE)
      identical(a$status$documentoAssinado %||% NA_character_, "S")
    }, logical(1)),
    stringsAsFactors = FALSE
  )
}

#' Visualiza o conteudo de um documento interno
#'
#' O id exigido e o **id do documento**: coluna `documentoId` de
#' `sei_pesquisar()` ou coluna `id` de `sei_documentos()`. Nao confundir com o
#' id do protocolo (coluna `documentoProtocolo` da busca), que se refere a
#' outro objeto e gera erro de acesso nao autorizado.
#'
#' @param documento Id do documento interno (nao o id do protocolo).
#' @param como Formato de saida: `"texto"` (padrao) extrai o texto puro do
#'   HTML do documento; `"html"` devolve o HTML integral.
#' @return String (character de comprimento 1) com o conteudo do documento.
#' @export
sei_documento_visualizar <- function(documento, como = c("texto", "html")) {
  como <- match.arg(como)
  res <- .sei_wrap_dica_documento(
    .sei_get(file.path("/documento", as.character(documento), "interno/visualizar"))
  )
  html <- .sei_desescapar(as.character(res$data))
  html <- gsub("charset\\s*=\\s*iso-8859-1", "charset=utf-8", html, ignore.case = TRUE)
  if (como == "html") {
    return(html)
  }
  corpo <- rvest::html_element(rvest::read_html(html), "body")
  if (!length(corpo)) {
    return("")
  }
  trimws(rvest::html_text2(corpo))
}

.sei_desescapar <- function(x) {
  x <- gsub("&lt;", "<", x, fixed = TRUE)
  x <- gsub("&gt;", ">", x, fixed = TRUE)
  x <- gsub("&quot;", '"', x, fixed = TRUE)
  x <- gsub("&#039;|&#39;", "'", x)
  x <- gsub("&nbsp;", " ", x, fixed = TRUE)
  x <- gsub("&amp;", "&", x, fixed = TRUE)
  enc2utf8(x)
}

#' Consulta metadados de um documento
#'
#' Combina `GET /documento/externo/consultar/{id}` (documentos externos/anexos)
#' e `GET /documento/interno/consultar/{id}` (documentos internos). O nome do
#' parametro na API e "protocolo", mas o valor aceito e o **id do documento**
#' (coluna `documentoId` de `sei_pesquisar()` ou coluna `id` de
#' `sei_documentos()`). O campo `anexo` so existe em documentos externos e
#' traz o nome original do arquivo (com extensao) e o tamanho em bytes.
#'
#' @param documento Id do documento (nao o id do protocolo).
#' @return data.frame de uma linha com `id`, `protocolo`, `serie`, `nome`,
#'   `numero`, `tipo` (`"externo"` ou `"interno"`), `dataElaboracao`,
#'   `hipoteseLegal`, `anexo` (nome do arquivo original; `NA` em documentos
#'   internos) e `tamanho` (bytes, como character).
#' @export
sei_documento_info <- function(documento) {
  info <- .sei_info_documento(documento)
  d <- info$dados
  anexo <- if (is.list(d$anexo)) d$anexo else list()
  data.frame(
    id = as.character(d$idDocumento %||% NA_character_),
    protocolo = as.character(d$protocolo %||% NA_character_),
    serie = as.character(d$nomeSerie %||% NA_character_),
    nome = as.character(d$nomeDocumento %||% NA_character_),
    numero = as.character(d$numero %||% NA_character_),
    tipo = info$tipo,
    dataElaboracao = as.character(d$dataElaboracao %||% NA_character_),
    hipoteseLegal = as.character(d$nomeHipoteseLegal %||% NA_character_),
    anexo = as.character(anexo$nome %||% NA_character_),
    tamanho = as.character(anexo$tamanho %||% NA_character_),
    stringsAsFactors = FALSE
  )
}

.sei_info_documento <- function(documento) {
  documento <- as.character(documento)
  dados <- tryCatch(
    .sei_get(file.path("/documento/externo/consultar", documento))$data,
    error = function(e) NULL
  )
  if (!is.null(dados)) {
    return(list(tipo = "externo", dados = dados))
  }
  dados <- .sei_get(file.path("/documento/interno/consultar", documento))$data
  list(tipo = "interno", dados = dados)
}

#' Baixa o arquivo de um documento
#'
#' Apesar do nome do endpoint (`/documento/baixar/anexo/{protocolo}`), o
#' parametro e o **id do documento**: coluna `documentoId` de
#' `sei_pesquisar()` ou coluna `id` de `sei_documentos()`. Passando o id do
#' protocolo (coluna `documentoProtocolo` da busca) o servico pode ate
#' responder, mas devolve outro conteudo (o protocolo, nao o anexo).
#'
#' A extensao do arquivo e detectada a partir dos metadados do documento
#' (`sei_documento_info()`): anexos externos preservam o nome original do
#' arquivo; documentos internos sao gravados como `.html`.
#'
#' @param documento Id do documento (nao o id do protocolo).
#' @param destino Caminho do arquivo de saida, caminho de um **diretorio**
#'   (o nome do arquivo e derivado dos metadados) ou `NULL` (padrao): grava
#'   em `tempdir()` com o nome detectado.
#' @param progresso Se `TRUE`, exibe barra de progresso do download
#'   (padrao: `interactive()`).
#' @return Invisivelmente, o caminho gravado (com extensao detectada).
#' @export
sei_documento_baixar <- function(documento, destino = NULL, progresso = interactive()) {
  .sei_exige_token()
  documento <- as.character(documento)
  info <- tryCatch(.sei_info_documento(documento), error = function(e) NULL)
  nome <- .sei_nome_sugerido(info, documento)
  if (is.null(destino)) {
    destino <- file.path(tempdir(), nome)
  } else if (dir.exists(destino)) {
    destino <- file.path(destino, nome)
  }
  url <- paste0(sub("/+$", "", .sei_env$base_api), "/documento/baixar/anexo/", documento)
  req <- httr2::request(url)
  req <- httr2::req_headers(req, token = .sei_env$token)
  req <- httr2::req_error(req, is_error = function(r) FALSE)
  if (isTRUE(progresso)) {
    req <- httr2::req_progress(req, "down")
  }
  resp <- httr2::req_perform(req)
  ct <- tolower(httr2::resp_headers(resp)$`content-type` %||% "")
  if (grepl("json", ct)) {
    corpo <- .sei_wrap_dica_documento(.sei_decodificar(resp))
    if (!is.null(corpo$data$html)) {
      destino <- .sei_completar_ext(destino, ".html")
      writeBin(charToRaw(enc2utf8(.sei_desescapar(corpo$data$html))), destino)
      return(invisible(destino))
    }
  }
  if (httr2::resp_status(resp) >= 400) {
    stop(sprintf("SEI: HTTP %s ao baixar documento %s", httr2::resp_status(resp), documento), call. = FALSE)
  }
  destino <- .sei_completar_ext(
    destino, .sei_ext_de_nome(nome) %||% .sei_ext_de_mime(ct)
  )
  writeBin(httr2::resp_body_raw(resp), destino)
  invisible(destino)
}

.sei_nome_sugerido <- function(info, documento) {
  if (is.null(info)) {
    return(paste0("documento_", documento))
  }
  anexo <- if (is.list(info$dados$anexo)) info$dados$anexo else list()
  if (!is.null(anexo$nome)) {
    return(.sei_sanitizar_nome(anexo$nome))
  }
  base <- .sei_sanitizar_nome(
    info$dados$nomeDocumento %||% paste0("documento_", documento)
  )
  if (identical(info$tipo, "interno")) {
    base <- paste0(base, ".html")
  }
  base
}

.sei_sanitizar_nome <- function(nome) {
  n <- gsub('[\\\\/:*?"<>|]', "_", nome)
  n <- trimws(n)
  if (!nchar(n)) "documento" else n
}

.sei_completar_ext <- function(destino, ext) {
  if (grepl("\\.[A-Za-z0-9]{1,5}$", destino)) destino else paste0(destino, ext)
}

.sei_ext_de_nome <- function(nome) {
  n <- as.character(nome)[1]
  if (is.na(n)) return(NULL)
  m <- regmatches(n, regexpr("\\.[A-Za-z0-9]{1,5}$", n))
  if (length(m) && nchar(m) > 1) m else NULL
}

.sei_ext_de_mime <- function(mimeType) {
  m <- tolower(as.character(mimeType)[1])
  if (is.na(m) || !nchar(m)) {
    return(".bin")
  }
  m <- sub(";.*$", "", trimws(m))
  mapa <- c(
    "application/pdf" = "pdf", "text/html" = "html", "text/plain" = "txt",
    "text/rtf" = "rtf", "application/rtf" = "rtf", "application/msword" = "doc",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "docx",
    "application/vnd.ms-excel" = "xls",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "xlsx",
    "application/vnd.ms-powerpoint" = "ppt",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "pptx",
    "application/vnd.oasis.opendocument.text" = "odt",
    "application/vnd.oasis.opendocument.spreadsheet" = "ods",
    "application/zip" = "zip", "application/x-rar-compressed" = "rar",
    "application/json" = "json", "text/xml" = "xml", "application/xml" = "xml",
    "text/csv" = "csv", "image/jpeg" = "jpg", "image/png" = "png",
    "image/gif" = "gif", "image/bmp" = "bmp", "image/tiff" = "tif",
    "image/svg+xml" = "svg", "audio/mpeg" = "mp3", "video/mp4" = "mp4",
    "application/octet-stream" = "bin"
  )
  if (m %in% names(mapa)) {
    return(paste0(".", mapa[[m]]))
  }
  if (!grepl("/", m) && grepl("^[a-z0-9]{1,5}$", m)) {
    return(paste0(".", m))
  }
  subtipo <- sub("^[^/]+/", "", m)
  if (grepl("^[a-z0-9]{1,5}$", subtipo)) paste0(".", subtipo) else ".bin"
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
