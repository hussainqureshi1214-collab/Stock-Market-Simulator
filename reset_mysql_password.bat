@echo off
echo =============================================
echo  MySQL Root Password Reset v2
echo  ** RIGHT-CLICK AND RUN AS ADMINISTRATOR **
echo =============================================
echo.

echo [1/5] Stopping MySQL service...
net stop MySQL80
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Could not stop MySQL. Are you running as Administrator?
    echo Right-click this file and select "Run as administrator"
    pause
    exit /b 1
)
timeout /t 3 /nobreak > nul

echo [2/5] Starting MySQL with --init-file to reset password...
start "" /B "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe" --init-file="A:\c\PakistanStockMarketSimulator\mysql_reset.sql" --console
timeout /t 8 /nobreak > nul

echo [3/5] Stopping mysqld after password reset...
taskkill /IM mysqld.exe /F >nul 2>&1
timeout /t 5 /nobreak > nul

echo [4/5] Restarting MySQL service normally...
net start MySQL80
timeout /t 3 /nobreak > nul

echo [5/5] Testing connection with empty password...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --skip-password -e "SELECT 'SUCCESS: Password reset complete!' AS result;"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =============================================
    echo  SUCCESS! Root password is now empty.
    echo  You can now run compile.bat and run.bat
    echo =============================================
) else (
    echo.
    echo =============================================
    echo  FAILED. Try running MySQL Installer instead:
    echo  1. Open MySQL Installer
    echo  2. Click "Reconfigure" on MySQL Server
    echo  3. Set root password to empty
    echo =============================================
)
echo.
pause
