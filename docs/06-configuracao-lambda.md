# 06 - Configuração da AWS Lambda

## Objetivo

A AWS Lambda é responsável por executar automaticamente o processamento dos arquivos enviados ao Amazon S3.

O serviço elimina a necessidade de gerenciamento de servidores, permitindo uma arquitetura totalmente serverless.

---

## Responsabilidades da Função

A função Lambda executa as seguintes atividades:

- Receber eventos do Amazon S3
- Identificar o bucket de origem
- Identificar o arquivo enviado
- Ler metadados do objeto
- Registrar logs no CloudWatch
- Retornar informações sobre o processamento

---

## Configuração

A função foi provisionada utilizando CloudFormation com os seguintes parâmetros:

- Runtime Python
- Runtime Node.js (exemplo adicional)
- Arquitetura ARM64
- Timeout configurável
- Memória parametrizada
- Variáveis de ambiente
- X-Ray habilitado

---

## Benefícios

A utilização da Lambda proporciona:

- Escalabilidade automática
- Cobrança apenas durante execução
- Alta disponibilidade
- Integração nativa com Amazon S3

---

## Boas Práticas

- Código desacoplado
- Tratamento de exceções
- Logging estruturado
- Configuração via variáveis de ambiente
- IAM Least Privilege

---

## Resultado

A função processa automaticamente todos os eventos recebidos do Amazon S3, reduzindo atividades manuais e aumentando a eficiência operacional.
