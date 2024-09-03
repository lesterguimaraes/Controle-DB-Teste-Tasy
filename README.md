## Controle DB Teste - Tasy
![Badge Desenvolvido](http://img.shields.io/static/v1?label=STATUS&message=EM%20DESENVOLVIMENTO&color=GREEN&style=for-the-badge)
![GitHub Org's stars](https://img.shields.io/github/stars/lesterguimaraes?style=social)

#### 📋Descrição
Esse projeto destina-se a realziar o controle de acesso ao banco de dados de treinamento/teste da instituição, de forma automatizada, sempre que este passa pelo processo de replicate do PDB Tasy para o PDB Tasy_Teste. A atividade é executada via execução planejada de uma job executando a procedue que contem as instruções.

### 🛠️ Pré-requisitos
- Acesso de leitura e escrita ao Banco de Dados.
- Editor de código de sua preferência. (Oracle SQL Developer | VS Code)

### 📘 Documentação

A Procedure HBM_CONTROLE_TASY_TESTE irá realizar as alterações via update e insert utilizando validação  do banco de dados via nome. 

Funcionalidades:
- Realizando o bloqueio dos usuários que não possuem acesso ao perfil de administração do sistema.
- Alteração da cor da barra de status do sistema na versão Delphi.
- Alteração da aplicação de Produção para Treinamento, visível no sistema HTML5.
- Desbloqueio de usuários chaves que devem ter acesso a esta base de treinamento.


A Job JOB_HBM_CONTROLE_TASY_TESTE é um recurso disponível no Oracle para agendamento de tarefas, a criação desta job serve para agendar a execução da procedue HBM_CONTROLE_TASY_TESTE.

 ### ⚠️ Atenção
 Qualquer implementação realize primeiramente sempre em base de homologação, nunca em produção.

### 🚀 Começando
 1 - Conecte ao seu banco de dados com a ferramenta de administração de sua preferência.

 2 - Edite o arquivo HBM_CONTROLE_TASY_TESTE de cordo com as necessidades.

 3 - Execute a procedure HBM_CONTROLE_TASY_TESTE para que a mesma seja adicionada ao banco. Deve retornar o comando "Procedure HBM_CONTROLE_TASY_TESTE compilado".

 4 - Execute o comando exec HBM_CONTROLE_TASY_TESTE para rodar a procedue de forma manual. Deve retornar o comando "Procedimento PL/SQL concluído com sucesso.", informando que as alterações propostas no script foram efetuadas.

 5 - Realize a validação da execução, se as atividades propsotas no script foram realizadas.

 6 - Edite o arquivo JOB_HBM_CONTROLE_TASY_TESTE de acordo com o dia e horário de execução da atividade. No caso utilizado a job será executada as 7h da manhã com data fixa sendo a data atual mais 7 dias. TRUNC(SYSDATE + 7) + 7/24

 7 - Execute a Job JOB_HBM_CONTROLE_TASY_TESTE para que o agendamento seja agendado.


### 📕 Arquivos
| Nome | Tipo|
|--------|-------|
| HBM_CONTROLE_TASY_TESTE.sql | Procedure
| JOB_HBM_CONTROLE_TASY_TESTE.sql | Job


### 📄 Licença
Esse projeto está sob a [licença MIT](https://www.mit.edu/~amini/LICENSE.md), fique a vontade para criar seu fork.

### 🔗 Redes
[Linkedin](https://www.linkedin.com/in/lesterguimaraes/)
[Instagram](https://www.instagram.com/lesterguimaraes/)