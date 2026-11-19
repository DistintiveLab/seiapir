# seiapir

Cliente R para o SEI (Sistema Eletrônico de Informações): pesquisa
processos, obtém documentos e inclui processos e documentos em
instâncias que expõem o módulo REST
[mod-wssei](https://github.com/pengovbr/mod-wssei), com fallback de
sessão web (SIP) para instâncias sem API.

## Instalação

``` r

# install.packages("pak")
pak::pak("distintivelab/seiapir")
```

## Uso

### Backend API (mod-wssei) — ex.: SEI do Ministério do Trabalho

``` r

library(seiapir)

sei_detectar_api("https://processoeletronico.trabalho.gov.br")  # 401 => API disponível
sei_configurar("https://processoeletronico.trabalho.gov.br", orgao = 3)  # id do órgão MTE
sei_autenticar("sua.sigla")          # senha via askpass/SEI_SENHA

# No MTE a sigla é a parte local do e-mail institucional (ex.: nome.sobrenome)
# e o id do órgão aparece no formulário de login do SIP (MTE = 3).

sei_pesquisar(palavrasChave = "licitação", dataInicio = "01/01/2026")
sei_processo("99999.000000/2026-00")
sei_documentos(id_procedimento)       # idProcedimento retornado por sei_processo()
sei_documento_baixar(id_documento, "arquivo.pdf")  # campo `id` de sei_documentos()

sei_criar_processo(tipo = 100000350, especificacao = "Processo de teste")
sei_incluir_documento_externo(procedimento, "relatorio.pdf", id_serie = 46)
```

### Backend web (fallback) — ex.: SEI do GDF (sem mod-wssei público)

``` r

sess <- sei_web_login("https://sei.df.gov.br", usuario = "sua.sigla", sigla_orgao = "GDF")
```

## Autenticação

- [`sei_autenticar()`](https://distintivelab.github.io/seiapir/reference/sei_autenticar.md)
  aceita a senha por argumento, pela variável de ambiente `SEI_SENHA`
  ou, de forma interativa, via `askpass`.
- O token de sessão fica em memória apenas (nunca em disco/histórico).

## Status

| Instância testada | API REST |
|----|----|
| <https://processoeletronico.trabalho.gov.br> | disponível (v2; validada em 2026-11: SEI 5.0.4, wssei 3.0.3) |
| <https://sei.df.gov.br> | não exposta publicamente — usar backend web |

## Licença

MIT © Rodrigo Borges
