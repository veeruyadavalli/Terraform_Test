@echo off
setlocal enabledelayedexpansion

set TF_DIR=%~dp0
set CUSTOMERS_DIR=%TF_DIR%customers
set ENV_FILE=%TF_DIR%.env

REM ==============================
REM Load .env credentials
REM ==============================
if not exist "%ENV_FILE%" (
    echo ERROR: .env file not found in %TF_DIR%.
    exit /b 1
)
for /f "tokens=1,2 delims==" %%a in ('type "%ENV_FILE%"') do (
    set %%a=%%b
)

echo Loaded Azure Service Principal credentials from .env
echo.

REM ==============================
REM Select Customer
REM ==============================
echo Available customers:
set i=0
for /d %%C in (%CUSTOMERS_DIR%\*) do (
    set /a i+=1
    set CUSTOMER_!i!=%%~nC
    echo   !i!. %%~nC
)
echo.
set /p cust_choice="Select a customer by number: "
set SELECTED_CUSTOMER=!CUSTOMER_%cust_choice%!
if "%SELECTED_CUSTOMER%"=="" (
    echo Invalid customer selection.
    exit /b 1
)
set CUSTOMER_DIR=%CUSTOMERS_DIR%\%SELECTED_CUSTOMER%
echo You selected customer: %SELECTED_CUSTOMER%
echo.

REM ==============================
REM Select Environment
REM ==============================
echo Available environments for %SELECTED_CUSTOMER%:
set j=0
for %%E in (%CUSTOMER_DIR%\*.tfvars) do (
    set /a j+=1
    set ENVFILE_!j!=%%~fE
    set ENVNAME_!j!=%%~nE
    echo   !j!. %%~nE
)
echo.
set /p env_choice="Select environment by number: "
set SELECTED_ENVFILE=!ENVFILE_%env_choice%!
set SELECTED_ENVNAME=!ENVNAME_%env_choice%!

if "%SELECTED_ENVFILE%"=="" (
    echo Invalid environment selection.
    exit /b 1
)
echo ---------------------------------------
echo PLAN for %SELECTED_CUSTOMER% - %SELECTED_ENVNAME%
echo ---------------------------------------

cd /d %TF_DIR%
terraform init -input=false
terraform validate
terraform plan -input=false -var-file="%SELECTED_ENVFILE%" -out=tfplan

if %ERRORLEVEL% EQU 0 (
    echo Plan completed successfully.
    echo Plan saved to tfplan file.
) else (
    echo Plan failed.
)
