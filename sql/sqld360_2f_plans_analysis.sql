SPO &&one_spool_filename..html APP;
PRO </head>
@sql/sqld360_0d_html_header.sql
PRO <body>
PRO <h1><a href="http://www.enkitec.com" target="_blank">Enkitec</a>: SQL 360-degree view <em>(<a href="http://www.enkitec.com/products/sqld360" target="_blank">SQLd360</a>)</em> &&sqld360_vYYNN. - Plans Analysis Page</h1>
PRO
PRO <pre>
PRO sqlid:&&sqld360_sqlid. dbname:&&database_name_short. version:&&db_version. host:&&host_name_short. license:&&license_pack. days:&&history_days. today:&&sqld360_time_stamp.
PRO </pre>
PRO

PRO <table><tr class="main">

SET SERVEROUT ON ECHO OFF FEEDBACK OFF TIMING OFF 

BEGIN
  FOR i IN (SELECT plan_hash_value
              FROM (SELECT plan_hash_value
                      FROM gv$sql
                     WHERE sql_id = '&&sqld360_sqlid.'
                    UNION
                    SELECT plan_hash_value
                      FROM dba_hist_sqlstat
                     WHERE sql_id = '&&sqld360_sqlid.'
                       AND '&&diagnostics_pack.' = 'Y') 
             ORDER BY 1)
  LOOP
    DBMS_OUTPUT.PUT_LINE('<td class="c">PHV '||i.plan_hash_value||'</td>');
  END LOOP;
END;
/

PRO </tr><tr class="main">
SPO OFF

-- this is to trick sqld360_9a_pre
DEF sqld360_main_report_bck = &&sqld360_main_report.
DEF sqld360_main_report = &&one_spool_filename.

SPO sqld360_plans_analysis_&&sqld360_sqlid._driver.sql
SET SERVEROUT ON

DECLARE
  PROCEDURE put (p_line IN VARCHAR2)
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(p_line);
  END put;
BEGIN

