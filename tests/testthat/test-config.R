library(testthat)
library(seiapi)

test_that("base da api e derivada corretamente", {
  expect_equal(
    .sei_api_base("https://processoeletronico.trabalho.gov.br"),
    "https://processoeletronico.trabalho.gov.br/sei/modulos/wssei/controlador_ws.php/api/v2"
  )
  expect_equal(
    .sei_api_base("https://x.gov.br/sei/modulos/wssei/controlador_ws.php/api/v2/"),
    "https://x.gov.br/sei/modulos/wssei/controlador_ws.php/api/v2"
  )
})

test_that("deteccao de api responde algo para o SEI Trabalho", {
  skip_on_cran()
  skip_if_offline()
  res <- sei_detectar_api("https://processoeletronico.trabalho.gov.br")
  expect_type(res$api_disponivel, "logical")
})

test_that("deteccao de api indica ausencia no SEI DF", {
  skip_on_cran()
  skip_if_offline()
  res <- sei_detectar_api("https://sei.df.gov.br")
  expect_false(res$api_disponivel)
})
