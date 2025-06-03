import os
from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, messaging
import mysql.connector

app = Flask(__name__)

db_config = {
    'host': 'db',
    'user': 'root',
    'password': '1234',
    'database': 'compressor'
}

base_dir = os.path.dirname(os.path.abspath(__file__))
firebase_key_path = os.path.join(base_dir, 'firebase-key.json')

cred = credentials.Certificate(firebase_key_path)
firebase_admin.initialize_app(cred)

@app.route('/sendNoti', methods=['POST'])
def send_notification():
    data = request.json or {}
    evento = data.get('evento', 'desconhecido')

    if evento == 'ligar':
        title = "Compressor Ligado"
        body = f"O compressor foi ligado às {data.get('hora', 'hora desconhecida')}."
    elif evento == 'desligar':
        title = "Compressor Desligado"
        body = f"O compressor foi desligado às {data.get('hora', 'hora desconhecida')}."
    elif evento == 'critico':
        title = "Alerta Crítico"
        body = data.get('mensagem', 'Dados fora do padrão detectados.')
    else:
        title = "Compressor"
        body = "Um evento desconhecido foi registrado."

    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body),
        topic="all"
    )
    response = messaging.send(message)
    return jsonify({"status": "success", "response": response})


@app.route('/saveDB', methods=['POST'])
def save_db():
    data = request.json or {}

    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""" INSERT INTO compressor (
                       horario,
                       temperatura,
                       umidade,
                       pressao,
                       estado,
                       notificacao
                       ) VALUES (%s, %s, %s, %s, %s, %s) """,
                       (
                            data.get("horario"),
                            data.get("temperatura"),
                            data.get("umidade"),
                            data.get("pressao"),
                            data.get("estado"),
                            data.get("notificacao")
                        ))
        conn.commit()
        cursor.close()
        conn.close()
    
        return jsonify({"message": "Dados salvos no banco com sucesso!"}), 200
    except Exception as e:
        return jsonify({"message": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
