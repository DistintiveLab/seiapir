# Lista documentos de um processo

Lista documentos de um processo

## Usage

``` r
sei_documentos(procedimento, ..., simplificar = TRUE)
```

## Arguments

- procedimento:

  Id do processo (coluna `id` de
  [`sei_processo()`](https://distintivelab.github.io/seiapir/reference/sei_processo.md)
  ou `idProcedimento` de
  [`sei_pesquisar()`](https://distintivelab.github.io/seiapir/reference/sei_pesquisar.md)).

- ...:

  Query params adicionais (ex.: `sinSomenteAssinados = "S"`).

- simplificar:

  Se `TRUE` (padrao), devolve um data.frame com uma linha por documento;
  se `FALSE`, a resposta bruta da API (lista).

## Value

Com `simplificar = TRUE`, um data.frame com colunas `id`, `protocolo`,
`nome`, `titulo`, `tipo`, `mimeType`, `tamanho`, `unidade` e `assinado`
(logico). O total fica no atributo `total` (`attr(res, "total")`).
