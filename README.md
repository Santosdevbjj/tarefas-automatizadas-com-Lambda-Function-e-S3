## Formação AWS Cloud Foundations.


<img width="105" height="120" alt="1000127839" src="https://github.com/user-attachments/assets/bd433948-7812-4898-8537-22c084ab1465" />


---


<p align="center">
  <img src="https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws" alt="AWS">
  <img src="https://img.shields.io/badge/Amazon-S3-red?logo=amazons3" alt="Amazon S3">
  <img src="https://img.shields.io/badge/AWS-Lambda-FF9900?logo=awslambda" alt="AWS Lambda">
  <img src="https://img.shields.io/badge/Infrastructure_as_Code-CloudFormation-blue" alt="CloudFormation">
  <img src="https://img.shields.io/badge/Monitoring-CloudWatch-yellow" alt="CloudWatch">
  <img src="https://img.shields.io/badge/Security-IAM_Least_Privilege-green" alt="IAM">
  <img src="https://img.shields.io/badge/Python-3.13-blue?logo=python" alt="Python">
  <img src="https://img.shields.io/badge/Runtime_Alt-Node.js-339933?logo=nodedotjs" alt="Node.js">
  <img src="https://img.shields.io/badge/Architecture-ARM64_Graviton-brightgreen" alt="ARM64">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

---


# Automação Serverless de Tarefas com AWS Lambda e Amazon S3

> Arquitetura orientada a eventos, 100% provisionada como código (CloudFormation Nested Stacks), para eliminar processamento manual de arquivos em ambientes AWS.

---

## 1. Problema

Ambientes corporativos que armazenam arquivos no Amazon S3 — documentos, planilhas, logs, imagens — frequentemente dependem de rotinas manuais ou agendadas para processá-los. Esse modelo gera cinco sintomas recorrentes: alto tempo de resposta, custo operacional elevado por manutenção de processos ou servidores ociosos, maior probabilidade de erro humano, dificuldade de escalar quando o volume de arquivos cresce, e ausência de processamento em tempo real.

O problema central não é a falta de armazenamento — é a falta de uma camada de reação automática a eventos de armazenamento, capaz de acionar processamento imediatamente após o upload, sem intervenção humana e sem servidores dedicados.

---

## 2. Contexto

O projeto foi construído dentro do ecossistema **AWS Serverless / Event-Driven Architecture**, no qual serviços gerenciados reagem a mudanças de estado sem que seja necessário provisionar ou operar infraestrutura contínua. O gatilho central é o evento `ObjectCreated` do Amazon S3, que aciona uma função AWS Lambda.

Esse padrão é amplamente aplicado em cenários reais como processamento de documentos, geração de miniaturas de imagem, validação de uploads, ingestão para Data Lakes, pipelines de Machine Learning e automação de processos financeiros — o que torna o laboratório diretamente transferível para arquiteturas corporativas de produção, não apenas um exercício isolado.

---

## 3. Baseline

Antes da automação, o cenário de referência (baseline) é o processamento manual ou por rotina agendada (batch/cron), com as seguintes características mensuráveis:

| Dimensão | Baseline (processo manual/agendado) |
|---|---|
| Latência de processamento | Minutos a horas, dependente de intervenção ou janela de execução agendada |
| Escalabilidade | Limitada pela capacidade de infraestrutura fixa ou pela equipe |
| Custo | Contínuo (servidor ou processo ativo, independente do volume) |
| Rastreabilidade | Manual, sujeita a inconsistência de registro |
| Erro humano | Presente em cada etapa de validação ou disparo manual |

Esse baseline é o ponto de comparação para os resultados apresentados na Seção 8 — a arquitetura proposta precisa superá-lo em latência, custo variável e rastreabilidade para justificar a mudança.

---

## 4. Premissas

