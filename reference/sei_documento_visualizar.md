# Visualiza o conteudo de um documento interno

O id exigido e o **id do documento**: coluna `documentoId` de
[`sei_pesquisar()`](https://distintivelab.github.io/seiapir/reference/sei_pesquisar.md)
ou coluna `id` de
[`sei_documentos()`](https://distintivelab.github.io/seiapir/reference/sei_documentos.md).
Nao confundir com o id do protocolo (coluna `documentoProtocolo` da
busca), que se refere a outro objeto e gera erro de acesso nao
autorizado.

## Usage

``` r
sei_documento_visualizar(documento, como = c("texto", "html"))
```

## Arguments

- documento:

  Id do documento interno (nao o id do protocolo).

- como:

  Formato de saida: `"texto"` (padrao) extrai o texto puro do HTML do
  documento; `"html"` devolve o HTML integral.

## Value

String (character de comprimento 1) com o conteudo do documento.
