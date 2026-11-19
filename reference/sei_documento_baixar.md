# Baixa o anexo de um documento

Apesar do nome do endpoint (`/documento/baixar/anexo/{protocolo}`), o
parametro e o **id do documento** (inteiro, campo `id` de
[`sei_documentos()`](https://distintivelab.github.io/seiapir/reference/sei_documentos.md)).

## Usage

``` r
sei_documento_baixar(documento, destino = tempfile(fileext = ".bin"))
```

## Arguments

- documento:

  Id do documento anexado.

- destino:

  Caminho do arquivo de saida.

## Value

Invisivelmente, o caminho gravado.
