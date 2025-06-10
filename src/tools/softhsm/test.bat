unset KRYOPTIC_CONF
set P11LIB=%cd%\target\debug\kryoptic_pkcs11.dll
set TARGET_DIR="target\debug"

set TOKDIR="%cd%\test\softhsm"
mkdir -p "%TOKDIR%"
del -f "%TOKDIR%\token.sql"
del -f "C:\\Windows\\Temp\\token.sql"

set PINVALUE="12345678"
set KRYOPTIC_CONF=%cd%\testdata\windows_test.conf
set TOKENLABEL="Kryoptic Token"
set TOKENLABELURI="Kryoptic%20Token"
set LOGFILE=%TOKDIR%"\migration.log"
set SOFTHSM_TOKEN="testdata\softhsm\tokens\9a19985a-9037-e9df-657d-9947f7ba2120"

%TARGET_DIR%\\kryoptic_init -m %P11LIB% -s %PINVALUE% -p %PINVALUE% -l %TOKENLABEL% >>%LOGFILE% 2>&1

%TARGET_DIR%\\softhsm_migrate -m %P11LIB% -i %KRYOPTIC_CONF% ^
   -p %PINVALUE% -q %PINVALUE% %SOFTHSM_TOKEN% >>%LOGFILE% 2>&1

%TARGET_DIR%\\test_signature -m %P11LIB% -p %PINVALUE% >>%LOGFILE% 2>&1

echo "all ok"