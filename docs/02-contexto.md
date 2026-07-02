# 02 - Contexto

## Ambiente Tecnológico

O projeto está inserido no ecossistema AWS Serverless, utilizando os principais serviços:

- Amazon S3 (armazenamento de objetos)
- AWS Lambda (processamento serverless)
- AWS IAM (controle de acesso)
- Amazon CloudWatch (observabilidade)
- AWS CloudFormation (Infraestrutura como Código)

## Arquitetura Base

A arquitetura segue o padrão event-driven:

```

S3 (Upload de arquivo) ↓ Event Notification ↓ AWS Lambda ↓ Processamento do arquivo ↓ CloudWatch Logs

```


## Justificativa da Solução

A adoção de uma arquitetura serverless se justifica por:

- Escalabilidade automática
- Baixo custo operacional
- Execução sob demanda
- Redução de infraestrutura gerenciada
- Alta resiliência

## Aplicação Prática

Este modelo é amplamente utilizado em:

- Processamento de dados (Data Engineering)
- Pipelines de ingestão
- Automação de workflows
- Integração entre sistemas distribuídos
  
