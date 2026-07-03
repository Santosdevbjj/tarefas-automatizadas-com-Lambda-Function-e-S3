# 10 - Deploy da Solução

## Objetivo

Todo o provisionamento da infraestrutura é realizado utilizando Infrastructure as Code (IaC) através do AWS CloudFormation.

Dessa forma, o ambiente pode ser criado novamente sempre que necessário, garantindo padronização, reprodutibilidade e redução de erros manuais.

---

## Componentes Implantados

Durante o processo de deploy são criados automaticamente:

- Amazon S3 Bucket
- AWS Lambda
- IAM Role
- IAM Policies
- CloudWatch Log Group
- Permissões de execução
- Configurações de integração

---

## Fluxo de Implantação

```text
CloudFormation Stack
        │
        ▼
Provisionamento da Infraestrutura
        │
        ▼
IAM
        │
        ├────────► Amazon S3
        │
        ├────────► AWS Lambda
        │
        └────────► CloudWatch
```

---

## Automação

O projeto possui scripts responsáveis por automatizar todas as etapas:

- deploy.sh
- delete-stack.sh
- configure-notifications.sh
- remove-notifications.sh
- invoke.sh

---

## Benefícios

A automação do deploy proporciona:

- Reprodutibilidade
- Menor risco operacional
- Rapidez na implantação
- Versionamento da infraestrutura
- Facilidade para múltiplos ambientes

---

## Resultado

A infraestrutura pode ser criada ou removida em poucos minutos utilizando apenas comandos automatizados.
