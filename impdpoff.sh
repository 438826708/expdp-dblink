#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR"/"config.txt
tip(){
    echo -e '\E[37;44m'"\033[1m$1\033[0m"
}


error(){
    echo -e "\033[31;1m$1\033[0m"
}


exec_failed(){
    if [ $? -ne 0 ];then
        error $1
        exit 
    fi
}

is_file_exists(){
    if [ ! -f $1 ];then
        error "File $1 is not exists!"
        exit 
    fi
}


fun_dblink() { 
sqlplus / as sysdba <<eof
create public database link TEST_LINK
  connect to ${OLDUSER} identified by "${OLDPASS}"
  using '(DESCRIPTION =
  (ADDRESS = (PROTOCOL = TCP)(HOST = ${OLDIP})(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ${OLDSID})
   )
)';
eof
}

fun_impdp(){ 
export ORACLE_SID=${NEWSID}
if [ -n "$TABLE" ];
then
impdp \'sys/oracle AS SYSDBA\'  network_link=TEST_LINK tables=${TABLE}
else
impdp \'sys/oracle AS SYSDBA\'  CLUSTER=NO PARALLEL=8 exclude=statistics SCHEMAS=${SCHEMAS}  network_link=TEST_LINK
fi
}
fun_dblink
fun_impdp