-- this is intentional, showing all the tables including the ones with no histograms
-- so it's easier to spot the ones with no histograms too
  FOR i IN (SELECT plan_hash_value
              FROM (SELECT plan_hash_value
                      FROM gv$sql
                     WHERE sql_id = '&&sqld360_sqlid.'
                    UNION
                    SELECT plan_hash_value
                      FROM dba_hist_sqlstat
                     WHERE sql_id = '&&sqld360_sqlid.'
                       AND '&&diagnostics_pack.' = 'Y') 
             ORDER BY 1) 
  LOOP
    put('SET PAGES 50000');
    put('SPO &&sqld360_main_report..html APP;');
    put('PRO <td>');
    put('SPO OFF');

    put('SPO &&one_spool_filename..html APP;');
    put('PRO <h2>Execution Plan</h2> ');
    put('SPO OFF');

    put('DEF title=''Plan Tree for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''DBA_HIST_SQL_PLAN''');
    put('DEF skip_html=''Y''');
    put('DEF skip_text=''Y''');
    put('DEF skip_csv=''Y''');
    put('DEF skip_tch=''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT id, parent_id, id2, id3');
    put('  FROM (SELECT ''''{v: ''''''''''''||id||'''''''''''',f: ''''''''''''||operation||'''' ''''||options||''''<br>''''||object_name||''''''''''''}'''' id, ');
    put('               parent_id, ''''Step ID: ''''||id id2, id id3');
    put('          FROM gv$sql_plan_statistics_all');
    put('         WHERE plan_hash_value =  '||i.plan_hash_value||'');
    put('           AND sql_id = ''''&&sqld360_sqlid.'''''); 
    put('        UNION ');
    put('        SELECT ''''{v: ''''''''''''||id||'''''''''''',f: ''''''''''''||operation||'''' ''''||options||''''<br>''''||object_name||''''''''''''}'''' id, ');
    put('               parent_id, ''''Step ID: ''''||id id2, id id3');
    put('          FROM dba_hist_sql_plan');
    put('         WHERE plan_hash_value =  '||i.plan_hash_value||'');
    put('           AND sql_id = ''''&&sqld360_sqlid.'''''); 
    put('           AND NOT EXISTS (SELECT 1 ');
    put('                             FROM gv$sql_plan_statistics_all ');
    put('                            WHERE plan_hash_value =  '||i.plan_hash_value||'');
    put('                              AND sql_id = ''''&&sqld360_sqlid.'''')');
    put('           AND ''''&&diagnostics_pack.'''' = ''''Y'''')');
    put(' ORDER BY id3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('SPO &&one_spool_filename..html APP;');
    put('PRO <h2>Elapsed Time</h2> ');
    put('SPO OFF');

    put('DEF title=''Avg et/exec for recent execs for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''V$ACTIVE_SESSION_HISTORY''');
    put('DEF skip_lch=''''');
    put('DEF chartype = ''LineChart''');
    put('DEF stacked = ''''');
    put('DEF tit_01 = ''Average Elapsed Time''');
    put('DEF tit_02 = ''Average Time on CPU''');
    put('DEF tit_03 = ''''');
    put('DEF tit_04 = ''''');
    put('DEF tit_05 = ''''');
    put('DEF tit_06 = ''''');
    put('DEF tit_07 = ''''');
    put('DEF tit_08 = ''''');
    put('DEF tit_09 = ''''');
    put('DEF tit_10 = ''''');
    put('DEF tit_11 = ''''');
    put('DEF tit_12 = ''''');
    put('DEF tit_13 = ''''');
    put('DEF tit_14 = ''''');
    put('DEF tit_15 = ''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT 0 snap_id,');
    put('       TO_CHAR(start_time, ''''YYYY-MM-DD HH24:MI'''') begin_time,'); 
    put('       TO_CHAR(start_time, ''''YYYY-MM-DD HH24:MI'''') end_time,');
    put('       avg_et,');
    put('       avg_cpu_time,');
    put('       0 dummy_03,');
    put('       0 dummy_04,');
    put('       0 dummy_05,');
    put('       0 dummy_06,');
    put('       0 dummy_07,');
    put('       0 dummy_08,');
    put('       0 dummy_09,');
    put('       0 dummy_10,');
    put('       0 dummy_11,');
    put('       0 dummy_12,');
    put('       0 dummy_13,');
    put('       0 dummy_14,');
    put('       0 dummy_15');
    put('  FROM (SELECT start_time,');
    put('               AVG(et) avg_et,');
    put('               AVG(cpu_time) avg_cpu_time');
    put('          FROM (SELECT TO_DATE(SUBSTR(distribution,1,12),''''YYYYMMDDHH24MI'''') start_time,');
    put('                       NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,3)+1,INSTR(partition_stop,'''','''',1,4)-INSTR(partition_stop,'''','''',1,3)-1)),position)||''''-''''||'); 
    put('                        NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,4)+1,INSTR(partition_stop,'''','''',1,5)-INSTR(partition_stop,'''','''',1,4)-1)),cpu_cost)||''''-''''||'); 
    put('                        NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,5)+1,INSTR(partition_stop,'''','''',1,6)-INSTR(partition_stop,'''','''',1,5)-1)),io_cost)||''''-''''||');
    put('                        NVL(partition_id,0)||''''-''''||NVL(distribution,''''x'''') uniq_exec,'); 
    put('                       86400*(MAX(timestamp)-MIN(timestamp)) et,'); 
    put('                       SUM(CASE WHEN object_node = ''''ON CPU'''' THEN 1 ELSE 0 END) cpu_time'); 
    put('                  FROM plan_table');
    put('                 WHERE statement_id = ''''SQLD360_ASH_DATA_MEM''''');
    put('                   AND cost =  '||i.plan_hash_value||'');
    put('                   AND remarks = ''''&&sqld360_sqlid.'''''); 
    put('                   AND partition_id IS NOT NULL');
    put('                   AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('                 GROUP BY TO_DATE(SUBSTR(distribution,1,12),''''YYYYMMDDHH24MI''''),');
    put('                          NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,3)+1,INSTR(partition_stop,'''','''',1,4)-INSTR(partition_stop,'''','''',1,3)-1)),position)||''''-''''||'); 
    put('                           NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,4)+1,INSTR(partition_stop,'''','''',1,5)-INSTR(partition_stop,'''','''',1,4)-1)),cpu_cost)||''''-''''||'); 
    put('                           NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,5)+1,INSTR(partition_stop,'''','''',1,6)-INSTR(partition_stop,'''','''',1,5)-1)),io_cost)||''''-''''||');
    put('                           NVL(partition_id,0)||''''-''''||NVL(distribution,''''x''''))');
    put('          GROUP BY start_time)');
    put(' ORDER BY 3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('DEF title=''Avg et/exec for historical execs for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''DBA_HIST_ACTIVE_SESS_HISTORY''');
    put('DEF skip_lch=''''');
    put('DEF chartype = ''LineChart''');
    put('DEF stacked = ''''');
    put('DEF tit_01 = ''Average Elapsed Time''');
    put('DEF tit_02 = ''Average Time on CPU''');
    put('DEF tit_03 = ''''');
    put('DEF tit_04 = ''''');
    put('DEF tit_05 = ''''');
    put('DEF tit_06 = ''''');
    put('DEF tit_07 = ''''');
    put('DEF tit_08 = ''''');
    put('DEF tit_09 = ''''');
    put('DEF tit_10 = ''''');
    put('DEF tit_11 = ''''');
    put('DEF tit_12 = ''''');
    put('DEF tit_13 = ''''');
    put('DEF tit_14 = ''''');
    put('DEF tit_15 = ''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT b.snap_id snap_id,');
    put('       TO_CHAR(b.begin_interval_time, ''''YYYY-MM-DD HH24:MI'''') begin_time,'); 
    put('       TO_CHAR(b.end_interval_time, ''''YYYY-MM-DD HH24:MI'''') end_time,');
    put('       NVL(avg_et,0) avg_et,');
    put('       NVL(avg_cpu_time,0) avg_cpu_time,');
    put('       0 dummy_03,');
    put('       0 dummy_04,');
    put('       0 dummy_05,');
    put('       0 dummy_06,');
    put('       0 dummy_07,');
    put('       0 dummy_08,');
    put('       0 dummy_09,');
    put('       0 dummy_10,');
    put('       0 dummy_11,');
    put('       0 dummy_12,');
    put('       0 dummy_13,');
    put('       0 dummy_14,');
    put('       0 dummy_15');
    put('  FROM (SELECT snap_id,');
    put('               MAX(avg_et) avg_et,');
    put('               MAX(avg_cpu_time) avg_cpu_time');
    put('          FROM (SELECT start_time,');
    put('                       MIN(start_snap_id) snap_id,');
    put('                       AVG(et) avg_et,');
    put('                       AVG(cpu_time) avg_cpu_time');
    put('                  FROM (SELECT TO_DATE(SUBSTR(distribution,1,12),''''YYYYMMDDHH24MI'''') start_time,');
    put('                               NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,3)+1,INSTR(partition_stop,'''','''',1,4)-INSTR(partition_stop,'''','''',1,3)-1)),position)||''''-''''||'); 
    put('                                NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,4)+1,INSTR(partition_stop,'''','''',1,5)-INSTR(partition_stop,'''','''',1,4)-1)),cpu_cost)||''''-''''||'); 
    put('                                NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,5)+1,INSTR(partition_stop,'''','''',1,6)-INSTR(partition_stop,'''','''',1,5)-1)),io_cost)||''''-''''||');
    put('                                NVL(partition_id,0)||''''-''''||NVL(distribution,''''x'''') uniq_exec,'); 
    put('                               MIN(cardinality) start_snap_id,');
    put('                               86400*(MAX(timestamp)-MIN(timestamp)) et, ');
    put('                               SUM(CASE WHEN object_node = ''''ON CPU'''' THEN 10 ELSE 0 END) cpu_time'); 
    put('                          FROM plan_table');
    put('                         WHERE statement_id = ''''SQLD360_ASH_DATA_HIST''''');
    put('                           AND partition_id IS NOT NULL');
    put('                           AND cost = '||i.plan_hash_value||'');
    put('                           AND remarks = ''''&&sqld360_sqlid.''''');
    put('                           AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('                         GROUP BY TO_DATE(SUBSTR(distribution,1,12),''''YYYYMMDDHH24MI''''), ');
    put('                                  NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,3)+1,INSTR(partition_stop,'''','''',1,4)-INSTR(partition_stop,'''','''',1,3)-1)),position)||''''-''''||'); 
    put('                                   NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,4)+1,INSTR(partition_stop,'''','''',1,5)-INSTR(partition_stop,'''','''',1,4)-1)),cpu_cost)||''''-''''||'); 
    put('                                   NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,5)+1,INSTR(partition_stop,'''','''',1,6)-INSTR(partition_stop,'''','''',1,5)-1)),io_cost)||''''-''''||');
    put('                                   NVL(partition_id,0)||''''-''''||NVL(distribution,''''x''''))');
    put('                 GROUP BY start_time)');
    put('         GROUP BY snap_id) ash,');
    put('      dba_hist_snapshot b');
    put(' WHERE ash.snap_id(+) = b.snap_id');
    put('   AND b.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.');
    put(' ORDER BY 3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('SPO &&one_spool_filename..html APP;');
    put('PRO <h2>Resource Consumption</h2> ');
    put('SPO OFF');

    put('DEF title=''Peak PGA and TEMP usage for recent execs for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''V$ACTIVE_SESSION_HISTORY''');
    put('DEF skip_lch=''''');
    put('DEF chartype = ''LineChart''');
    put('DEF stacked = ''''');
    put('DEF tit_01 = ''PGA Usage''');
    put('DEF tit_02 = ''TEMP Usage''');
    put('DEF tit_03 = ''''');
    put('DEF tit_04 = ''''');
    put('DEF tit_05 = ''''');
    put('DEF tit_06 = ''''');
    put('DEF tit_07 = ''''');
    put('DEF tit_08 = ''''');
    put('DEF tit_09 = ''''');
    put('DEF tit_10 = ''''');
    put('DEF tit_11 = ''''');
    put('DEF tit_12 = ''''');
    put('DEF tit_13 = ''''');
    put('DEF tit_14 = ''''');
    put('DEF tit_15 = ''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT 0 snap_id,');
    put('       TO_CHAR(end_time, ''''YYYY-MM-DD HH24:MI'''') begin_time,'); 
    put('       TO_CHAR(end_time, ''''YYYY-MM-DD HH24:MI'''') end_time,');
    put('       pga_allocated_min,');
    put('       temp_space_allocated_min,');
    put('       0 dummy_03,');
    put('       0 dummy_04,');
    put('       0 dummy_05,');
    put('       0 dummy_06,');
    put('       0 dummy_07,');
    put('       0 dummy_08,');
    put('       0 dummy_09,');
    put('       0 dummy_10,');
    put('       0 dummy_11,');
    put('       0 dummy_12,');
    put('       0 dummy_13,');
    put('       0 dummy_14,');
    put('       0 dummy_15');
    put('  FROM (SELECT TRUNC(end_time,''''mi'''') end_time,');
    put('               MAX(pga_allocated) pga_allocated_min,');
    put('               MAX(temp_space_allocated) temp_space_allocated_min');
    put('          FROM (SELECT timestamp end_time,');
    put('                       SUM(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,11)+1,INSTR(partition_stop,'''','''',1,12)-INSTR(partition_stop,'''','''',1,11)-1))) pga_allocated,'); 
    put('                       SUM(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,12)+1,INSTR(partition_stop,'''','''',1,13)-INSTR(partition_stop,'''','''',1,12)-1))) temp_space_allocated'); 
    put('                  FROM plan_table');
    put('                 WHERE statement_id = ''''SQLD360_ASH_DATA_MEM''''');
    put('                   AND cost =  '||i.plan_hash_value||'');
    put('                   AND remarks = ''''&&sqld360_sqlid.'''''); 
    put('                   AND partition_id IS NOT NULL');
    put('                   AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('                 GROUP BY timestamp)');
    put('          GROUP BY TRUNC(end_time,''''mi''''))');
    put(' ORDER BY 3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('DEF title=''Peak PGA and TEMP usage for historical execs for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''DBA_HIST_ACTIVE_SESS_HISTORY''');
    put('DEF skip_lch=''''');
    put('DEF chartype = ''LineChart''');
    put('DEF stacked = ''''');
    put('DEF tit_01 = ''PGA Usage''');
    put('DEF tit_02 = ''TEMP Usage''');
    put('DEF tit_03 = ''''');
    put('DEF tit_04 = ''''');
    put('DEF tit_05 = ''''');
    put('DEF tit_06 = ''''');
    put('DEF tit_07 = ''''');
    put('DEF tit_08 = ''''');
    put('DEF tit_09 = ''''');
    put('DEF tit_10 = ''''');
    put('DEF tit_11 = ''''');
    put('DEF tit_12 = ''''');
    put('DEF tit_13 = ''''');
    put('DEF tit_14 = ''''');
    put('DEF tit_15 = ''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT b.snap_id snap_id,');
    put('       TO_CHAR(b.begin_interval_time, ''''YYYY-MM-DD HH24:MI'''') begin_time,'); 
    put('       TO_CHAR(b.end_interval_time, ''''YYYY-MM-DD HH24:MI'''') end_time,');
    put('       NVL(pga_allocated_hour,0) pga_allocated_hour,');
    put('       NVL(temp_space_allocated_hour,0) temp_space_allocated_hour,');
    put('       0 dummy_03,');
    put('       0 dummy_04,');
    put('       0 dummy_05,');
    put('       0 dummy_06,');
    put('       0 dummy_07,');
    put('       0 dummy_08,');
    put('       0 dummy_09,');
    put('       0 dummy_10,');
    put('       0 dummy_11,');
    put('       0 dummy_12,');
    put('       0 dummy_13,');
    put('       0 dummy_14,');
    put('       0 dummy_15');
    put('  FROM (SELECT snap_id,');
    put('               MAX(pga_allocated) pga_allocated_hour,');
    put('               MAX(temp_space_allocated) temp_space_allocated_hour');
    put('          FROM (SELECT cardinality snap_id,');
    put('                       timestamp end_time,'); 
    put('                       SUM(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,11)+1,INSTR(partition_stop,'''','''',1,12)-INSTR(partition_stop,'''','''',1,11)-1))) pga_allocated,');
    put('                       SUM(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,12)+1,INSTR(partition_stop,'''','''',1,13)-INSTR(partition_stop,'''','''',1,12)-1))) temp_space_allocated');
    put('                  FROM plan_table');
    put('                 WHERE statement_id = ''''SQLD360_ASH_DATA_HIST''''');
    put('                   AND cost = '||i.plan_hash_value||'');
    put('                   AND remarks = ''''&&sqld360_sqlid.''''');
    put('                   AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('                 GROUP BY cardinality, timestamp)');
    put('         GROUP BY snap_id) ash,');
    put('      dba_hist_snapshot b');
    put(' WHERE ash.snap_id(+) = b.snap_id');
    put('   AND b.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.');
    put(' ORDER BY 3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

-- the result in case of PX might be a little misleading because some slaves could be not sampled
-- for few secs and then show up with a delta_time > 1 sec so the metrics should be split "backwards" in time
-- but that would be too expensive to compute and likely to provide little benefit
-- there should be no issue for serial execs

    put('DEF title=''Peak Read and Write I/O requests for recent execs for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''V$ACTIVE_SESSION_HISTORY''');
    put('DEF skip_lch=''''');
    put('DEF chartype = ''LineChart''');
    put('DEF stacked = ''''');
    put('DEF tit_01 = ''Read I/O Request''');
    put('DEF tit_02 = ''Write I/O Request''');
    put('DEF tit_03 = ''''');
    put('DEF tit_04 = ''''');
    put('DEF tit_05 = ''''');
    put('DEF tit_06 = ''''');
    put('DEF tit_07 = ''''');
    put('DEF tit_08 = ''''');
    put('DEF tit_09 = ''''');
    put('DEF tit_10 = ''''');
    put('DEF tit_11 = ''''');
    put('DEF tit_12 = ''''');
    put('DEF tit_13 = ''''');
    put('DEF tit_14 = ''''');
    put('DEF tit_15 = ''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT 0 snap_id,');
    put('       TO_CHAR(end_time, ''''YYYY-MM-DD HH24:MI'''') begin_time,'); 
    put('       TO_CHAR(end_time, ''''YYYY-MM-DD HH24:MI'''') end_time,');
    put('       read_io_requests_min,');
    put('       write_io_requests_min,');
    put('       0 dummy_03,');
    put('       0 dummy_04,');
    put('       0 dummy_05,');
    put('       0 dummy_06,');
    put('       0 dummy_07,');
    put('       0 dummy_08,');
    put('       0 dummy_09,');
    put('       0 dummy_10,');
    put('       0 dummy_11,');
    put('       0 dummy_12,');
    put('       0 dummy_13,');
    put('       0 dummy_14,');
    put('       0 dummy_15');
    put('  FROM (SELECT TRUNC(end_time,''''mi'''') end_time,');
    put('               MAX(read_io_requests) read_io_requests_min,');
    put('               MAX(write_io_requests) write_io_requests_min');
    put('          FROM (SELECT timestamp end_time,');
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,14)+1,INSTR(partition_stop,'''','''',1,15)-INSTR(partition_stop,'''','''',1,14)-1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) read_io_requests,'); 
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,15)+1,INSTR(partition_stop,'''','''',1,16)-INSTR(partition_stop,'''','''',1,15)-1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) write_io_requests'); 
    put('                  FROM plan_table');
    put('                 WHERE statement_id = ''''SQLD360_ASH_DATA_MEM''''');
    put('                   AND cost =  '||i.plan_hash_value||'');
    put('                   AND remarks = ''''&&sqld360_sqlid.'''''); 
    put('                   AND partition_id IS NOT NULL');
    put('                   AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('                 GROUP BY timestamp)');
    put('          GROUP BY TRUNC(end_time,''''mi''''))');
    put(' ORDER BY 3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('DEF title=''Peak Read and Write I/O requests for historical execs for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''DBA_HIST_ACTIVE_SESS_HISTORY''');
    put('DEF skip_lch=''''');
    put('DEF chartype = ''LineChart''');
    put('DEF stacked = ''''');
    put('DEF tit_01 = ''Read I/O Request''');
    put('DEF tit_02 = ''Write I/O Request''');
    put('DEF tit_03 = ''''');
    put('DEF tit_04 = ''''');
    put('DEF tit_05 = ''''');
    put('DEF tit_06 = ''''');
    put('DEF tit_07 = ''''');
    put('DEF tit_08 = ''''');
    put('DEF tit_09 = ''''');
    put('DEF tit_10 = ''''');
    put('DEF tit_11 = ''''');
    put('DEF tit_12 = ''''');
    put('DEF tit_13 = ''''');
    put('DEF tit_14 = ''''');
    put('DEF tit_15 = ''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT b.snap_id snap_id,');
    put('       TO_CHAR(b.begin_interval_time, ''''YYYY-MM-DD HH24:MI'''') begin_time,'); 
    put('       TO_CHAR(b.end_interval_time, ''''YYYY-MM-DD HH24:MI'''') end_time,');
    put('       NVL(read_io_requests_hour,0) read_io_requests_hour,');
    put('       NVL(write_io_requests_hour,0) write_io_requests_hour,');
    put('       0 dummy_03,');
    put('       0 dummy_04,');
    put('       0 dummy_05,');
    put('       0 dummy_06,');
    put('       0 dummy_07,');
    put('       0 dummy_08,');
    put('       0 dummy_09,');
    put('       0 dummy_10,');
    put('       0 dummy_11,');
    put('       0 dummy_12,');
    put('       0 dummy_13,');
    put('       0 dummy_14,');
    put('       0 dummy_15');
    put('  FROM (SELECT snap_id,');
    put('               MAX(read_io_requests) read_io_requests_hour,');
    put('               MAX(write_io_requests) write_io_requests_hour');
    put('          FROM (SELECT cardinality snap_id,');
    put('                       timestamp end_time,'); 
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,14)+1,INSTR(partition_stop,'''','''',1,15)-INSTR(partition_stop,'''','''',1,14)-1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) read_io_requests,'); 
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,15)+1,INSTR(partition_stop,'''','''',1,16)-INSTR(partition_stop,'''','''',1,15)-1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) write_io_requests'); 
    put('                  FROM plan_table');
    put('                 WHERE statement_id = ''''SQLD360_ASH_DATA_HIST''''');
    put('                   AND cost = '||i.plan_hash_value||'');
    put('                   AND remarks = ''''&&sqld360_sqlid.''''');
    put('                   AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('                 GROUP BY cardinality, timestamp)');
    put('         GROUP BY snap_id) ash,');
    put('      dba_hist_snapshot b');
    put(' WHERE ash.snap_id(+) = b.snap_id');
    put('   AND b.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.');
    put(' ORDER BY 3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('DEF title=''Peak Read, Write and Interconnect I/O bytes for recent execs for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''V$ACTIVE_SESSION_HISTORY''');
    put('DEF skip_lch=''''');
    put('DEF chartype = ''LineChart''');
    put('DEF stacked = ''''');
    put('DEF tit_01 = ''Read I/O Bytes''');
    put('DEF tit_02 = ''Write I/O Bytes''');
    put('DEF tit_03 = ''Interconnect I/O Bytes''');
    put('DEF tit_04 = ''''');
    put('DEF tit_05 = ''''');
    put('DEF tit_06 = ''''');
    put('DEF tit_07 = ''''');
    put('DEF tit_08 = ''''');
    put('DEF tit_09 = ''''');
    put('DEF tit_10 = ''''');
    put('DEF tit_11 = ''''');
    put('DEF tit_12 = ''''');
    put('DEF tit_13 = ''''');
    put('DEF tit_14 = ''''');
    put('DEF tit_15 = ''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT 0 snap_id,');
    put('       TO_CHAR(end_time, ''''YYYY-MM-DD HH24:MI'''') begin_time,'); 
    put('       TO_CHAR(end_time, ''''YYYY-MM-DD HH24:MI'''') end_time,');
    put('       read_io_bytes_min,');
    put('       write_io_bytes_min,');
    put('       interconnect_io_bytes_min,');
    put('       0 dummy_04,');
    put('       0 dummy_05,');
    put('       0 dummy_06,');
    put('       0 dummy_07,');
    put('       0 dummy_08,');
    put('       0 dummy_09,');
    put('       0 dummy_10,');
    put('       0 dummy_11,');
    put('       0 dummy_12,');
    put('       0 dummy_13,');
    put('       0 dummy_14,');
    put('       0 dummy_15');
    put('  FROM (SELECT TRUNC(end_time,''''mi'''') end_time,');
    put('               MAX(read_io_bytes) read_io_bytes_min,');
    put('               MAX(write_io_bytes) write_io_bytes_min,');
    put('               MAX(interconnect_io_bytes) interconnect_io_bytes_min');
    put('          FROM (SELECT timestamp end_time,');
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,16)+1,INSTR(partition_stop,'''','''',1,17)-INSTR(partition_stop,'''','''',1,16)-1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) read_io_bytes,'); 
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,17)+1,INSTR(partition_stop,'''','''',1,18)-INSTR(partition_stop,'''','''',1,17)-1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) write_io_bytes,'); 
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,18)+1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) interconnect_io_bytes'); 
    put('                  FROM plan_table');
    put('                 WHERE statement_id = ''''SQLD360_ASH_DATA_MEM''''');
    put('                   AND cost =  '||i.plan_hash_value||'');
    put('                   AND remarks = ''''&&sqld360_sqlid.'''''); 
    put('                   AND partition_id IS NOT NULL');
    put('                   AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('                 GROUP BY timestamp)');
    put('          GROUP BY TRUNC(end_time,''''mi''''))');
    put(' ORDER BY 3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('DEF title=''Peak Read, Write and Interconnect I/O bytes for historical execs for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''DBA_HIST_ACTIVE_SESS_HISTORY''');
    put('DEF skip_lch=''''');
    put('DEF chartype = ''LineChart''');
    put('DEF stacked = ''''');
    put('DEF tit_01 = ''Read I/O Bytes''');
    put('DEF tit_02 = ''Write I/O Bytes''');
    put('DEF tit_03 = ''Interconnect I/O Bytes''');
    put('DEF tit_04 = ''''');
    put('DEF tit_05 = ''''');
    put('DEF tit_06 = ''''');
    put('DEF tit_07 = ''''');
    put('DEF tit_08 = ''''');
    put('DEF tit_09 = ''''');
    put('DEF tit_10 = ''''');
    put('DEF tit_11 = ''''');
    put('DEF tit_12 = ''''');
    put('DEF tit_13 = ''''');
    put('DEF tit_14 = ''''');
    put('DEF tit_15 = ''''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT b.snap_id snap_id,');
    put('       TO_CHAR(b.begin_interval_time, ''''YYYY-MM-DD HH24:MI'''') begin_time,'); 
    put('       TO_CHAR(b.end_interval_time, ''''YYYY-MM-DD HH24:MI'''') end_time,');
    put('       NVL(read_io_bytes_hour,0) read_io_requests_hour,');
    put('       NVL(write_io_bytes_hour,0) write_io_bytes_hour,');
    put('       NVL(interconnect_io_bytes_hour,0) interconnect_io_bytes_hour,');
    put('       0 dummy_04,');
    put('       0 dummy_05,');
    put('       0 dummy_06,');
    put('       0 dummy_07,');
    put('       0 dummy_08,');
    put('       0 dummy_09,');
    put('       0 dummy_10,');
    put('       0 dummy_11,');
    put('       0 dummy_12,');
    put('       0 dummy_13,');
    put('       0 dummy_14,');
    put('       0 dummy_15');
    put('  FROM (SELECT snap_id,');
    put('               MAX(read_io_bytes) read_io_bytes_hour,');
    put('               MAX(write_io_bytes) write_io_bytes_hour,');
    put('               MAX(interconnect_io_bytes) interconnect_io_bytes_hour');
    put('          FROM (SELECT cardinality snap_id,');
    put('                       timestamp end_time,'); 
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,16)+1,INSTR(partition_stop,'''','''',1,17)-INSTR(partition_stop,'''','''',1,16)-1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) read_io_bytes,'); 
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,17)+1,INSTR(partition_stop,'''','''',1,18)-INSTR(partition_stop,'''','''',1,17)-1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) write_io_bytes,'); 
    put('                       SUM(NVL(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,18)+1)),0)/ ');
    put('                               ROUND(TO_NUMBER(SUBSTR(partition_stop,INSTR(partition_stop,'''','''',1,13)+1,INSTR(partition_stop,'''','''',1,14)-INSTR(partition_stop,'''','''',1,13)-1))/1e6)) interconnect_io_bytes'); 
    put('                  FROM plan_table');
    put('                 WHERE statement_id = ''''SQLD360_ASH_DATA_HIST''''');
    put('                   AND cost = '||i.plan_hash_value||'');
    put('                   AND remarks = ''''&&sqld360_sqlid.''''');
    put('                   AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('                 GROUP BY cardinality, timestamp)');
    put('         GROUP BY snap_id) ash,');
    put('      dba_hist_snapshot b');
    put(' WHERE ash.snap_id(+) = b.snap_id');
    put('   AND b.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.');
    put(' ORDER BY 3');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('SPO &&one_spool_filename..html APP;');
    put('PRO <h2>Top N</h2> ');
    put('SPO OFF');

    put('DEF title=''Top 15 Wait events for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''DBA_HIST_ACTIVE_SESS_HISTORY''');
    put('DEF skip_pch=''''');
    put('DEF slices = ''15''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT cpu_or_event,');
    put('       num_samples,');
    put('       TRUNC(100*RATIO_TO_REPORT(num_samples) OVER (),2) percent,');
    put('       NULL dummy_01');
    put('  FROM (SELECT object_node cpu_or_event,');
    put('               count(*) num_samples');
    put('          FROM plan_table');
    put('         WHERE cost =  '||i.plan_hash_value||'');
    put('           AND remarks = ''''&&sqld360_sqlid.'''''); 
    put('           AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('         GROUP BY object_node'); 
    put('         ORDER BY 2 DESC)');
    put(' WHERE rownum <= 15');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('DEF title=''Top 15 Objects accessed by PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''DBA_HIST_ACTIVE_SESS_HISTORY''');
    put('DEF skip_pch=''''');
    put('DEF slices = ''15''');
    put('BEGIN');
    put(' :sql_text := ''');