- O bucket Amazon S3 é o único ponto de entrada de arquivos processados pela solução.
- O evento `ObjectCreated:*` (Put, Post, Copy, CompleteMultipartUpload) é suficiente para acionar o fluxo — não há necessidade de polling.
- A função Lambda é *stateless*: nenhuma informação de execução é persistida entre invocações.
- O controle de acesso segue o princípio do menor privilégio (Least Privilege) via IAM, escopado ao bucket e ao log group específicos do projeto.
- Todas as execuções são registradas automaticamente no CloudWatch Logs, sem etapa adicional de instrumentação manual.
- A infraestrutura é 100% reproduzível via CloudFormation — nenhum recurso é criado manualmente pelo Console AWS.
- Por se tratar de um laboratório de portfólio, deliberadamente não foram adicionados pipeline de CI/CD, containerização ou suíte de testes automatizados — o deploy é feito via AWS CLI/scripts bash, escopo apropriado para o estágio exploratório do projeto (ver Seção 7).

---

## 5. Estratégia

O desenvolvimento seguiu cinco etapas sequenciais, cada uma validável isoladamente antes de compor o fluxo completo:

1. **Provisionamento da infraestrutura base** — bucket S3, IAM Role, Lambda, CloudWatch Log Group, via CloudFormation.
2. **Configuração do gatilho no S3** — associação dos eventos `ObjectCreated:*` à função Lambda (`configure-notifications.sh`).
3. **Implementação da função de processamento** — lógica de leitura do evento, extração de metadados via `head_object`, e log estruturado (implementada em Python e Node.js).
4. **Habilitação de observabilidade** — CloudWatch Logs com retenção de 30 dias e X-Ray Tracing em modo `Active`.
5. **Validação end-to-end** — upload real de arquivo, verificação do disparo automático e inspeção dos logs gerados (`invoke.sh` para testes manuais sem depender de upload real).

---

## 6. Arquitetura

```
Upload de Arquivo
        │
        ▼
  Amazon S3 (Bucket)
        │
  Evento ObjectCreated
        ▼
  AWS Lambda Function (Python 3.13 / ARM64)
        │
   ┌────┴────┬─────────────┐
   ▼          ▼             ▼
Processamento  CloudWatch   X-Ray
               Logs         Tracing
```

**Componentes e responsabilidades:**

| Serviço | Papel na Arquitetura |
|---|---|
| Amazon S3 | Armazenamento de objetos e emissão do evento `ObjectCreated` |
| AWS Lambda | Execução do processamento, sem servidor dedicado |
| AWS IAM | Autorização escopada por recurso (Least Privilege) |
| Amazon CloudWatch | Logs centralizados e observabilidade de execução |
| AWS X-Ray | Rastreamento distribuído da execução da função |
| AWS CloudFormation | Infraestrutura como Código, orquestrada via Nested Stacks |

A infraestrutura é dividida em **três templates independentes** (`bucket.yaml`, `iam.yaml`, `lambda.yaml`), orquestrados por um `stack.yaml` mestre que os encadeia via `AWS::CloudFormation::Stack` (Nested Stacks), com dependência explícita: bucket → IAM (que consome o nome do bucket) → Lambda (que consome o ARN da role e o bucket de origem do código).

---

## 7. Decisões Técnicas e Trade-offs

**Nested Stacks vs. stack única monolítica.**
A infraestrutura foi dividida em três templates (`bucket`, `iam`, `lambda`) orquestrados por um `stack.yaml` mestre, em vez de um único template. Ganho: cada camada pode ser versionada, testada e reutilizada isoladamente. Custo aceito: necessidade de hospedar os templates em um bucket S3 auxiliar (`TemplateURL`) e gerenciar a ordem de dependência manualmente via `DependsOn`.

**Arquitetura ARM64 (Graviton) como padrão, com x86_64 como opção suportada.**
`Architecture` foi parametrizado no `lambda.yaml`, mas o `Default` é `arm64`. Decisão consciente por menor custo por milissegundo de execução em cargas de I/O leve como esta. Trade-off aceito: caso dependências nativas Python/Node não tenham build ARM64 disponível no futuro, será necessário fallback explícito para `x86_64` — por isso o parâmetro foi mantido configurável, não fixo.

