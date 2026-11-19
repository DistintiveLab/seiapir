# Pesquisa processos na base do SEI

Wrapper de `GET /processo/pesquisar`. Use `palavrasChave` (busca
completa, estilo SOLR) ou `buscaRapida` (protocolo/interessado). Combine
`dataInicio` e `dataFim` (formato DD/MM/AAAA) com `staTipoData`.

## Usage

``` r
sei_pesquisar(
  palavrasChave = NULL,
  buscaRapida = NULL,
  descricao = NULL,
  dataInicio = NULL,
  dataFim = NULL,
  staTipoData = NULL,
  idUnidadeGeradora = NULL,
  idAssunto = NULL,
  limit = 50L,
  start = 0L,
  ...
)
```

## Arguments

- palavrasChave:

  Palavras-chave para pesquisa textual.

- buscaRapida:

  Termo de busca rapida (ex.: numero do processo).

- descricao:

  Filtro por descricao do processo.

- dataInicio, dataFim:

  Datas no formato DD/MM/AAAA.

- staTipoData:

  Tipo de filtro por data (ver swagger).

- idUnidadeGeradora:

  Id da unidade geradora.

- idAssunto:

  Id do assunto.

- limit, start:

  Paginacao (registros por pagina / offset).

- ...:

  Parametros adicionais repassados como query string.

## Value

Resposta da API (lista; resultados em `data`).