--    put('SELECT obj#,');
--    put('       num_samples,');
--    put('       TRUNC(100*RATIO_TO_REPORT(num_samples) OVER (),2) percent,');
--    put('       NULL dummy_01');
--    put('  FROM (SELECT NVL2(b.owner,b.owner||''''.''''||b.object_name,a.object_instance) obj#,');
--    put('               count(*) num_samples');
--    put('          FROM plan_table a,');
--    put('               dba_objects b');
--    put('         WHERE a.cost =  '||i.plan_hash_value||'');
--    put('           AND a.remarks = ''''&&sqld360_sqlid.'''''); 
--    put('           AND ''''&&diagnostics_pack.'''' = ''''Y''''');
--    put('           AND a.object_instance = b.data_object_id(+)');
--    put('           AND a.other_tag IN (''''Application'''',''''Cluster'''', ''''Concurrency'''', ''''User I/O'''', ''''System I/O'''')');
--    put('         GROUP BY NVL2(b.owner,b.owner||''''.''''||b.object_name,a.object_instance)'); 
--    put('         ORDER BY 2 DESC)');
--    put(' WHERE rownum <= 15');

--    put('SELECT object_name,');
--    put('       num_samples,');
--    put('       TRUNC(100*RATIO_TO_REPORT(num_samples) OVER (),2) percent,');
--    put('       NULL dummy_01');
--    put('  FROM (SELECT CASE WHEN data.object_name_sofar IS NOT NULL AND data.object_name_sofar <> ''''.'''' THEN data.object_name_sofar');
--    put('                    ELSE CASE WHEN o.owner||''''.''''||o.object_name <> ''''.'''' THEN o.owner||''''.''''||o.object_name'); 
--    put('                              ELSE TO_CHAR(data.obj#) ');
--    put('                         END ');
--    put('               END object_name,');
--    put('               data.num_samples');
--    put('          FROM (SELECT a.object_instance obj#,');
--    put('                       b.owner||''''.''''||b.object_name object_name_sofar,');
--    put('                       count(*) num_samples');
--    put('                  FROM plan_table a,');
--    put('                       dba_objects b');
--    put('                 WHERE a.cost =  '||i.plan_hash_value||'');
--    put('                   AND a.remarks = ''''&&sqld360_sqlid.'''''); 
--    put('                   AND ''''&&diagnostics_pack.'''' = ''''Y''''');
--    put('                   AND a.object_instance = b.object_id(+)');
--    put('                   AND a.other_tag IN (''''Application'''',''''Cluster'''', ''''Concurrency'''', ''''User I/O'''', ''''System I/O'''')');
--    put('                 GROUP BY b.owner||''''.''''||b.object_name,a.object_instance) data,');
--    put('                dba_objects o');
--    put('         WHERE data.obj# = o.data_object_id(+)');
--    put('         ORDER BY 2 DESC)');
--    put(' WHERE rownum <= 15');

    put('SELECT data.obj#||');
    put('       NVL(');
    put('       (SELECT TRIM(''''.'''' FROM '''' ''''||o.owner||''''.''''||o.object_name||''''.''''||o.subobject_name) FROM dba_objects o WHERE o.object_id = data.obj# AND ROWNUM = 1),'); 
    put('       (SELECT TRIM(''''.'''' FROM '''' ''''||o.owner||''''.''''||o.object_name||''''.''''||o.subobject_name) FROM dba_objects o WHERE o.data_object_id = data.obj# AND ROWNUM = 1)'); 
    put('       ) data_object,');
    put('       num_samples,');
    put('       TRUNC(100*RATIO_TO_REPORT(num_samples) OVER (),2) percent,');
    put('       NULL dummy_01');
    put('  FROM (SELECT a.object_instance obj#,');
    put('               count(*) num_samples');
    put('          FROM plan_table a');
    put('         WHERE a.cost =  '||i.plan_hash_value||'');
    put('           AND a.remarks = ''''&&sqld360_sqlid.'''''); 
    put('           AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('           AND a.other_tag IN (''''Application'''',''''Cluster'''', ''''Concurrency'''', ''''User I/O'''', ''''System I/O'''')');
    put('         GROUP BY a.object_instance'); 
    put('         ORDER BY 2 DESC) data');
    put(' WHERE rownum <= 15');

    put(''';');
	put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('DEF title=''Top 15 Plan Steps for PHV '||i.plan_hash_value||'''');
    put('DEF main_table = ''DBA_HIST_ACTIVE_SESS_HISTORY''');
    put('DEF skip_pch=''''');
    put('DEF slices = ''15''');
    put('BEGIN');
    put(' :sql_text := ''');
    put('SELECT operation,');
    put('       num_samples,');
    put('       TRUNC(100*RATIO_TO_REPORT(num_samples) OVER (),2) percent,');
    put('       NULL dummy_01');
    put('  FROM (SELECT id||'''' - ''''||operation operation,');
    put('               count(*) num_samples');
    put('          FROM plan_table');
    put('         WHERE cost =  '||i.plan_hash_value||'');
    put('           AND remarks = ''''&&sqld360_sqlid.'''''); 
    put('           AND ''''&&diagnostics_pack.'''' = ''''Y''''');
    put('         GROUP BY id||'''' - ''''||operation'); 
    put('         ORDER BY 2 DESC)');
    put(' WHERE rownum <= 15');
    put(''';');
    put('END;');
    put('/ ');
    put('@sql/sqld360_9a_pre_one.sql');

    put('----------------------------');

    put('SPO &&sqld360_main_report..html APP;');
    put('PRO </td>');
  END LOOP;
END;
/
SPO &&sqld360_main_report..html APP;
@sqld360_plans_analysis_&&sqld360_sqlid._driver.sql

SPO &&sqld360_main_report..html APP;
PRO </tr></table>
@@sqld360_0e_html_footer.sql
SPO OFF
SET PAGES 50000

HOS zip -mq &&sqld360_main_filename._&&sqld360_file_time. &&sqld360_main_report..html
HOS zip -jmq 99999_sqld360_&&sqld360_sqlid._drivers sqld360_plans_analysis_&&sqld360_sqlid._driver.sql

DEF sqld360_main_report = &&sqld360_main_report_bck.
