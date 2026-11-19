# Autentica na sessao web do SEI (fallback para instancias sem API)

Reproduz o login do SIP (formulario `frmLogin`: `txtUsuario`,
`pwdSenha`, opcional `selOrgao`) mantendo os cookies de sessao. Retorne
o objeto para usar nas raspagens subsequentes
([`rvest::session_jump_to()`](https://rvest.tidyverse.org/reference/session.html)
etc.).

## Usage

``` r
sei_web_login(
  url,
  usuario = Sys.getenv("SEI_USUARIO"),
  senha = NULL,
  sigla_orgao = "GDF",
  orgao_sel = NULL
)
```

## Arguments

- url:

  URL raiz da instalacao do SEI (ex.: `https://sei.df.gov.br`).

- usuario:

  Sigla do usuario.

- senha:

  Senha (interativa se omitida e `askpass` disponivel).

- sigla_orgao:

  Sigla do orgao do sistema (default: detecta da URL ou usa "GDF";
  ajuste conforme o banner do SEI local).

- orgao_sel:

  Valor do campo `selOrgao`, se o formulario exigir.

## Value

Objeto
[`rvest::session`](https://rvest.tidyverse.org/reference/session.html)
autenticado (invisivel).
