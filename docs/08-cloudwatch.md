# 08 - Amazon CloudWatch

## Objetivo

O Amazon CloudWatch fornece observabilidade para toda a arquitetura.

Todos os eventos processados pela Lambda são registrados automaticamente.

---

## Logs

Cada execução gera informações como:

- Nome do bucket
- Nome do arquivo
- Horário da execução
- Status do processamento
- Mensagens de erro

---

## Monitoramento

A solução permite acompanhar:

- Número de execuções
- Tempo de processamento
- Erros
- Falhas
- Performance

---

## Alarmes

O projeto pode ser expandido para utilizar alarmes como:

- Erros da Lambda
- Timeout
- Alta taxa de falhas
- Número elevado de invocações

---

## Benefícios

- Observabilidade completa
- Diagnóstico rápido
- Auditoria
- Troubleshooting

---

## Boas Práticas

- Logs estruturados
- Mensagens descritivas
- Tratamento de exceções
- Monitoramento contínuo
