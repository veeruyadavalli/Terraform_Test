@echo off
setlocal enabledelayedexpansion

set TF_DIR=%~dp0
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
REM Check plan file
REM ==============================
if not exist "%TF_DIR%tfplan" (
    echo ERROR: No tfplan file found. Run deploy_plan.bat first.
    exit /b 1
)

echo ---------------------------------------
echo APPLYING Terraform Plan...
echo ---------------------------------------
cd /d %TF_DIR%
terraform apply -input=false "tfplan"

if %ERRORLEVEL% EQU 0 (
    echo Deployment applied successfully.
) else (
    echo Deployment failed.
)
