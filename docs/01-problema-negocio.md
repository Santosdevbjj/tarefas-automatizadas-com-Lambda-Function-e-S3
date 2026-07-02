# 01 - Problema de Negócio

## Contexto do Problema

Em ambientes modernos de Cloud Computing, aplicações precisam responder a eventos em tempo real de forma escalável, desacoplada e resiliente.

No cenário deste projeto, existe a necessidade de processar automaticamente arquivos enviados para um bucket Amazon S3, eliminando a dependência de intervenções manuais.

## Problema Central

Atualmente, o processamento de arquivos enviados ao S3 pode ser:

- Manual
- Descentralizado
- Não rastreável
- Sem automação de resposta

Isso gera problemas como:

- Baixa escalabilidade operacional
- Alto risco de erro humano
- Atraso no processamento de dados
- Falta de padronização na execução de tarefas

## Objetivo do Projeto

Criar uma arquitetura serverless na AWS capaz de:

- Detectar uploads no Amazon S3
- Acionar automaticamente funções AWS Lambda
- Processar eventos de forma automatizada
- Garantir rastreabilidade e observabilidade

## Resultado Esperado

Uma solução totalmente automatizada, baseada em eventos, que elimina intervenção manual e garante processamento imediato de arquivos enviados ao S3.
