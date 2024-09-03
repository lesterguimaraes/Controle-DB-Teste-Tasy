create or replace procedure HBM_CONTROLE_TASY_TESTE is

/*
Desenvolvido esta procedura para alterar a cor do estabelecimento no delhpi, mudar a aplicação para Treinamento (uso no HTML5) e deletar a JOB de envio de CI/e-mail da função gestão da qualidade.
Documentada na OS 1770
Autor: Lester Gomes Guimarães
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
/*No cursos 1 se faz necessário validar a base na qual será executada as alterações. Como é um único servidor físico com dois PDBs, a diferenciação se faz pelo db_name*/

begin

    open c1;
    loop
    fetch c1 into
    resultado_w;
    exit when c1%notfound;
        /*Inseri coloração na barra de status do Tasy Deplhi para silaizar que se trata da base de testes / homoloçgação*/
        insert into tasy_padrao_cor_perfil (nr_sequencia,cd_estabelecimento,cd_perfil,nr_seq_padrao,dt_atualizacao,nm_usuario,ds_cor_fundo) values ((select max(nr_sequencia)+1 from tasy_padrao_cor_perfil), 1, null, 17, sysdate, 'lester','$00404080');
        
        /*Update para mudar a aplicação de (P) Produção para (E) Treinamento. Função: Administração do Sistema / Aplicação */
        update  aplicacao_tasy set ie_banco = 'E' where cd_aplicacao_tasy = 'Tasy';

        /*Update para cancelar o envio de e-mail quando houver redefinição de senha do login. Função: Administração do Sistema / Parâmetros, aplicação principal, administração do sistema, parâmetro 159 Enviar email ao cadastrar o usuário ou trocar senha do usuário. */
        update funcao_parametro set vl_parametro = 'N' where cd_funcao = 6001 and nr_sequencia = 159;
        
        /*Update para realiza o bloqueio de todos os login ativos no sistema, menos os que possuem o perfil de administração do sistema*/
        update usuario set ie_situacao = 'B', dt_atualizacao = sysdate where cd_pessoa_fisica not in (select cd_pessoa_fisica from usuario u join usuario_perfil p on u.nm_usuario = p.nm_usuario where p.cd_perfil  = 1848 and ie_situacao = 'A') and ie_situacao = 'A';
        
        /*Update para realizar o desbloqueio de usuários que devem permanecer ativos no sistema, que possuem acesso a base de testes. Esta regra foi separada da anterior para ficar mais fácil a visualização / administração desses usuários.*/
        update usuario set ie_situacao = 'A' where cd_pessoa_fisica in (70006) and ie_situacao = 'B';

        /*Altera endereço Ip do servidor de integração
        update servidor_integracao set ip_conexao = '192.168.25.180' where nr_sequencia = 1;
        /*

        /*Update cliente_integracao. Altera endereço do servidor de integração e altera status para ativo.
        set DS_URL_WEBSERVICE = 'http://192.168.25.180/WhebWS/ws/laudoWS?wsdl', ie_situacao = 'A' where nr_seq_inf_integracao in (186,187,188,189,192,193,194,197,198,1325,1502,1503,1755,1757,1792,1794);
        */

        /*Update para as demais integrações que não são do pacs.
        update cliente_integracao set ie_situacao = 'P' where nr_seq_inf_integracao not in (186,187,188,189,192,193,194,197,198,1325,1502,1503,1755,1757,1792,1794);
        */

    end loop;
    close c1;

    commit;

end HBM_CONTROLE_TASY_TESTE;