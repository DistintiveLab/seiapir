# Inclui documento externo (arquivo) em um processo

Wrapper de `POST /documento/{procedimento}/externo/criar` (multipart).

## Usage

``` r
sei_incluir_documento_externo(
  procedimento,
  arquivo,
  id_serie,
  data_elaboracao = Sys.Date(),
  nome_arvore = NULL,
  nivel_acesso = 0L,
  ...
)
```

## Arguments

- procedimento:

  Id do processo destino.

- arquivo:

  Caminho do arquivo a anexar.

- id_serie:

  Id do tipo de documento (veja
  [`sei_tipos_documento()`](https://distintivelab.github.io/seiapir/reference/sei_tipos_documento.md)).

- data_elaboracao:

  Data do documento (Date ou string DD/MM/AAAA).

- nome_arvore:

  Nome exibido na arvore do processo.

- nivel_acesso:

  0 = publico, 1 = restrito, 2 = sigiloso.

- ...:

  Campos adicionais (ex.: `numero`, `idTipoConferencia`).

## Value

Resposta da API com o documento incluido.
