create or replace procedure HBM_CONTROLE_TASY_TESTE is

/*
Desenvolvido esta procedura para alterar a cor do estabelecimento no delhpi, mudar a aplica��o para Treinamento (uso no HTML5) e deletar a JOB de envio de CI/e-mail da fun��o gest�o da qualidade.
Documentada na OS 1770
Autor: Lester Gomes Guimar�es
Data: 12/08/2024
*/

resultado_w     varchar2(255);
job_w           number(15);

cursor c1 is

select  sys_context('USERENV','DB_NAME')
into    resultado_w /*Retorna o nome da base teste*/
from    dual
where   sys_context('USERENV', 'DB_NAME') = 'TASY_TESTE'
and     1 =    (select 1
                from  aplicacao_tasy
                where cd_aplicacao_tasy = 'Tasy'
                );
/*No cursos 1 se faz necess�rio validar a base na qual ser� executada as altera��es. Como � um �nico servidor f�sico com dois PDBs, a diferencia��o se faz pelo db_name*/

begin

    open c1;
    loop
    fetch c1 into
    resultado_w;
    exit when c1%notfound;
        /*Inseri colora��o na barra de status do Tasy Deplhi para silaizar que se trata da base de testes / homolo�ga��o*/
        insert into tasy_padrao_cor_perfil (nr_sequencia,cd_estabelecimento,cd_perfil,nr_seq_padrao,dt_atualizacao,nm_usuario,ds_cor_fundo) values ((select max(nr_sequencia)+1 from tasy_padrao_cor_perfil), 1, null, 17, sysdate, 'lester','$00404080');
        
        /*Update para mudar a aplica��o de (P) Produ��o para (E) Treinamento. Fun��o: Administra��o do Sistema / Aplica��o */
        update  aplicacao_tasy set ie_banco = 'E' where cd_aplicacao_tasy = 'Tasy';

        /*Update para cancelar o envio de e-mail quando houver redefini��o de senha do login. Fun��o: Administra��o do Sistema / Par�metros, aplica��o principal, administra��o do sistema, par�metro 159 Enviar email ao cadastrar o usu�rio ou trocar senha do usu�rio. */
        update funcao_parametro set vl_parametro = 'N' where cd_funcao = 6001 and nr_sequencia = 159;
        
        /*Update para realiza o bloqueio de todos os login ativos no sistema, menos os que possuem o perfil de administra��o do sistema*/
        update usuario set ie_situacao = 'B', dt_atualizacao = sysdate where cd_pessoa_fisica not in (select cd_pessoa_fisica from usuario u join usuario_perfil p on u.nm_usuario = p.nm_usuario where p.cd_perfil  = 1848 and ie_situacao = 'A') and ie_situacao = 'A';
        
        /*Update para realizar o desbloqueio de usu�rios que devem permanecer ativos no sistema, que possuem acesso a base de testes. Esta regra foi separada da anterior para ficar mais f�cil a visualiza��o / administra��o desses usu�rios.*/
        update usuario set ie_situacao = 'A' where cd_pessoa_fisica in (70006) and ie_situacao = 'B';

        /*Altera endere�o Ip do servidor de integra��o
        update servidor_integracao set ip_conexao = '192.168.25.180' where nr_sequencia = 1;
        /*

        /*Update cliente_integracao. Altera endere�o do servidor de integra��o e altera status para ativo.
        set DS_URL_WEBSERVICE = 'http://192.168.25.180/WhebWS/ws/laudoWS?wsdl', ie_situacao = 'A' where nr_seq_inf_integracao in (186,187,188,189,192,193,194,197,198,1325,1502,1503,1755,1757,1792,1794);
        */

        /*Update para as demais integra��es que n�o s�o do pacs.
        update cliente_integracao set ie_situacao = 'P' where nr_seq_inf_integracao not in (186,187,188,189,192,193,194,197,198,1325,1502,1503,1755,1757,1792,1794);
        */

    end loop;
    close c1;

    commit;

end HBM_CONTROLE_TASY_TESTE;