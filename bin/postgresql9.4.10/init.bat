@ECHO OFF

%~dp0bin\initdb.exe -U postgres -A trust -E utf8 -D "%~dp0data" > "~NEARD_WIN_PATH~\logs\postgresql-install.log" 2>&1
copy /y "%~dp0postgresql.conf.nrd" "%~dp0data\postgresql.conf"
copy /y "%~dp0pg_hba.conf.nrd" "%~dp0data\pg_hba.conf"
