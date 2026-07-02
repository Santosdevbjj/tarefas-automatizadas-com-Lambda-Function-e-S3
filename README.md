## Executando Tarefas Automatizadas com AWS Lambda Function e Amazon S3


<p align="center">
<img src="./assets/banner.png" alt="AWS Lambda e Amazon S3">
</p><p align="center">"AWS" (https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
"Amazon S3" (https://img.shields.io/badge/Amazon-S3-red?logo=amazons3)
"AWS Lambda" (https://img.shields.io/badge/AWS-Lambda-FF9900?logo=awslambda)
"CloudFormation" (https://img.shields.io/badge/Infrastructure_as_Code-CloudFormation-blue)
"CloudWatch" (https://img.shields.io/badge/Monitoring-CloudWatch-yellow)
"IAM" (https://img.shields.io/badge/Security-IAM-green)
"Python" (https://img.shields.io/badge/Python-3.x-blue?logo=python)
"License" (https://img.shields.io/badge/License-MIT-green)

</p>---

---

## Visão Geral

Empresas processam diariamente milhares de arquivos armazenados em serviços de armazenamento em nuvem. Em muitos cenários, atividades como validação, organização, transformação de dados, geração de relatórios e envio de notificações ainda dependem de processos manuais, aumentando o tempo de resposta, os custos operacionais e a possibilidade de falhas humanas.

A computação Serverless permite substituir essas tarefas repetitivas por fluxos totalmente automatizados, nos quais eventos gerados pelo armazenamento de arquivos acionam funções responsáveis por executar o processamento necessário sem intervenção humana.

Neste projeto é apresentada a construção de uma arquitetura orientada a eventos utilizando Amazon S3, AWS Lambda, AWS IAM, Amazon CloudWatch e AWS CloudFormation, demonstrando como automatizar tarefas de forma segura, escalável e alinhada às boas práticas da Amazon Web Services.

Além da implementação técnica, este repositório foi elaborado como material de estudo e portfólio profissional, documentando desde o problema de negócio até a arquitetura da solução, as decisões técnicas adotadas e os principais aprendizados obtidos durante o laboratório.

---

## Problema de Negócio

Organizações de diferentes segmentos armazenam continuamente documentos, imagens, planilhas, arquivos de log e diversos outros tipos de objetos em buckets do Amazon S3.

Em muitos ambientes corporativos, o processamento desses arquivos ainda ocorre manualmente ou depende de rotinas agendadas, resultando em desafios como:

- Alto tempo de processamento;
- Custos operacionais elevados;
- Maior probabilidade de erros humanos;
- Dificuldade para escalar a solução;
- Ausência de processamento em tempo real;
- Baixa produtividade das equipes.

À medida que o volume de arquivos cresce, essas limitações tornam-se ainda mais evidentes, comprometendo a eficiência operacional e dificultando a evolução da infraestrutura.

Surge então a necessidade de uma arquitetura capaz de responder automaticamente aos eventos gerados durante o armazenamento de novos arquivos, executando tarefas de maneira rápida, segura e altamente escalável.

---

## Contexto

A arquitetura Serverless da AWS oferece um modelo baseado em eventos (Event-Driven Architecture), no qual serviços gerenciados reagem automaticamente às alterações ocorridas no ambiente.

Neste laboratório, sempre que um novo objeto é enviado para um bucket do Amazon S3, um evento é gerado automaticamente.

Esse evento aciona uma função AWS Lambda responsável por executar uma tarefa previamente definida, como:

- validar arquivos enviados;
- transformar conteúdos;
- gerar logs;
- organizar objetos;
- atualizar metadados;
- iniciar novos fluxos automatizados.

Todo esse processo ocorre sem a necessidade de provisionar ou administrar servidores, permitindo que a infraestrutura escale automaticamente conforme a demanda.

Essa abordagem reduz significativamente o esforço operacional e representa um dos principais pilares da computação moderna em nuvem.

---

## Objetivos do Projeto

Este projeto foi desenvolvido com os seguintes objetivos:

- compreender o funcionamento da arquitetura Serverless da AWS;
- automatizar tarefas utilizando eventos do Amazon S3;
- implementar funções utilizando AWS Lambda;
- compreender o fluxo de processamento orientado a eventos;
- aplicar boas práticas de segurança utilizando AWS IAM;
- monitorar execuções por meio do Amazon CloudWatch;
- documentar todo o processo de implementação de forma profissional;
- consolidar conhecimentos em computação em nuvem utilizando serviços gerenciados da AWS.

Além dos objetivos técnicos, este repositório busca demonstrar como arquiteturas orientadas a eventos podem transformar processos operacionais tradicionais em soluções modernas, escaláveis e de baixa manutenção.

---



## Arquitetura da Solução

A solução foi projetada utilizando uma arquitetura Serverless orientada a eventos (Event-Driven Architecture), na qual o armazenamento de um novo objeto no Amazon S3 atua como gatilho para a execução automática de uma função AWS Lambda.

Essa abordagem elimina a necessidade de provisionamento de servidores, reduz a complexidade operacional e permite que a aplicação escale automaticamente de acordo com a demanda.

O fluxo foi desenvolvido utilizando serviços gerenciados da AWS, seguindo princípios de alta disponibilidade, segurança, escalabilidade e pagamento sob demanda (Pay as You Go).

## Diagrama da Arquitetura

«O diagrama abaixo representa o fluxo lógico da solução implementada neste laboratório.»

<p align="center">
<img src="./assets/arquitetura.png" alt="Arquitetura Serverless AWS">
</p>  


                  Upload de Arquivo

                           │
                           ▼

                 Amazon S3 (Bucket)

                           │
               Evento ObjectCreated

                           ▼

                 AWS Lambda Function

                           │

        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼

  Processamento      CloudWatch Logs     Metadados

                           │

                           ▼

                 Resultado da Automação




---



## Fluxo da Solução

O funcionamento da arquitetura ocorre em cinco etapas principais.

1. Upload do arquivo

Um usuário, aplicação ou serviço realiza o envio de um arquivo para um bucket do Amazon S3.

O bucket funciona como ponto central de armazenamento dos objetos.

---

## 2. Geração do evento

Após a conclusão do upload, o Amazon S3 gera automaticamente um evento do tipo ObjectCreated.

## Esse evento contém informações importantes, como:

- nome do bucket;
- chave (Key) do objeto;
- horário do upload;
- região;
- informações da requisição.

---

## 3. Acionamento da função Lambda

O evento é encaminhado automaticamente para uma função AWS Lambda previamente configurada.

Não existe necessidade de servidores dedicados ou processos de monitoramento contínuo.

A própria infraestrutura da AWS realiza o disparo da execução.

---

## 4. Processamento automático

Durante sua execução, a função Lambda pode realizar diversas operações, como:

- validar arquivos;
- organizar objetos;
- converter formatos;
- gerar miniaturas de imagens;
- atualizar metadados;
- registrar informações em logs;
- integrar outros serviços da AWS;
- iniciar novos fluxos automatizados.

Neste laboratório foi implementado um fluxo de processamento automatizado demonstrando como eventos do Amazon S3 podem iniciar funções de forma totalmente transparente para o usuário.

---

## 5. Monitoramento

Todas as execuções da função Lambda podem ser monitoradas pelo Amazon CloudWatch.

## Os logs permitem acompanhar:

- início da execução;
- tempo de processamento;
- mensagens de depuração;
- erros encontrados;
- consumo de recursos.

Esse monitoramento facilita a identificação de problemas e auxilia na evolução da solução.

---

## Serviços AWS Utilizados

A arquitetura faz uso dos seguintes serviços da Amazon Web Services.

Serviço| Finalidade
Amazon S3| Armazenamento de objetos e geração de eventos
AWS Lambda| Execução automática do processamento
AWS IAM| Controle de acesso e permissões
Amazon CloudWatch| Monitoramento, métricas e logs
AWS CloudFormation| Provisionamento automatizado da infraestrutura

Cada serviço desempenha um papel específico dentro da arquitetura, permitindo que a solução permaneça desacoplada, escalável e de fácil manutenção.

---

## Tecnologias Utilizadas

Durante o desenvolvimento deste laboratório foram utilizados os seguintes recursos tecnológicos:

- Amazon Web Services (AWS)
- Amazon S3
- AWS Lambda
- AWS Identity and Access Management (IAM)
- Amazon CloudWatch
- AWS CloudFormation
- Python 3.x
- AWS CLI
- JSON
- YAML
- Git
- GitHub

---

## Decisões Técnicas

Durante o desenvolvimento da solução foram adotadas algumas decisões visando simplicidade, escalabilidade e alinhamento às boas práticas da AWS.

Arquitetura Serverless

A utilização do AWS Lambda elimina a necessidade de administrar servidores, reduzindo custos operacionais e simplificando a manutenção da infraestrutura.

---

## Arquitetura Orientada a Eventos

O Amazon S3 foi configurado para disparar automaticamente eventos de criação de objetos, permitindo que o processamento ocorra apenas quando necessário.

Essa estratégia reduz consumo de recursos e melhora a eficiência da aplicação.

---

## Infraestrutura como Código (IaC)

Sempre que possível, os recursos são provisionados utilizando templates do AWS CloudFormation.

## Essa abordagem proporciona:

- padronização da infraestrutura;
- reprodutibilidade dos ambientes;
- versionamento das configurações;
- redução de erros humanos;
- facilidade de manutenção.

---

## Princípio do Menor Privilégio

As permissões concedidas à função Lambda seguem o princípio de Least Privilege, garantindo que a aplicação possua apenas os acessos estritamente necessários para sua execução.

Essa prática reduz riscos de segurança e está alinhada às recomendações da AWS Well-Architected Framework.

---

## Benefícios da Arquitetura

A arquitetura implementada oferece diversas vantagens quando comparada a soluções tradicionais baseadas em servidores permanentes.

## Entre os principais benefícios destacam-se:

- processamento totalmente automático;
- escalabilidade nativa;
- redução de custos operacionais;
- cobrança baseada apenas no consumo;
- alta disponibilidade;
- facilidade de manutenção;
- integração com diversos serviços AWS;
- menor esforço administrativo;
- maior produtividade operacional;
- arquitetura moderna baseada em eventos.

Essas características fazem do modelo Serverless uma excelente alternativa para aplicações que precisam responder rapidamente a eventos gerados em ambientes de nuvem.



---


