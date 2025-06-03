USE compressor;

CREATE TABLE IF NOT EXISTS compressor (
    horario VARCHAR(40),
    temperatura FLOAT,
    umidade FLOAT,
    pressao FLOAT,
    estado VARCHAR(15),
    notificacao VARCHAR(30)
)