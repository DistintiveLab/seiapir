# Baixa o anexo de um documento

Apesar do nome do endpoint (`/documento/baixar/anexo/{protocolo}`), o
parametro e o **id do documento**: campo `idDocumento` do resultado de
[`sei_pesquisar()`](https://distintivelab.github.io/seiapir/reference/sei_pesquisar.md)
ou campo `id` de
[`sei_documentos()`](https://distintivelab.github.io/seiapir/reference/sei_documentos.md).
Passando o id do protocolo (`protocoloFormatadoDocumento`) o servico
pode ate responder, mas devolve outro conteudo (o protocolo, nao o
anexo).

## Usage

``` r
sei_documento_baixar(documento, destino = tempfile(fileext = ".bin"))
```

## Arguments

- documento:

  Id do documento anexado (nao o id do protocolo).

- destino:

  Caminho do arquivo de saida.

## Value

Invisivelmente, o caminho gravado.