**Runtime duplo (Python 3.13 e Node.js) no mesmo repositório.**
A lógica de negócio foi implementada duas vezes — `lambda/python/lambda_function.py` e `lambda/nodejs/index.js` — mantendo paridade funcional (mesmo contrato de entrada/saída). Custo: dobro de manutenção de lógica equivalente. Ganho: demonstra portabilidade da arquitetura entre runtimes sem depender de característica específica de linguagem, decisão deliberada de portfólio para evidenciar competência poliglota, não apenas domínio de uma stack.

**IAM escopado por recurso, não por serviço.**
As policies do `iam.yaml` não usam `Resource: "*"` para S3 e CloudWatch — o acesso é limitado ao ARN exato do bucket (`AllowReadObjects`, `AllowListBucket`) e ao padrão de nome do log group do próprio projeto (`AllowLogGroupAccess`, escopado a `/aws/lambda/${ProjectName}-${Environment}*`). Trade-off aceito conscientemente: a policy de Parameter Store (`ParameterStorePolicy`) mantém `Resource: "*"` porque é uma extensão opcional e não utilizada no fluxo principal — em um cenário de produção real, esse escopo precisaria ser reduzido antes de habilitar a leitura de SSM.

**Managed Policy do X-Ray em vez de policy inline.**
Optou-se por `arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess` (managed policy da própria AWS) em vez de escrever uma policy inline equivalente. Ganho: menor superfície de manutenção e atualização automática pela AWS. Trade-off: menos controle granular do que uma policy inline estritamente escopada às actions `xray:PutTraceSegments` e `xray:PutTelemetryRecords` — aceitável neste estágio por ser uma managed policy de escopo já restrito a essas duas ações.

**Reserved Concurrency fixado em 10.**
`ReservedConcurrentExecutions: 10` no `lambda.yaml` limita deliberadamente o paralelismo máximo da função. Ganho: protege custo e evita que um pico de uploads simultâneos gere explosão de invocações concorrentes. Trade-off aceito: sob rajadas acima de 10 eventos simultâneos, o excedente é *throttled* pela própria AWS — comportamento aceitável para um laboratório, mas que precisaria ser recalculado com base em SLA real antes de produção.

**Lifecycle Rules no S3 (transição e expiração automática de versões).**
`NoncurrentVersionTransitions` move versões antigas para `STANDARD_IA` aos 30 dias e `NoncurrentVersionExpiration` as remove aos 365 dias. Decisão de custo: evita acúmulo indefinido de versões do bucket versionado sem exigir rotina manual de limpeza.

**Ausência deliberada de CI/CD, Docker e suíte de testes automatizados.**
O deploy é feito via scripts bash (`deploy.sh`, `delete-stack.sh`) chamando AWS CLI diretamente. Essa é uma decisão de escopo, não uma lacuna: para um projeto exploratório de portfólio, adicionar pipeline de CI/CD ou containerização infla a superfície do projeto sem agregar sinal técnico adicional — o valor demonstrado aqui está na modelagem da arquitetura e no IAM, não na automação do próprio processo de deploy.

---

## 8. Resultados

A implementação foi validada com testes práticos de ponta a ponta:

| Teste | Resultado Observado |
|---|---|
| Upload de arquivo no bucket | Evento `ObjectCreated` emitido automaticamente pelo S3 |
| Acionamento da Lambda | Execução automática, sem intervenção manual |
| Processamento do evento | Extração de bucket, key e metadata com sucesso (`status: processed`) |
| Geração de logs | Registro completo no CloudWatch, com retenção de 30 dias |
| Invocação manual de teste | `invoke.sh` reproduz o payload de evento sem depender de upload real |

