# 11 - Testes da Solução

## Objetivo

Garantir que todos os componentes da arquitetura funcionem corretamente de forma integrada.

---

## Cenários Testados

### Upload de Arquivos

Validação do acionamento automático da Lambda após upload no Amazon S3.

---

### Processamento

Verificação da leitura das informações do objeto.

---

### Logs

Validação dos registros gerados no Amazon CloudWatch.

---

### Permissões

Confirmação do correto funcionamento das políticas IAM.

---

### Invocação Manual

Utilização do script:

invoke.sh

para simular eventos durante o desenvolvimento.

---

## Evidências Esperadas

- Execução da Lambda
- Registro dos logs
- Evento recebido
- Processamento concluído
- Retorno HTTP 200

---

## Resultado

Todos os testes validam o correto funcionamento da arquitetura serverless implementada.
