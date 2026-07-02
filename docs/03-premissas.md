# 03 - Premissas

## Premissas Técnicas

Para o desenvolvimento da solução, foram consideradas as seguintes premissas:

- O Amazon S3 é o ponto central de entrada de dados
- Eventos do tipo `ObjectCreated` são suficientes para acionar o fluxo
- AWS Lambda será executado sob modelo event-driven
- A infraestrutura será gerenciada via CloudFormation
- Logs serão armazenados no CloudWatch

## Premissas de Segurança

- O princípio de menor privilégio (Least Privilege) é aplicado no IAM
- A Lambda possui acesso restrito apenas aos recursos necessários
- Nenhuma credencial sensível é armazenada no código

## Premissas Operacionais

- O ambiente pode ser replicado em múltiplos estágios (dev, homolog, prod)
- A execução da Lambda é stateless
- O volume de eventos é variável e imprevisível

## Premissas de Dados

- Os arquivos enviados ao S3 são considerados confiáveis na origem
- O formato dos eventos segue o padrão AWS S3 Event Notification
