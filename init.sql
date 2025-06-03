USE compressor;

CREATE TABLE IF NOT EXISTS compressor (
    horario DATETIME,
    temperatura FLOAT,
    umidade FLOAT,
    pressao FLOAT,
    estado VARCHAR(15),
    notificacao VARCHAR(30)
)