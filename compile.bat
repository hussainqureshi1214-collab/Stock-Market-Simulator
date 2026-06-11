@echo off
echo ============================================
echo  Compiling Pakistan Stock Market Simulator
echo ============================================

set JAVAFX_PATH=A:\openjfx-26_windows-x64_bin-sdk\javafx-sdk-26\lib
set MYSQL_JAR=lib\mysql-connector-j-8.3.0.jar

if not exist out mkdir out

echo Compiling all Java files...
javac --module-path "%JAVAFX_PATH%" --add-modules javafx.controls,javafx.graphics -cp "%MYSQL_JAR%" -d out -sourcepath src src\com\psms\*.java src\com\psms\chart\*.java src\com\psms\database\*.java src\com\psms\manager\*.java src\com\psms\model\*.java src\com\psms\view\*.java

if %ERRORLEVEL% == 0 (
    echo Copying resources...
    copy /Y src\com\psms\view\dark-scrollbar.css out\com\psms\view\ >nul 2>&1
    echo.
    echo [SUCCESS] Compilation complete! Run 'run.bat' to start the app.
) else (
    echo.
    echo [ERROR] Compilation failed. Check errors above.
)
pause
