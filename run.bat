@echo off
echo ============================================
echo  Pakistan Stock Market Simulator
echo  Developed by Hussain Raza Qureshi
echo ============================================
echo.

set JAVAFX_PATH=A:\openjfx-26_windows-x64_bin-sdk\javafx-sdk-26\lib
set MYSQL_JAR=lib\mysql-connector-j-8.3.0.jar

java --module-path "%JAVAFX_PATH%" --add-modules javafx.controls,javafx.graphics -cp "out;%MYSQL_JAR%" com.psms.Launcher

pause
