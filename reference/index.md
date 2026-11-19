# Package index

## Configuração e autenticação

Definição da instância do SEI, login e sessão.

- [`sei_configurar()`](https://distintivelab.github.io/seiapir/reference/sei_configurar.md)
  [`sei_sair()`](https://distintivelab.github.io/seiapir/reference/sei_configurar.md)
  : Configura a instância do SEI a ser usada
- [`sei_detectar_api()`](https://distintivelab.github.io/seiapir/reference/sei_detectar_api.md)
  : Detecta se uma instalacao do SEI expoe a API REST (mod-wssei)
- [`sei_autenticar()`](https://distintivelab.github.io/seiapir/reference/sei_autenticar.md)
  : Autentica na API do SEI (mod-wssei)
- [`sei_unidades()`](https://distintivelab.github.io/seiapir/reference/sei_unidades.md)
  : Unidades disponiveis para o usuario autenticado
- [`sei_definir_unidade()`](https://distintivelab.github.io/seiapir/reference/sei_definir_unidade.md)
  : Define a unidade ativa da sessao

## Consulta de processos

Pesquisa, consulta e andamentos.

- [`sei_pesquisar()`](https://distintivelab.github.io/seiapir/reference/sei_pesquisar.md)
  : Pesquisa processos na base do SEI
- [`sei_processo()`](https://distintivelab.github.io/seiapir/reference/sei_processo.md)
  : Consulta um processo pelo numero de protocolo
- [`sei_andamentos()`](https://distintivelab.github.io/seiapir/reference/sei_andamentos.md)
  : Lista andamentos de um processo

## Documentos

Listagem, visualização e download de documentos e anexos.

- [`sei_documentos()`](https://distintivelab.github.io/seiapir/reference/sei_documentos.md)
  : Lista documentos de um processo
- [`sei_documento_visualizar()`](https://distintivelab.github.io/seiapir/reference/sei_documento_visualizar.md)
  : Retorna o conteudo HTML de um documento interno
- [`sei_documento_baixar()`](https://distintivelab.github.io/seiapir/reference/sei_documento_baixar.md)
  : Baixa o anexo de um documento
- [`sei_tipos_documento()`](https://distintivelab.github.io/seiapir/reference/sei_tipos_documento.md)
  : Lista tipos (series) de documento disponiveis

## Criação e tramitação

Criação de processos, inclusão de documentos e trâmite entre unidades.

- [`sei_tipos_processo()`](https://distintivelab.github.io/seiapir/reference/sei_tipos_processo.md)
  : Lista tipos (series) de processo disponiveis
- [`sei_criar_processo()`](https://distintivelab.github.io/seiapir/reference/sei_criar_processo.md)
  : Cria um novo processo
- [`sei_incluir_documento_externo()`](https://distintivelab.github.io/seiapir/reference/sei_incluir_documento_externo.md)
  : Inclui documento externo (arquivo) em um processo
- [`sei_incluir_documento_interno()`](https://distintivelab.github.io/seiapir/reference/sei_incluir_documento_interno.md)
  : Inclui documento interno (gerado pelo editor do SEI) em um processo
- [`sei_enviar_processo()`](https://distintivelab.github.io/seiapir/reference/sei_enviar_processo.md)
  : Envia (tramita) um processo para outras unidades

## Backend web (SIP)

Sessão web para instâncias sem API REST (ex.: SEI GDF).

- [`sei_web_login()`](https://distintivelab.github.io/seiapir/reference/sei_web_login.md)
  : Autentica na sessao web do SEI (fallback para instancias sem API)
