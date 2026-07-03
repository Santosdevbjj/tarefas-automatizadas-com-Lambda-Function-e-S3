# 07 - Configuração do Event Notification

## Objetivo

O Amazon S3 Event Notification permite que eventos ocorridos no bucket sejam enviados automaticamente para outros serviços AWS.

Neste projeto, o destino escolhido é a AWS Lambda.

---

## Fluxo da Solução

```
Upload de Arquivo
        │
        ▼
Amazon S3
        │
ObjectCreated
        ▼
AWS Lambda
        │
Processamento
        ▼
CloudWatch Logs
```

---

## Evento Configurado

Evento monitorado:

- ObjectCreated:*

Ou seja, qualquer criação de objeto dispara automaticamente a função Lambda.

---

## Configuração

A configuração é realizada automaticamente utilizando:

- AWS CLI
- CloudFormation
- Script configure-notifications.sh

Também é possível remover a configuração utilizando:

- remove-notifications.sh

---

## Benefícios

- Processamento em tempo real
- Baixa latência
- Arquitetura desacoplada
- Alta escalabilidade

---

## Casos de Uso

Esse padrão é amplamente utilizado para:

- Processamento de imagens
- ETL
- Data Lakes
- Data Engineering
- Inteligência Artificial
- Arquivamento automático
