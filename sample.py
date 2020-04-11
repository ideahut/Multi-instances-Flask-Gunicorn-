# Dependencies
import sys
import traceback
import datetime
import logging
import logging.handlers
import time
from flask import Flask, request, jsonify

# Flask
app = Flask(__name__)

# Logger
log_formatter = logging.Formatter('%(levelname)s %(asctime)s %(module)s(line: %(lineno)d): %(message)s')
log_file_handler = logging.handlers.TimedRotatingFileHandler('logs/template.log', when='midnight', encoding='utf-8')
log_file_handler.setFormatter(log_formatter)
log_file_handler.suffix = '%Y-%m-%d'
logger = logging.getLogger(__name__)
logger.addHandler(log_file_handler)
logger.setLevel(logging.DEBUG)


@app.route('/hello', methods=['GET', 'POST'])
def hello():
    log_id = str(time.time())
    text = 'Buddy'
    if 'text' in request.args:
        text = request.args.get("text")
    logger.info('{}: Hello {}'.format(log_id, text))
    return jsonify({'hello': text})


@app.route('/forgive', methods=['GET', 'POST'])
def forgive():
    log_id = str(time.time())
    text = 'me'
    if 'text' in request.args:
        text = request.args.get("text")
        logger.info('{}: Please forgive {}'.format(log_id, text))
        return jsonify({'sorry': text})
    else:
        logger.info('{}: Get error about {}'.format(log_id, text))
        return jsonify({'error_about': text})

@app.route('/sample', methods=['GET', 'POST'])
def sample():
    # Put your logic here !!
    return jsonify({'response': 'OK'})   


if __name__ == '__main__':
    if len(sys.argv) < 2:
        raise Exception('Invalid arguments')
    port = int(sys.argv[1])
    app.run(host='0.0.0.0', port=port, debug=True)

