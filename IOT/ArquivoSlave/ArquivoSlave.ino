#include <Modbus.h>
#include <ModbusSerial.h>
#include <SoftwareSerial.h>
#include <DHT11.h> 
#include "HX711.h"

#define DT  4
#define SCK  3

//SoftwareSerial mySerial(11,10);
#define Mod_SLAVE 1
const byte rxPin = 11;
const byte txPin = 10;
SoftwareSerial mySerial(rxPin,txPin);

//definição de pino 0 para entrada analogica
#define TEMP_SENSOR A0

//pinagem de controle comunicação modbus(Conversor  Max485)
#define ControlPin 13
#define pinSensorCorr 3
//Porta ligada ao pino IN1 do modulo
#define rele1 7

//COMPONENTE DHT11 SENSOR DE TEMP E HUMIDADE
DHT11 dht11(2);

int result;


// CRIAÇÃO DO OBJETO SLAVE MODBUS
ModbusSerial mb;

// VARIAVEIS GLOBAIS   
uint16_t tempRegistrador;
uint16_t tempRegistrador2;
uint16_t registrador3;
float correnteReal;
bool compressor;
float tempReal;
int humidity;
float valorSensor;
uint16_t tempMotor;
uint16_t byte1 ;
uint16_t byte2;
float pressRead;

bool estadoCoil;

bool estadoRele1;

HX711 scale;

// Valores de calibração — substitua pelos seus valores reais de leitura
const long OFFSET = 7500000;   // Leitura com 0 pressão (offset)
const long MAX_VAL = 8300000;  // Leitura com 40 kPa (pressão máxima)
const float MAX_PRESSAO = 40.0; // Pressão máxima do sensor em kPa


void setup() {

//inicialização do sensor de pressao 
  scale.begin(DT, SCK);
      //pino de controle para transmisao e recepcao de dados;
  pinMode (ControlPin, OUTPUT);
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
       //Define pinos para o rele como saida
  pinMode(rele1, OUTPUT); 
  digitalWrite(rele1, LOW);  // ou LOW dependendo do módulo
  // defIninDo o pino analogico 
  //configura o pino como entrada dos dados na leitura do sensor 
  pinMode(TEMP_SENSOR, INPUT);
  mySerial.begin(9600);
  Serial.begin(115200);

  //Configurando os parametros Modbus 
  mb.config(&mySerial, 9600, ControlPin);
  mb.setSlaveId(1);
  // adicionando 3 saidas ficticias D0.0,D0.1,D0.2 (valores bolleanos)
  // endereços 00000/00001/00002- endereçamento ModBus 
  //Metodo para adicionar Coil (bobina para leitura Modbus)
  mb.addCoil(0);
   // Entradas Digitais ficticias D1.0/D1.1
    //(Endereçamento 10000/10001)
   //Metodos para adicionar Iputs 
    //mb.addIsts(0,true );
    //mb.addIsts(0, false );

    //adicionando a entrada do registrador de leitura temp,
    //mb.addIreg(0, 0);
    //mb.addIreg(1, 28); 
    // adicionando HoldingRedisters Saida analogica-40000(Float)
    //Adicionando Memoria valor digital (Display)-End.40002(Int)

  mb.addHreg(1);
  mb.addHreg(2);
  mb.addHreg(3, registrador3);// saida analogica pressao 

  //mb.addHreg(2, 0);// valor display entrada de dados digitais 

 
}

void loop() {

 mb.task();

 atualizaRele();



  //readCorrente();
  //ligaDesligaCopress();
  //readTempMotor();
  //Serial.print("");
  // Serial.println(readCorrente());
  //Serial.println(tempAmbiente());
  //Serial.println(ligaDesligaCompress());
  //Serial.println(valorSensor);
  
 // Serial.println("");
 // Serial.println("");
  Serial.println(tempAmbiente());
 // Serial.println(estadoCoil);
  //Serial.println(estadoRele1);

   //float pressRead 
  

  limparBufferSerial(mySerial);

}
/*
int readCorrente(){

  int valorSensor ;
  int tensao ;
  int corrente ;

  valorSensor = analogRead(pinSensorCorr);
  tensao = (valorSensor * 5.0) / 1023.0;
  corrente = (tensao - 2.5) / 0.185; // Para o sensor de 5A → 185mV por Amp

  correnteReal = mb.Hreg(2,corrente);

  return correnteReal;
}*/
void atualizaRele() {
  bool estadoCoil = mb.Coil(0);  // lê o valor atual do Coil 0 (verdadeiro ou falso)

  if (estadoCoil) {
    digitalWrite(rele1, HIGH);  // Liga o relé
  } else {
    digitalWrite(rele1, LOW);   // Desliga o relé
  }
}

void limparBufferSerial(SoftwareSerial &serial) {
  while (serial.available()) {
    serial.read();
  }

}

/*bool ligaDesligaCompress(){

  bool estadoRele1 = false;
  uint16_t compressor;
  
  //variavel para receber registrador 
  compressor= static_cast<uint16_t>(estadoRele1);
  uint16_t registrador3= mb.Coil(0,estadoRele1);
  

  if(compressor == true){
    digitalWrite(rele1, HIGH);
    estadoRele1 = rele1;
  }
  else{
    digitalWrite(rele1, LOW);
  }

  return estadoRele1;
}*/
/*
int readTempMotor(){

  // definição da variavel para receber os dados convertidos na temperatura;
  float leituraTemp = analogRead(TEMP_SENSOR);
  float tempReal = leituraTemp * (5.0/1024.0)* 100.0;

  //tempRegistrador = static_cast<uint16_t>(tempReal);  // Converte para uint16_t para o Modbus
  //uint16_t tempMotor=mb.Hreg(1,result);

  return tempMotor;

}*/


float tempAmbiente(){
    
  int temperature = 0;
  int humidity = 0;
  tempRegistrador = static_cast<uint16_t>(dht11.readTemperature());
  tempRegistrador2 = static_cast<uint16_t>(dht11.readHumidity());
  registrador3 = static_cast<uint16_t>(leituraPress());
  int result = dht11.readTemperatureHumidity(temperature, humidity);
  uint16_t byte1 =mb.Hreg(1,tempRegistrador);
  uint16_t byte2 =mb.Hreg(2,tempRegistrador2);
  uint16_t byte3= mb.Hreg(3,registrador3);

  if (result == 0) {
    Serial.print("Temperatura: ");
    Serial.print(temperature);
    Serial.println(" °C");

    Serial.print("Umidade: ");
    Serial.print(humidity);
    Serial.println(" %");
  } else {
    Serial.print("Erro na leitura: ");
    Serial.println(DHT11::getErrorString(result));
  }

}

float leituraPress(){

  
   if (scale.is_ready()) {
    long leitura = scale.read();

    // Converte a leitura bruta em pressão (kPa)
    float pressao_kPa = (float)(leitura - OFFSET) * (MAX_PRESSAO / (MAX_VAL - OFFSET));

    // Limita valores fora do range para evitar leitura negativa ou acima do máximo
    if (pressao_kPa < 0) pressao_kPa = 0;
    if (pressao_kPa > MAX_PRESSAO) pressao_kPa = MAX_PRESSAO;

    Serial.print("Leitura bruta: ");
    Serial.print(leitura);
    Serial.print("  -->  Pressão: ");
    Serial.print(pressao_kPa, 2);
    Serial.println(" kPa");
    return pressao_kPa;
  } else {
    Serial.println("HX711 não pronto.");
  }
}








 
