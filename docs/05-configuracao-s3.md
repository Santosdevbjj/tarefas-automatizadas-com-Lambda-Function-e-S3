# 05 - Configuração do Amazon S3

## Objetivo

O Amazon S3 é responsável por armazenar os arquivos enviados pelos usuários e iniciar automaticamente o fluxo de processamento por meio de eventos.

Neste projeto, o bucket representa o ponto de entrada da arquitetura serverless.

---

## Papel do S3 na Arquitetura

```
Usuário
    │
    ▼
Amazon S3
    │
ObjectCreated
    ▼
AWS Lambda
```

---

## Configuração Implementada

O bucket foi criado utilizando AWS CloudFormation, garantindo:

- Infraestrutura reproduzível
- Versionamento da configuração
- Padronização entre ambientes
- Automação do provisionamento

Foram habilitados recursos importantes como:

- Versionamento de objetos
- Criptografia padrão (SSE-S3)
- Bloqueio de acesso público
- Tags de identificação
- Integração com AWS Lambda

---

## Benefícios

A utilização do Amazon S3 oferece:

- Alta disponibilidade
- Escalabilidade automática
- Durabilidade de 99,999999999%
- Integração nativa com diversos serviços AWS

---

## Boas Práticas Aplicadas

- Princípio de menor exposição pública
- Versionamento habilitado
- Criptografia em repouso
- Infraestrutura como Código (IaC)
- Configuração automatizada via CloudFormation

---

## Resultado

O bucket torna-se o ponto central de entrada de arquivos da solução, iniciando automaticamente o processamento sem necessidade de intervenção manual.
