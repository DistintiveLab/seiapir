# Envia (tramita) um processo para outras unidades

Wrapper de `POST /processo/enviar`.

## Usage

``` r
sei_enviar_processo(
  numero_processo,
  unidades_destino,
  manter_aberto = "S",
  ...
)
```

## Arguments

- numero_processo:

  Numero do processo (protocolo).

- unidades_destino:

  Ids das unidades destino (vetor).

- manter_aberto:

  Manter processo aberto na unidade atual ("S"/"N").

- ...:

  Campos adicionais (ex.: `sinReabrir`, `diasRetornoProgramado`).

## Value

Resposta da API.
