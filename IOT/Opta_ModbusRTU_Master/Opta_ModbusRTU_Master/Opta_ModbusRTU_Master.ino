/**
  Introdução ao uso do Modbus RTU com Opta™
  Nome: Opta_Cliente
  Objetivo: Escreve valores em Coils e Holding Registers; Lê valores de Coils, Entradas Discretas, Holding Registers e Input Registers.

  @autor Arduino
*/
#include <ArduinoHttpClient.h>
#include <ArduinoModbus.h>
#include <ArduinoRS485.h>  // A biblioteca ArduinoModbus depende da ArduinoRS485
#include <Ethernet.h>
#include <PubSubClient.h> 
#include <ArduinoJson.h>



byte mac[] = { 0xA8, 0x61, 0x0A, 0x50, 0x4C, 0x7F };  //Endereço MAC  DA PLACA DE ETHERNET DO OPTA 
char serverAddress[] = "10.110.18.6";  // VARIAVEL PARA ENDEREÇO DE REDE DO SERVER, DEIXAR VAZIO SE FOR ATRIBUIR DHCP
int port = 9095;    //PORTA PARACOMUNICAÇÃO NODE-RED

EthernetClient ethClient;                                       //Cuida da conexão física (TCP).
HttpClient client = HttpClient(ethClient, serverAddress, port);// Usa o EthernetClient para fazer comunicações HTTP.

EthernetServer server = EthernetServer(80);
String dadosSensores[3];

constexpr auto baudrate{ 9600 };

// Calcula os atrasos preDelay e postDelay em microssegundos conforme a especificação do Modbus RTU
// Guia de especificação e implementação do MODBUS sobre linha serial V1.02
// Parágrafo 2.5.1.1 - Enquadramento de mensagem RTU do MODBUS
// https://modbus.org/docs/Modbus_over_serial_line_V1_02.pdf
constexpr auto bitduration{ 1.f / baudrate };
constexpr auto preDelayBR{ bitduration * 9.6f * 3.5f * 1e6 };
constexpr auto postDelayBR{ bitduration * 9.6f * 3.5f * 1e6 };
//constexpr auto preDelayBR { bitduration * 10.0f * 3.5f * 1e6 };

bool bobina = false;

void setup() {

  ModbusRTUClient.setTimeout(2000);
  Serial.begin(9600);
  while (!Serial);


  //SETUP PARA COMUNICAÇÃO COM ETHERNET VIA CABO, 
  Serial.println("Inicializando Ethernet via DHCP...");

  //Inicializa Ethernet com DHCP
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Falha ao configurar Ethernet via DHCP");
    while (true);  // trava o programa se DHCP falhar
  }

  server.begin();
  delay(1000);

  Serial.print("IP Local via DHCP: ");
  Serial.println(Ethernet.localIP());

  Serial.println("Cliente Modbus RTU");

  RS485.setDelays(preDelayBR, postDelayBR);// TEMPO PARA TRANMISSÃO E RECEPÇÃO DOS DADOS 

  // Inicia o cliente Modbus RTU
  if (!ModbusRTUClient.begin(baudrate, SERIAL_8N1)) {
    Serial.println("Falha ao iniciar o Cliente Modbus RTU!");
    while (1);
  }
}

void loop() {
  // Testes escrita bobina 

  writeCoilValues(); 
  delay(2000);
     
    
   
  //delay(500);
  Serial.println("__________________________________________________________________"); 
  String dadosSensores[3];
  String leitura = readHoldingRegisterValues(); //valores do registrador modbus 

  // Usando split para preencher o vetor diretamente
  for (int i = 0; i < 4; i++) {
    dadosSensores[i] = leitura.substring(0, leitura.indexOf(','));
    leitura = leitura.substring(leitura.indexOf(',') + 1);
  }

  // Atribuindo os valores do vetor a variáveis separadas
  String tempAmbiente = dadosSensores[0];
  String humity = dadosSensores[1];
  String pressao = dadosSensores[2];

  delay(2000);

  Serial.println("Leitura das bobinas -----");
  String dadosBobina = readCoilValues(); 
  Serial.println("__________________________________________________________________");
  
  delay(500);

  Serial.println("__________________________________________________________________");

  // VARIAVEL PARA USO NO GET E POST ;
//  readHoldingRegisterValues();

  sendReadingsToNodeRED(tempAmbiente, humity, dadosBobina, pressao);

  Serial.println("final");
  
  client.stop(); 

 // Serial.println(dadosSensores);
  Serial.println("__________________________________________________________________");

  delay(2000);
 
}
 
