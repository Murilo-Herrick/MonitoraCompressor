/**
  Introdução ao uso do Modbus RTU com Opta™
  Nome: Opta_Cliente
  Objetivo: Escreve valores em Coils e Holding Registers; Lê valores de Coils, Entradas Discretas, Holding Registers e Input Registers.

  @autor Arduino
*/

#include <ArduinoModbus.h>
#include <ArduinoRS485.h> // A biblioteca ArduinoModbus depende da ArduinoRS485
#include <Ethernet.h>

byte mac[] = { 0xA8, 0x61, 0x0A, 0x50, 0x4C, 0x7F };//endereço do dispositivo

IPAddress ip(192, 168, 1, 200);

EthernetServer server= EthernetServer(80);

constexpr auto baudrate { 9600 };

// Calcula os atrasos preDelay e postDelay em microssegundos conforme a especificação do Modbus RTU
// Guia de especificação e implementação do MODBUS sobre linha serial V1.02
// Parágrafo 2.5.1.1 - Enquadramento de mensagem RTU do MODBUS
// https://modbus.org/docs/Modbus_over_serial_line_V1_02.pdf
constexpr auto bitduration { 1.f / baudrate };
constexpr auto preDelayBR { bitduration * 9.6f * 3.5f * 1e6 };
constexpr auto postDelayBR { bitduration * 9.6f * 3.5f * 1e6 };
// constexpr auto preDelayBR { bitduration * 10.0f * 3.5f * 1e6 };

int counter = 0;

void setup() {

  Ethernet.begin(mac, ip);
  server.begin();
  delay(1000);
  Serial.print("IP Local: ");
  Serial.println(Ethernet.localIP());

    Serial.begin(9600);
    while (!Serial);

    Serial.println("Cliente Modbus RTU");

    RS485.setDelays(preDelayBR, postDelayBR);

    // Inicia o cliente Modbus RTU
    if (!ModbusRTUClient.begin(baudrate, SERIAL_8N1)) {
        Serial.println("Falha ao iniciar o Cliente Modbus RTU!");
        while (1);
    }

    // EthernetClient client = server.on("/dados", HTTP_GET, handleDados);
     //server.begin();
}

void loop() {
    //writeCoilValues();

    //readCoilValues();

    //readDiscreteInputValues();

    //writeHoldingRegisterValues();
    //readInputRegisterValues();

   //EnthernetClient client = server.handleClient();

  readHoldingRegisterValues();

  

    counter++;

    delay(1000);
    Serial.println();
}
/*
void handleDados() {
  if (!ModbusRTUClient.requestFrom(1, HOLDING_REGISTERS, 0x01, 2)) {
    EthernetClient client = server.send(500, "text/plain", "Erro no Modbus");
    return;
  }

}
/**
  Escreve valores em Coils no servidor no endereço especificado.
*/
/*void writeCoilValues() {
    // Define os Coils como 1 quando o contador é ímpar
    byte coilValue = ((counter % 2) == 0) ? 0x00 : 0x01;

    Serial.print("Escrevendo valores em Coils ... ");

    // Escreve 10 valores em Coils para o servidor com ID 42, endereço 0x00
    ModbusRTUClient.beginTransmission(42, COILS, 0x00, 10);
    for (int i = 0; i < 10; i++) {
        ModbusRTUClient.write(coilValue);
    }
    if (!ModbusRTUClient.endTransmission()) {
        Serial.print("falhou! ");
        Serial.println(ModbusRTUClient.lastError());
    } else {
        Serial.println("sucesso");
    }

    // Alternativamente, para escrever um único valor Coil, use:
    // ModbusRTUClient.coilWrite(...)
}

/**
  Lê valores de Coils do servidor no endereço especificado.
*/
/*void readCoilValues() {
    Serial.print("Lendo valores de Coils ... ");

    // Lê 10 valores de Coils do servidor com ID 42, endereço 0x00
    if (!ModbusRTUClient.requestFrom(1, COILS, 0x00, 10)) {
        Serial.print("falhou! ");
        Serial.println(ModbusRTUClient.lastError());
    } else {
        Serial.println("sucesso");

        while (ModbusRTUClient.available()) {
            Serial.print(ModbusRTUClient.read());
            Serial.print(' ');
        }
        Serial.println();
    }

    // Alternativamente, para ler um único valor Coil, use:
    // ModbusRTUClient.coilRead(...)
}

/**
  Lê valores de Entradas Discretas do servidor no endereço especificado.
*/
/*void readDiscreteInputValues() {
    Serial.print("Lendo valores de Entradas Discretas ... ");

    // Lê 10 valores de Entradas Discretas do servidor com ID 42, endereço 0x00
    if (!ModbusRTUClient.requestFrom(42, DISCRETE_INPUTS, 0x00, 10)) {
        Serial.print("falhou! ");
        Serial.println(ModbusRTUClient.lastError());
    } else {
        Serial.println("sucesso");

        while (ModbusRTUClient.available()) {
            Serial.print(ModbusRTUClient.read());
            Serial.print(' ');
        }
        Serial.println();
    }

    // Alternativamente, para ler uma única Entrada Discreta, use:
    // ModbusRTUClient.discreteInputRead(...)
}

/**
  Escreve valores nos Holding Registers do servidor no endereço especificado.
*/
/*void writeHoldingRegisterValues() {
    // Define os valores dos Holding Registers como o valor do contador
    Serial.print("Escrevendo valores em Holding Registers ... ");

    // Escreve 10 valores em Holding Registers para o servidor com ID 42, endereço 0x00
    ModbusRTUClient.beginTransmission(42, HOLDING_REGISTERS, 0x00, 10);
    for (int i = 0; i < 10; i++) {
        ModbusRTUClient.write(counter);
    }
    if (!ModbusRTUClient.endTransmission()) {
        Serial.print("falhou! ");
        Serial.println(ModbusRTUClient.lastError());
    } else {
        Serial.println("sucesso");
    }

    // Alternativamente, para escrever um único Holding Register, use:
    // ModbusRTUClient.holdingRegisterWrite(...)
}

/**
  Lê valores dos Holding Registers do servidor no endereço especificado.
*/
void readHoldingRegisterValues() {
    Serial.print("Lendo valores de Holding Registers ... ");

    // Lê 10 valores de Holding Registers do servidor com ID 1, endereço 0x01
    if (!ModbusRTUClient.requestFrom(1, HOLDING_REGISTERS, 0x01, 10)) {
        Serial.print("falhou! ");
        Serial.println(ModbusRTUClient.lastError());
    } else {
        Serial.println("sucesso");

        while (ModbusRTUClient.available()) {
            Serial.print(ModbusRTUClient.read());
            Serial.print(' ');
        }
        Serial.println();
    }

    // Alternativamente, para ler um único Holding Register, use:
    // ModbusRTUClient.holdingRegisterRead(...)
}

/**
  Lê valores dos Input Registers do servidor no endereço especificado.
*/
void readInputRegisterValues() {
    Serial.print("Lendo valores de Input Registers ... ");

    // Lê 10 valores de Input Registers do servidor com ID 42
    if (!ModbusRTUClient.requestFrom(42, INPUT_REGISTERS, 0x00, 10)) {
        Serial.print("falhou! ");
        Serial.println(ModbusRTUClient.lastError());
    } else {
        Serial.println("sucesso");

        while (ModbusRTUClient.available()) {
            Serial.print(ModbusRTUClient.read());
            Serial.print(' ');
        }
        Serial.println();
    }

    // Alternativamente, para ler um único Input Register, use:
    // ModbusRTUClient.inputRegisterRead(...)
}
