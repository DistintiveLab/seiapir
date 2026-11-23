test_that("fluxo basico da api (requer credenciais reais)", {
  skip_on_cran()
  skip_if(!nchar(Sys.getenv("SEI_URL")), "SEI_URL nao definida")
  skip_if(!nchar(Sys.getenv("SEI_USUARIO")), "SEI_USUARIO nao definida")

  sei_configurar(Sys.getenv("SEI_URL"), orgao = as.numeric(Sys.getenv("SEI_ORGAO", "0")))
  login <- sei_autenticar()
  expect_true(nchar(login$token) > 10)

  versao <- .sei_get("/versao")
  expect_true(is.list(versao))

  unidades <- sei_unidades()
  expect_true(length(unidades) >= 1)

  sei_definir_unidade(unidades[[1]]$id)

  res <- sei_pesquisar(palavrasChave = "teste", limit = 3L)
  skip_if(nrow(res) == 0, "busca sem resultados")
  expect_s3_class(res, "data.frame")
  expect_true(attr(res, "total") >= 1)
  expect_true(grepl("^[0-9]{5}\\.[0-9]{6}/[0-9]{4}-[0-9]{2}$", res$protocolo[1]))

  bruto <- sei_pesquisar(palavrasChave = "teste", limit = 3L, simplificar = FALSE)
  expect_gte(as.numeric(bruto$total), 1)

  proc <- sei_processo(res$protocolo[1])
  expect_s3_class(proc, "data.frame")
  expect_true(grepl("^[0-9]+$", proc$id))

  docs <- sei_documentos(proc$id)
  expect_s3_class(docs, "data.frame")
  expect_identical(names(docs), c(
    "id", "protocolo", "nome", "titulo", "tipo", "mimeType",
    "tamanho", "unidade", "assinado"
  ))

  if (nrow(docs)) {
    info <- sei_documento_info(docs$id[1])
    expect_s3_class(info, "data.frame")
    expect_equal(nrow(info), 1)
    expect_true(nzchar(info$id))

    arq <- sei_documento_baixar(docs$id[1], progresso = FALSE)
    expect_true(file.size(arq) > 0)
    expect_true(nzchar(tools::file_ext(arq)))
    unlink(arq)
  }

  internos <- docs$id[grepl("html", docs$mimeType, fixed = TRUE)]
  if (length(internos)) {
    txt <- sei_documento_visualizar(internos[1])
    expect_type(txt, "character")
    expect_true(nchar(txt) > 0)
    html <- sei_documento_visualizar(internos[1], como = "html")
    expect_true(grepl("<body", html, fixed = TRUE))
    arq <- sei_documento_baixar(internos[1], progresso = FALSE)
    expect_identical(tools::file_ext(arq), "html")
    expect_true(any(grepl("<body", readLines(arq, warn = FALSE), fixed = TRUE)))
    unlink(arq)
  }
})
