# Autentica na API do SEI (mod-wssei)

Envia sigla de usuario e senha (a mesma do login web do SEI) para
`POST /autenticar` e guarda o token retornado para as demais chamadas.
No MTE, a sigla e a parte local do e-mail institucional (ex.:
`nome.sobrenome`). A senha pode ser informada por argumento, pela
variavel de ambiente `SEI_SENHA` ou, de forma interativa, via
[`askpass::askpass()`](https://rdrr.io/pkg/askpass/man/askpass.html).

## Usage

``` r
sei_autenticar(
  usuario = Sys.getenv("SEI_USUARIO"),
  senha = NULL,
  orgao = .sei_env$orgao,
  contexto = .sei_env$contexto
)
```

## Arguments

- usuario:

  Sigla do usuario (default: variavel `SEI_USUARIO`).

- senha:

  Senha (default: `SEI_SENHA`, senao interativo).

- orgao:

  Id do orgao (default: valor de
  [`sei_configurar()`](https://distintivelab.github.io/seiapir/reference/sei_configurar.md)).

- contexto:

  Id do contexto (opcional).

## Value

Lista com os dados do login (token, usuario, unidades).

## Details

O id do orgao pode ser descoberto no formulario de login do SIP (valor
do `selOrgao`; ex.: MTE = 3).
