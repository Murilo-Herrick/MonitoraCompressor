# Projeto de Monitoramento IoT - Compressor

Este projeto consiste em um sistema completo para monitoramento e controle de um compressor industrial, com visualização via aplicativo mobile Flutter, integração via Node-RED, comunicação com dispositivos Arduino e backend para notificações e persistência de dados.

---

## Visão Geral

- **App Mobile (Flutter):**  
  Aplicativo para monitoramento em tempo real dos sensores de temperatura, umidade e pressão. Permite controlar o compressor (liga/desliga), persistência de login via Firebase e recebimento de notificações críticas.

- **Dispositivos Arduino (.ino):**  
  - **Slave Modbus:** Responsável pela comunicação via protocolo Modbus para coleta de dados.  
  - **Master/Controlador:** Responsável por controlar o dispositivo e enviar dados para o Node-RED.

- **Node-RED:**  
  Plataforma intermediária que integra os dados enviados pelos Arduinos e faz a ponte com o app Flutter, além de encaminhar dados para o backend Python.

- **Backend Python (`app.py`):**  
  Serviço responsável pelo envio de notificações críticas via Firebase Cloud Messaging (FCM) e persistência dos dados coletados em banco MySQL.

- **Docker:**  
  Ambiente conteinerizado que reúne o banco de dados MySQL, Node-RED e o backend Python para facilitar a implantação e manutenção do sistema.

---

## Funcionalidades

- Visualização gráfica em tempo real de temperatura, umidade e pressão no app Flutter.
- Controle remoto de ligar e desligar o compressor pelo app.
- Autenticação e persistência de login usando Firebase Authentication.
- Recebimento de notificações push para alertas críticos relacionados ao compressor.
- Comunicação entre Arduino e Node-RED para coleta e envio de dados.
- Armazenamento dos dados históricos no banco MySQL para análises futuras.
- Ambiente Docker para fácil deploy e escalabilidade do sistema.

---

## Estrutura do Repositório
/
├── mobile_flutter/ # Código fonte do app Flutter
├── IOT/ # Código .ino para os dispositivos Slave e Master
│ ├── slave_modbus.ino
│ └── master_control.ino
├── backend/ # Backend Python com app.py para notificações e persistência
├── node-red/ # Fluxos e configurações do Node-RED
├── docker/ # Arquivos Docker e docker-compose para ambiente conteinerizado
└── README.md


---

## Tecnologias Utilizadas

- **Flutter:** Aplicativo mobile multiplataforma.
- **Firebase Authentication:** Login e autenticação de usuários.
- **Firebase Cloud Messaging (FCM):** Envio de notificações push.
- **Arduino (C++):** Código dos dispositivos sensores/controladores.
- **Node-RED:** Orquestração e integração dos dados IoT.
- **Python (Flask ou FastAPI):** Backend para notificações e persistência.
- **MySQL:** Banco de dados relacional para armazenamento.
- **Docker / Docker Compose:** Contêineres para banco, backend e Node-RED.

---

## Como Rodar o Projeto

1. **Configurar o ambiente Docker:**
   ```bash
   docker-compose up -build

2. **baixar o apk do flutter**
