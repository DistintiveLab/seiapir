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
  skip_if(!identical(res$total, 0) && length(res$data) == 0, "busca sem resultados")
  expect_true(res$total >= 1)

  proto <- res$data[[1]]$protocoloFormatadoProcedimento
  proc <- sei_processo(proto)
  expect_true(grepl("^[0-9]+$", proc$data$IdProcedimento))

  docs <- sei_documentos(proc$data$IdProcedimento)
  expect_type(docs$data, "list")

  if (length(docs$data)) {
    arq <- sei_documento_baixar(docs$data[[1]]$id)
    expect_true(file.size(arq) > 0)
    unlink(arq)
  }
})
