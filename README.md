# magazord-test
## Repositório para realização do teste para concorrer a vaga na empresa

ssh -i "AcerPemSSH.pem" ec2-user@ec2-3-145-169-22.us-east-2.compute.amazonaws.com
já conectado na instância para instalar o docker utilizei o seguinte comando:
```
sudo yum install -y docker
```

logo após verificando a versão do docker instalado: 
```
docker --version
```

Subindo o serviço o docker:
```
sudo service docker start
```

Criado um dockerfile
```
sudo touch /tmp/Dockerfile
```

Criado o arquivo de autorização, contendo o key.pem
```
sudo touch /tmp/authorized_keys
```

logo após executado comando para build da imagem
```
sudo docker build -t cloud9-image:latest /tmp
```

Como saída foi criado o container e executado com o seguinte comando:

```
sudo docker run -d -it --expose 9090 -p 0.0.0.0:9090:22 4109f3434ec1:latest
```

{
CONTAINER ID   IMAGE          COMMAND       CREATED         STATUS         PORTS                            NAMES
b149e7462fb2   4109f3434ec1   "/bin/bash"   8 seconds ago   Up 7 seconds   9090/tcp, 0.0.0.0:9090->22/tcp   dreamy_liskov
}

caso queira executar o container no modo interativo basta
```
sudo docker exec -it 4109f3434ec1 bash
```

Para subir um ocntianer jenkins indico fazer isso via container diretamente no SO mesmo:
Pode ser realizado via documentação: https://hub.docker.com/_/jenkins/
```
docker pull jenkins
```
```
docker run -p 8080:8080 -p 50000:50000 -v /your/home:/var/jenkins_home jenkins
```

## Meus conhecimentos são básicos em Cloud e virtualização, meu nível é Junior e estou disponsta a aprender, tenho muita força de vontade em aprender e colaborar com o time, busquei os conhecimentos de fontes da internet como blogs e o terraform com ajuda do ChatGPT. Estou disponível para entrevista.