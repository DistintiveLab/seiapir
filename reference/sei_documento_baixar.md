# Baixa o arquivo de um documento

Apesar do nome do endpoint (`/documento/baixar/anexo/{protocolo}`), o
parametro e o **id do documento**: coluna `documentoId` de
[`sei_pesquisar()`](https://distintivelab.github.io/seiapir/reference/sei_pesquisar.md)
ou coluna `id` de
[`sei_documentos()`](https://distintivelab.github.io/seiapir/reference/sei_documentos.md).
Passando o id do protocolo (coluna `documentoProtocolo` da busca) o
servico pode ate responder, mas devolve outro conteudo (o protocolo, nao
o anexo).

## Usage

``` r
sei_documento_baixar(documento, destino = NULL, progresso = interactive())
```

## Arguments

- documento:

  Id do documento (nao o id do protocolo).

- destino:

  Caminho do arquivo de saida, caminho de um **diretorio** (o nome do
  arquivo e derivado dos metadados) ou `NULL` (padrao): grava em
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) com o nome
  detectado.

- progresso:

  Se `TRUE`, exibe barra de progresso do download (padrao:
  [`interactive()`](https://rdrr.io/r/base/interactive.html)).

## Value

Invisivelmente, o caminho gravado (com extensao detectada).

## Details

A extensao do arquivo e detectada a partir dos metadados do documento
([`sei_documento_info()`](https://distintivelab.github.io/seiapir/reference/sei_documento_info.md)):
anexos externos preservam o nome original do arquivo; documentos
internos sao gravados como `.html`.
