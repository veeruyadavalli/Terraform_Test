@echo off
setlocal

echo === Terraform Destroy Automation ===
echo.

REM Load environment variables from .env file
for /f "tokens=* delims=" %%i in (.env) do set %%i

REM Select environment and customer interactively
set /p ENVIRONMENT="Enter environment (dev/test/stage/prod): "
set /p CUSTOMER="Enter customer name: "

set TFVARS_FILE=./customers/%CUSTOMER%/%ENVIRONMENT%.tfvars

REM Initialize Terraform
terraform init

echo.
echo What would you like to destroy?
echo [1] Entire environment (%ENVIRONMENT%) for customer %CUSTOMER%
echo [2] A specific resource only
echo.
set /p CHOICE="Enter your choice (1 or 2): "

if "%CHOICE%"=="1" (
    echo Destroying entire environment for %CUSTOMER% - %ENVIRONMENT%
    terraform destroy -var-file="%TFVARS_FILE%" -auto-approve
    goto :exitcode
)

if "%CHOICE%"=="2" (
    echo.
    echo Enter the resource address you want to destroy.
    echo Example: module.storage_accounts["data"]
    echo.
    set /p RESOURCE="Resource address: "
    echo Destroying only %RESOURCE% ...
    terraform destroy -target=%RESOURCE% -var-file="%TFVARS_FILE%" -auto-approve
    goto :exitcode
)

echo Invalid option selected.
goto :exitcode

:exitcode
if %errorlevel% neq 0 (
    echo Terraform destroy failed with exit code %errorlevel%.
    exit /b %errorlevel%
) else (
    echo Terraform destroy completed successfully.
    exit /b 0
)
