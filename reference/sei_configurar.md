# Configura a instância do SEI a ser usada

Define a URL da instalação (ex.:
`https://processoeletronico.trabalho.gov.br`) e o id numérico do órgão
usado na autenticação (o valor aparece no QRCode "Configurações do
Aplicativo" no menu lateral do SEI web; `0` funciona no MTE).

## Usage

``` r
sei_configurar(url, orgao = 0, contexto = NULL)

sei_sair()
```

## Arguments

- url:

  URL raiz da instalação do SEI (sem `/sei`).

- orgao:

  Id numérico do órgão para autenticação.

- contexto:

  Id do contexto (opcional; raramente usado).

## Value

Invisivelmente, a configuração atual.
