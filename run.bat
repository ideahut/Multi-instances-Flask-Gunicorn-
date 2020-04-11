@echo off

set PYTHON=D:\04_PROJECT\FLASK\api\.venv\Scripts\python.exe
set GUNICORN=D:\04_PROJECT\FLASK\api\.venv\Scripts\gunicorn.exe
set WORKER=10
set THREAD=10
set PORTS=(34001 34002 34003 34004)

(for %%i in %PORTS% do ( 
	rem start "Flask API (Port: %%i)" %GUNICORN% --workers=%WORKER% --threads=%THREAD% --worker-class=gthread -b 0.0.0.0:%%i sample:app
	start "Flask API (Port: %%i)" %PYTHON% sample.py %%i
))
exit
