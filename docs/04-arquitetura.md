# 04 - Arquitetura da Solução

## Visão Geral

A solução implementa uma arquitetura serverless baseada em eventos na AWS, utilizando S3 como ponto de entrada e Lambda como motor de processamento.

---

## Arquitetura Lógica

```

            +----------------------+
            |      Usuário         |
            +----------+-----------+
                       |
                       v
            +----------------------+
            |   Amazon S3 Bucket   |
            | (Upload de arquivos) |
            +----------+-----------+
                       |
                       v
    +--------------------------------------+
    |  S3 Event Notification (ObjectCreated)|
    +------------------+-------------------+
                       |
                       v
            +----------------------+
            |   AWS Lambda        |
            | (Python / Node.js)  |
            +----------+-----------+
                       |
                       v
            +----------------------+
            |   CloudWatch Logs   |
            +----------------------+ 





      ```
      
---

## Componentes da Arquitetura

### Amazon S3
Responsável por armazenar os arquivos enviados e gerar eventos de notificação.

### AWS Lambda
Executa o processamento automático dos arquivos de forma serverless.

### IAM
Controla permissões com base no princípio de menor privilégio.

### CloudWatch
Responsável por logs, observabilidade e monitoramento.

### CloudFormation
Gerencia toda a infraestrutura como código (IaC).

---

## Características da Solução

- Event-driven architecture
- Fully serverless
- Stateless processing
- Horizontal scalability
- Infrastructure as Code

---

## Benefícios Arquiteturais

- Baixo custo operacional
- Alta escalabilidade automática
- Eliminação de infraestrutura manual
- Facilidade de manutenção
- Resiliência nativa AWS

---

## Evolução Futura

A arquitetura pode ser expandida para incluir:

- Amazon SQS (buffer de eventos)
- Step Functions (orquestração)
- DynamoDB (persistência)
- EventBridge (roteamento avançado)
- API Gateway (entrada externa)

- 
            
