# Cria um novo processo

Wrapper de `POST /processo/criar`. Descubra ids com
[`sei_tipos_processo()`](https://distintivelab.github.io/seiapir/reference/sei_tipos_processo.md)
(idTipoProcedimento), e opcionalmente
[`sei_pesquisar()`](https://distintivelab.github.io/seiapir/reference/sei_pesquisar.md)
de assuntos.

## Usage

``` r
sei_criar_processo(
  tipo,
  especificacao = NULL,
  nivel_acesso = 0L,
  hipotese_legal = NULL,
  assuntos = NULL,
  interessados = NULL,
  ...
)
```

## Arguments

- tipo:

  Id do tipo de processo (idTipoProcedimento).

- especificacao:

  Texto de especificacao do processo.

- nivel_acesso:

  0 = publico, 1 = restrito, 2 = sigiloso.

- hipotese_legal:

  Id da hipotese legal (se nivel_acesso \> 0).

- assuntos:

  Ids de assuntos (vetor numerico ou de caracteres).

- interessados:

  Ids de interessados (vetor).

- ...:

  Campos adicionais do formulario (ver swagger).

## Value

Resposta da API com o processo criado.
