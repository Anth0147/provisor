@echo off
:: Forzar a la consola de Windows a usar UTF-8 (Para imprimir ñ y tildes sin romperse)
chcp 65001 >nul 2>&1
set PYTHONUTF8=1

echo ==========================================
echo      INICIADOR AUTOMATICO DEL PROYECTO
echo ==========================================
echo.

:: 1. Verificar Python 3.13.3
echo [1/4] Verificando Python 3.13.3...
python --version 2>&1 | findstr /C:"Python 3.13.3" >nul
if errorlevel 1 (
    echo [ERROR] No se encontro Python 3.13.3 instalado.
    echo Por favor, descargalo e instalalo desde python.org y marca la opcion "Add to PATH".
    pause
    exit /b 1
)
echo [OK] Python 3.13.3 detectado correctamente.
echo.

:: 2. Verificar Librerias
echo [2/4] Verificando librerias necesarias...
python -c "import playwright, tqdm, psycopg2, psutil, ddddocr" 2>nul
if errorlevel 1 (
    echo [AVISO] Faltan librerias. Instalando automaticamente...
    pip install playwright tqdm psycopg2-binary psutil ddddocr
    if errorlevel 1 (
        echo [ERROR] Ocurrio un problema al instalar las librerias.
        pause
        exit /b 1
    )
    echo [OK] Librerias instaladas.
) else (
    echo [OK] Todas las librerias estan instaladas.
)
echo.

:: 3. Verificar Navegadores de Playwright
echo [3/4] Verificando navegador Chromium de Playwright...
:: Hacemos una comprobación rápida intentando importar y lanzar chromium oculto
python -c "from playwright.sync_api import sync_playwright; p=sync_playwright().start(); b=p.chromium.launch(headless=True); b.close(); p.stop()" 2>nul
if errorlevel 1 (
    echo [AVISO] Chromium no encontrado. Descargando e instalando...
    playwright install chromium
    if errorlevel 1 (
        echo [ERROR] No se pudo descargar Chromium. Revisa tu conexion a internet.
        pause
        exit /b 1
    )
    echo [OK] Chromium instalado.
) else (
    echo [OK] Chromium listo.
)
echo.

:: 4. Ejecutar Main
echo [4/4] Iniciando el programa principal...
echo ==========================================
echo.

:: Ejecutar con argumento --auto para que el script de Python use el WOP
python main.py --auto

:: Pausa final para que la consola no se cierre si hay un error y puedas leerlo
pause