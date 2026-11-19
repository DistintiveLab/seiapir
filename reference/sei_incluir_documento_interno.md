# Inclui documento interno (gerado pelo editor do SEI) em um processo

Wrapper de `POST /documento/{procedimento}/interno/criar`. Campos:
`idSerie`, `descricao`, `nivelAcesso`, `observacao`, `assuntos`,
`interessados`, `destinatarios`, `idTextoPadraoInterno`,
`idHipoteseLegal`.

## Usage

``` r
sei_incluir_documento_interno(procedimento, id_serie, descricao = NULL, ...)
```

## Arguments

- procedimento:

  Id do processo destino.

- id_serie:

  Id do tipo de documento.

- descricao:

  Descricao/conteudo do documento.

- ...:

  Campos adicionais do formulario.

## Value

Resposta da API com o documento incluido.
