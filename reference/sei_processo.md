# Consulta um processo pelo numero de protocolo

Usa `GET /processo/consultar` (parametro `protocoloFormatado`), pois o
formato `99999.999999/9999-99` contem `/` e nao cabe como segmento de
path.

## Usage

``` r
sei_processo(protocolo)
```

## Arguments

- protocolo:

  Numero no formato 99999.999999/9999-99.

## Value

data.frame de uma linha com `id`, `protocolo` e `tipo` do processo.
