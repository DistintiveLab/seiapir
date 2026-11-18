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
})
