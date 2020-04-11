# Flask API Samples
Multi instance Flask API sample using Gunicorn

# Steps:
1. Create virtual environment: 
     virtualenv.exe .venv
2. Activate virtualenv:
     Windows -> .venv\Scripts\activate.bat
     Linux   -> source .venv\bin\activate
3. Import library:
     -> pip install flask
     -> pip install gunicorn
4. Edit sample.py, change path PYTHON & GUNICORN into your local virtualenv path
5. Run sample:
     Windows: run.bat
     Linux: ./run.sh

# Notes:
- Gunicorn is not supported for Windows