Frente ao baseline descrito na Seção 3, a arquitetura elimina completamente a etapa de disparo manual — o processamento passa a iniciar em segundos após o upload, com custo proporcional apenas ao volume de eventos processados (modelo *pay-per-use*), e cada execução é rastreável individualmente via CloudWatch e X-Ray.

---

## 9. Impacto / Business Performance

Em termos operacionais, a migração do baseline manual/agendado para a arquitetura event-driven produz três mudanças estruturais mensuráveis:

- **Latência de início de processamento**: de minutos/horas (dependente de janela agendada ou disparo humano) para segundos (reação automática ao evento `ObjectCreated`).
- **Modelo de custo**: de custo fixo/contínuo (infraestrutura sempre ativa) para custo variável por execução (Lambda cobrada por invocação e tempo de execução).
- **Superfície de erro humano**: eliminada na etapa de disparo — o único ponto manual remanescente é o upload inicial do arquivo pelo usuário ou sistema de origem.

Esses mesmos ganhos são diretamente aplicáveis a cenários corporativos reais documentados no projeto: processamento de documentos, geração de miniaturas de imagem, validação de uploads, ingestão para Data Lakes e pipelines de Machine Learning — o que posiciona esta arquitetura como um padrão replicável, e não apenas como exercício isolado de laboratório.

---

## 10. Próximos Passos

- Integrar **Amazon SQS** como buffer de eventos para absorver picos acima do `ReservedConcurrentExecutions` atual.
- Adicionar **Amazon SNS** para notificação assíncrona de conclusão de processamento.
- Persistir metadados processados em **Amazon DynamoDB**, hoje apenas registrados em log.
- Migrar orquestração de fluxos multi-etapa para **AWS Step Functions**, quando a lógica de negócio deixar de ser uma única função.
- Expor a solução externamente via **Amazon API Gateway**, para cenários que exijam disparo por API além de evento S3.
- Adicionar **CloudWatch Alarms** sobre taxa de erro, throttling e duração de execução.
- Reduzir o escopo `Resource: "*"` da `ParameterStorePolicy` antes de qualquer uso em produção.
- Automatizar o deploy via **GitHub Actions**, uma vez que o projeto evolua de laboratório para serviço com múltiplos ambientes ativos.

---

## Como Executar

**Pré-requisitos:** conta AWS ativa, AWS CLI configurada, Git, Python 3.13 (opcional para desenvolvimento local).

```bash
# 1. Clonar o repositório
git clone https://github.com/Santosdevbjj/tarefas-automatizadas-com-Lambda-Function-e-S3.git
cd tarefas-automatizadas-com-Lambda-Function-e-S3

# 2. Deploy da infraestrutura (Nested Stacks via CloudFormation)
./scripts/deploy.sh

# 3. Associar o gatilho S3 → Lambda
./scripts/configure-notifications.sh

# 4. Testar sem upload real (payload simulado)
./scripts/invoke.sh

# 5. Remover toda a infraestrutura
./scripts/delete-stack.sh
```

---

## Estrutura do Repositório

```
tarefas-automatizadas-com-Lambda-Function-e-S3
├── cloudformation/        # bucket.yaml, iam.yaml, lambda.yaml, stack.yaml (Nested Stacks)
├── lambda/
│   ├── python/            # lambda_function.py (runtime principal)
│   └── nodejs/            # index.js (runtime alternativo)
├── policies/              # policies IAM em JSON, referência standalone
├── scripts/                # deploy.sh, delete-stack.sh, configure-notifications.sh, invoke.sh
├── examples/               # evento.json e payload de teste
└── docs/                   # documentação técnica detalhada por tópico
```

---

## 👤 Autor

**Sérgio Santos** — Systems Analyst | Cloud & AI Solutions | DIO Campus Expert

15+ anos em sistemas bancários de missão crítica

[![Portfólio](https://img.shields.io/badge/Portfólio-Sérgio_Santos-111827?style=for-the-badge&logo=githubpages&logoColor=00eaff)](https://portfoliosantossergio.vercel.app)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Sérgio_Santos-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/santossergioluiz)

---

