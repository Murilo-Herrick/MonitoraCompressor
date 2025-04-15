#include <Modbus.h>
#include <ModbusSerial.h>
#include <SoftwareSerial.h>

//SoftwareSerial mySerial(11,10);
#define Mod_SLAVE 1
const byte rxPin = 11;
const byte txPin = 10;
SoftwareSerial mySerial(rxPin,txPin);

//definição de pino 0 para entrada analogica
#define TEMP_SENSOR A0



// criando o objeto do tipo modbus
ModbusSerial mb;

// nao sei se preciso usar 
uint16_t tempRegistrador = 200;



void setup() {

  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);

  // defininfo o pino analogico 
  //configura o pino como entrada dos dados na leitura do sensor 
  pinMode(TEMP_SENSOR, INPUT);
  mySerial.begin(9600);
  Serial.begin(115200);
  
  float tempReal;
  
  


  //Configurando os parametros Modbus 
  mb.config(&mySerial, 9600,13);
  mb.setSlaveId(1);

// adicionando 3 saidas ficticias D0.0,D0.1,D0.2 (valores bolleanos)
// endereços 00000/00001/00002- endereçamento ModBus 

//mb.addCoil(0, false);
//mb.addCoil(1, true);
//mb.addCoil(2, true);

// Entradas Digitais ficticias D1.0/D1.1
//(Endereçamento 10000/10001)

//mb.addIsts(0,true );
//mb.addIsts(0, false );

//adicionando a entrada do registrador de leitura temp,
//mb.addIreg(0, 0);
//mb.addIreg(1, 28);  

  // adicionando HoldingRedisters Saida analogica-40000(Float)
  //Adicionando Memoria valor digital (Display)-End.40002(Int)

mb.addHreg(1);// saida analogica 

//mb.addHreg(2, 0);// valor display entrada de dados digitais 

  


}

void loop() {

 mb.task();

// definição da variavel para receber os dados convertidos na temperatura;


  float leituraTemp = analogRead(TEMP_SENSOR);
  float tempReal = leituraTemp * (5.0/1024.0)* 100.0;

  tempRegistrador = static_cast<uint16_t>(tempReal);  // Converte para uint16_t para o Modbus
  bool byte=mb.Hreg(1,tempRegistrador);
  int byte2 = mb.Hreg(1);
  Serial.println(byte2);
 
 delay(1000);

  

  
}
