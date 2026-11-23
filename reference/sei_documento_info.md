# Consulta metadados de um documento

Combina `GET /documento/externo/consultar/{id}` (documentos
externos/anexos) e `GET /documento/interno/consultar/{id}` (documentos
internos). O nome do parametro na API e "protocolo", mas o valor aceito
e o **id do documento** (coluna `documentoId` de
[`sei_pesquisar()`](https://distintivelab.github.io/seiapir/reference/sei_pesquisar.md)
ou coluna `id` de
[`sei_documentos()`](https://distintivelab.github.io/seiapir/reference/sei_documentos.md)).
O campo `anexo` so existe em documentos externos e traz o nome original
do arquivo (com extensao) e o tamanho em bytes.

## Usage

``` r
sei_documento_info(documento)
```

## Arguments

- documento:

  Id do documento (nao o id do protocolo).

## Value

data.frame de uma linha com `id`, `protocolo`, `serie`, `nome`,
`numero`, `tipo` (`"externo"` ou `"interno"`), `dataElaboracao`,
`hipoteseLegal`, `anexo` (nome do arquivo original; `NA` em documentos
internos) e `tamanho` (bytes, como character).
