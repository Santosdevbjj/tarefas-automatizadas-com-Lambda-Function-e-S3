# 09 - Segurança

## Objetivo

A segurança foi considerada desde o início do projeto, seguindo as recomendações da AWS Well-Architected Framework.

---

## IAM

Todas as permissões seguem o princípio de menor privilégio (Least Privilege).

A função Lambda possui acesso apenas aos recursos necessários para:

- Ler objetos do S3
- Escrever logs no CloudWatch
- Enviar dados ao X-Ray

---

## Amazon S3

O bucket foi configurado com:

- Bloqueio de acesso público
- Criptografia padrão
- Versionamento
- Controle de acesso via IAM

---

## Lambda

A função utiliza:

- IAM Role dedicada
- Variáveis de ambiente
- Sem armazenamento de credenciais

---

## CloudFormation

Toda a infraestrutura é criada automaticamente.

Benefícios:

- Padronização
- Auditoria
- Reprodutibilidade
- Versionamento

---

## Credenciais

Nenhuma credencial é armazenada no código-fonte.

As permissões são obtidas através de:

- IAM Role
- AWS CLI
- Credenciais temporárias

---

## Boas Práticas Aplicadas

- Least Privilege
- Infrastructure as Code
- Versionamento
- Criptografia
- Observabilidade
- Automação

---

## Resultado

A arquitetura apresenta uma postura de segurança alinhada às boas práticas da AWS, reduzindo riscos operacionais, evitando exposição desnecessária de recursos e facilitando auditorias futuras.
