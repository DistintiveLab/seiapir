# Retorna o conteudo HTML de um documento interno

O id exigido e o **id do documento**: campo `idDocumento` do resultado
de
[`sei_pesquisar()`](https://distintivelab.github.io/seiapir/reference/sei_pesquisar.md)
ou campo `id` de
[`sei_documentos()`](https://distintivelab.github.io/seiapir/reference/sei_documentos.md).
Nao confundir com o id do protocolo (`protocoloFormatadoDocumento`), que
se refere a outro objeto e gera erro de acesso nao autorizado.

## Usage

``` r
sei_documento_visualizar(documento)
```

## Arguments

- documento:

  Id do documento interno (nao o id do protocolo).

## Value

String com o conteudo do documento.
