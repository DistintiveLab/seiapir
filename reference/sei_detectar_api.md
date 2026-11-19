# Detecta se uma instalacao do SEI expoe a API REST (mod-wssei)

Sonda `GET /api/v2/versao`: resposta 401 indica modulo presente e
exigindo token; 404 indica modulo ausente naquela URL (fallback: backend
web).

## Usage

``` r
sei_detectar_api(url)
```

## Arguments

- url:

  URL raiz da instalacao do SEI.

## Value

Lista com `api_disponivel` (logical) e `status` (codigo HTTP).
