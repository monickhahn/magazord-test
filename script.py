import subprocess
import boto3
import datetime

# Configurações do banco de dados PostgreSQL
db_host = 'your_db_host'
db_port = 'your_db_port'
db_name = 'your_db_name'
db_user = 'your_db_user'
db_password = 'your_db_password'

# Configurações do Amazon S3
s3_bucket = 'your_s3_bucket'
s3_prefix = 'your_s3_prefix'

# Gera o nome do arquivo de backup com base na data atual
backup_filename = f'{db_name}_backup_{datetime.datetime.now().strftime("%Y%m%d%H%M%S")}.sql'

# Comando para gerar o backup
backup_command = f'pg_dump -h {db_host} -p {db_port} -U {db_user} -Fc -f {backup_filename} {db_name}'

# Executa o comando para gerar o backup
subprocess.run(backup_command, shell=True, check=True)

# Configura o cliente do Amazon S3
s3_client = boto3.client('s3')

# Faz o upload do arquivo de backup para o Amazon S3
s3_key = f'{s3_prefix}/{backup_filename}'
s3_client.upload_file(backup_filename, s3_bucket, s3_key)

# Exibe a URL de download do backup
s3_url = f'https://{s3_bucket}.s3.amazonaws.com/{s3_key}'
print(f'Backup do banco de dados gerado e armazenado em: {s3_url}')