void sendReadingsToNodeRED(String tempAmbiente, String humity, String dadosBobina, String pressao) {
  String json = "{\"temperatura\":" + tempAmbiente +",\"umidade\":"+ humity +",\"dadosBobinas\":" + dadosBobina + ",\"pressao\":" + pressao + "}";

  Serial.println(json);
  
  client.beginRequest();
  client.post("/modbus", "application/json", json);
  client.endRequest();
}

bool getBobinaFromNodeRED() {
  client.get("/bobina");
  int statusCode = client.responseStatusCode();

  if (statusCode == 200) {
    String response = client.responseBody();
    Serial.println("Resposta: " + response);

    StaticJsonDocument<200> doc;
    DeserializationError error = deserializeJson(doc, response);

    if (error) {
      Serial.print("Erro ao analisar JSON: ");
      Serial.println(error.f_str());
      return false;
    }

    bobina = doc["bobina"];
    Serial.print("Bobina json: ");
    Serial.println(bobina);
    return bobina;

  } else {
    Serial.print("Erro HTTP: ");
    Serial.println(statusCode);
    return false;
  }
}

/*
  Escreve valores em Coils no servidor no endereço especificado.
*/

void writeCoilValues() {

    byte coilValue;
    bobina = getBobinaFromNodeRED();

    if (bobina){
      coilValue = 0x00;
    }
    else{
      coilValue = 0x01;
    }

    Serial.print("Escrevendo valores em Coil ... ");

    // Escreve 1 valor em Coil no servidor ID 1, endereço 0x00
    if (!ModbusRTUClient.coilWrite(1, 0x00, coilValue)) {
        Serial.print("falhou! ");
        Serial.println(ModbusRTUClient.lastError());
    } else {
        Serial.println("sucesso");
    }
}


/**
  Lê valores de Coils do servidor no endereço especificado.
*/

String readCoilValues() {
    Serial.print("Lendo valores de Coils ... ");
    String coilResultado;
    // Lê 10 valores de Coils do servidor com ID 42, endereço 0x00
    if (!ModbusRTUClient.requestFrom(1, COILS, 0x00, 1)) {
        Serial.print("falhou! ");
        Serial.println(ModbusRTUClient.lastError());
    } else {
        Serial.println("sucesso");

        while (ModbusRTUClient.available()) {
            int dado = ModbusRTUClient.read();

            if (coilResultado.length() > 0) {
                coilResultado += ",";
            }

          coilResultado += String(dado);
          Serial.print(coilResultado);
          Serial.print(' ');
        }
        return coilResultado;
        Serial.println();
    }

    // Alternativamente, para ler um único valor Coil, use:
    // ModbusRTUClient.coilRead(...)
}

String readHoldingRegisterValues() {
  Serial.print("Lendo valores de Holding Registers ... ");
  String SensoresResultado;

  // Lê 10 valores de Holding Registers do servidor com ID 1, endereço 0x01
  if (!ModbusRTUClient.requestFrom(1, HOLDING_REGISTERS, 0x01, 3)) {
    Serial.print("falhou! ");
    Serial.println(ModbusRTUClient.lastError());
  } else {
    Serial.println("sucesso");

    while (ModbusRTUClient.available()) {

      int dado = ModbusRTUClient.read();
      if (SensoresResultado.length() > 0) {
        SensoresResultado += ",";
      }

      SensoresResultado += String(dado);
      Serial.print(SensoresResultado);
      Serial.print(' ');
    }
    Serial.println();
    return SensoresResultado;
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


  // Alternativamente, para ler um único Holding Register, use:
  // ModbusRTUClient.holdingRegisterRead(...)
}

/**
  Lê valores dos Input Registers do servidor no endereço especificado.
*/
/*void readInputRegisterValues() {
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
}*/
