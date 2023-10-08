# expdp-dblink
auto migrate oracle data


整个过程都是使用的oracle用户完成

第一 在新库上， 配置参数文件config.txt

OLDIP=192.168.56.107   ##旧库ip地址
NEWIP=192.168.56.109  ##新库ip地址
OLDSID=orcl      ##旧库实例名
NEWSID=orclbk ##新库实例名
OLDUSER=system  ##旧库用户名,创建dblink使用,权限最好高点,本次使用的system用户
OLDPASS=oracle1QAZ! ##旧库用户密码，本次是system的密码
TABLE=test.ttt,test.t1,test.t2   ##导出表,1.格式:用户名.表2多个表使用逗号隔开3TABLE和SCHEMAS二选一,不用的就注释掉
#SCHEMAS=test   ##导出整个用户,可以开启这个参数,TABLE和SCHEMAS二选一,不用的就注释掉


注:按照用户导出，新库上会自动创建用户，按照表导出则不会，需要先创建用户，表空间，权限

第二 在新库上，执行授权然后执行脚本

chmod +x impdpoff.sh
./impdpoff.sh

脚本会创建到旧库的dblink，然后通过dblink，不落地的方式，导入数据到新库
查看日志，注意报错内容


Import: Release 11.2.0.4.0 - Production on Mon Sep 18 04:36:35 2023

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

Connected to: Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
Starting "SYS"."SYS_IMPORT_SCHEMA_01":  "sys/******** AS SYSDBA" CLUSTER=NO PARALLEL=8 exclude=statistics SCHEMAS=test network_link=TEST_LINK
Estimate in progress using BLOCKS method...
Processing object type SCHEMA_EXPORT/TABLE/TABLE_DATA
Total estimation using BLOCKS method: 64 KB
Processing object type SCHEMA_EXPORT/USER
Processing object type SCHEMA_EXPORT/SYSTEM_GRANT
Processing object type SCHEMA_EXPORT/ROLE_GRANT
Processing object type SCHEMA_EXPORT/DEFAULT_ROLE
Processing object type SCHEMA_EXPORT/PRE_SCHEMA/PROCACT_SCHEMA
Processing object type SCHEMA_EXPORT/TABLE/TABLE
. . imported "TEST"."TTT"                                     1 rows
Job "SYS"."SYS_IMPORT_SCHEMA_01" successfully completed at Mon Sep 18 04:36:38 2023 elapsed 0 00:00:02
