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

A solução proposta utiliza uma arquitetura totalmente Serverless baseada em eventos.

Sempre que um arquivo é enviado ao bucket do Amazon S3, um evento ObjectCreated é gerado automaticamente.

Esse evento dispara uma função AWS Lambda responsável pelo processamento do objeto. Durante sua execução, a função pode validar informações, transformar arquivos, registrar logs no Amazon CloudWatch, atualizar metadados ou executar qualquer outra regra de negócio implementada.

Todo o fluxo ocorre de maneira automática, sem necessidade de servidores dedicados, reduzindo custos operacionais e aumentando a escalabilidade da solução.

Nos próximos tópicos serão apresentados a arquitetura completa, os serviços utilizados, os templates de infraestrutura, o código da função Lambda, as configurações de segurança, o monitoramento da solução e os resultados obtidos durante a implementação do laboratório.
