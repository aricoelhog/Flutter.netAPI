# Flutter.netAPI

Integração entre um app Flutter e uma API .NET 8, com comunicação via REST, usando PostgreSQL como banco de dados.

![Demonstração da Calculadora](assets/flutter_netapi.gif)

---

## Tabela de Conteúdos

- [Visão Geral](#visão-geral)  
- [Funcionalidades](#funcionalidades)  
- [Pré-requisitos](#pré-requisitos)  
- [Instalação e Execução](#instalação-e-execução) 
  - [Configurar o backend (.NET 8 e Postgres)](#configurar-o-backend-net-8-e-postgres)
  - [Configurar o App Flutter](#configurar-o-app-flutter)  
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Dicas e Solução de Problemas](#dicas-e-solução-de-problemas)
- [Contribuição](#contribuição)

---

## Visão Geral

Este projeto demonstra como um aplicativo Flutter pode interagir com uma API REST construída em **.NET 8**, para realizar as operações básicas CRUD (Create, Read, Update, Delete).  
O backend usa **PostgreSQL** como banco de dados para persistência de dados.

---

## Funcionalidades

- **GET** – recuperar registros do banco  
- **POST** – inserir novo registro  
- **PUT** – atualizar registro existente  
- **DELETE** – remover registro  
- Conexão entre Flutter e a API  
- Serialização / desserialização JSON  
- Estrutura organizada entre camadas (models, controllers, serviços)  

---

## Pré-requisitos

Antes de executar o projeto, é necessário:

1. Instalar o **.NET 8 SDK**  
2. Instalar **Flutter / Dart SDK**  
3. Instalar **PostgreSQL**  
4. No backend, instalar os pacotes NuGet:  
   - `Microsoft.EntityFrameworkCore`  
   - `Microsoft.EntityFrameworkCore.Tools`  
   - `Microsoft.VisualStudio.Web.CodeGeneration`  
   - `Microsoft.VisualStudio.Web.CodeGeneration.Design`  
   - `Npgsql.EntityFrameworkCore.PostgreSQL`  

---

## Instalação e Execução

### Configurar o backend (.NET 8) e Postgres

1. Abra o projeto `WebApi` no seu IDE.  
2. No **Package Manager Console** (ou terminal equivalente), execute:  
   ```powershell
   Add-Migration "initial migration"

3. Configurar o Banco de Dados PostgreSQL

    - Certifique-se de que o PostgreSQL esteja instalado e em execução.

    - Atualize a connection string no arquivo appsettings.json da API, inserindo suas credenciais de acesso, host e nome do banco de dados. Exemplo:

   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Host=localhost;Port=5432;Database=WebApi;Username=postgres;Password=suasenha"
   }
    
- Após ajustar a conexão, rode novamente o comando:

   ```powershell
   Update-Database

4. No arquivo de solução (.sln), remova o trecho

   ```xml
   <InvariantGlobalization>true</InvariantGlobalization>

Esse trecho deve ser removido para evitar conflitos relacionados à globalização e à cultura invariável no .NET, que podem causar falhas em determinadas operações (principalmente no uso de EntityFrameworkCore e PostgreSQL em ambientes não Windows).

5. Executar a atualização do banco de dados

    - Após remover o trecho acima, execute o comando abaixo no Package Manager Console:

    ```powershell
    Update-Database

Isso aplicará as migrações criadas anteriormente e criará as tabelas correspondentes no banco de dados PostgreSQL.

6. Executar a API

    - Depois que as migrações forem aplicadas, inicie a aplicação

    - Verifique no console o endereço em que a API está rodando (geralmente algo como http://localhost:5000).


⚠️ ATENÇÃO: A api foi configurada para ser executada com http, pois foi utilizada em uma rede residencial segura, com a finalidade de testes básicos. Caso seja necessário executar em uma rede mais complexa, altere a API para executar com HTTPS e configure as permissões.

### Configurar o App Flutter

7. No projeto Flutter:

    - Abra o arquivo lib/api_handler.dart.

    - Localize a variável responsável pela URL base da API (baseUri).

    - Atualize o valor para o endereço real da sua API .NET, por exemplo:

   ```dart
   final String baseUri = "http://192.168.3.9:7018/api/users";

💡 Dica:

- No emulador Android, use 10.0.2.2 em vez de localhost.

- Em dispositivos físicos, use o IP da máquina que está executando a API.

- Salve as alterações e execute o app Flutter:

    ```powershell
    flutter pub get
    flutter run

- O app agora deve se comunicar corretamente com a API .NET e o banco de dados PostgreSQL.

## Estrutura do Projeto

    /
    ├── WebApi/                      # Backend em .NET 8
    │   ├── Controllers/             # Endpoints REST
    │   ├── Models/                  # Modelos de dados
    │   ├── Program.cs               # Ponto de entrada da aplicação
    │   ├── appsettings.json         # Configurações e connection string
    │   └── Migrations/              # Migrações geradas pelo EF Core
    └── user_registration/           # Aplicativo Flutter
        ├── lib/
        │   ├── main.dart            # Início da excecução
        │   ├── main_page.dart       # Página principal
        │   ├── user.dart            # Model
        │   ├── api_handler.dart     # Requisições http
        │   ├── edit_page.dart       # Tela de edição
        |   ├── internet_checker.dart       # Verifica conexão com internet
        │   └── http/
        │       └── http_extensions.dart # Mensagens do status
        └── pubspec.yaml

## Dicas e Solução de Problemas

- Caso o comando Update-Database falhe, verifique se o PostgreSQL está em execução e se as credenciais de acesso estão corretas.

- Se o app Flutter não conseguir conectar à API, confirme se:
    - O backend está rodando (dotnet run ativo).
    - A URL base foi configurada corretamente no código Flutter.
    - O CORS está habilitado no backend para permitir chamadas do aplicativo.
    - Para testar endpoints, você pode usar o SWAGGER.

## Contribuição

Contribuições são bem-vindas! Para contribuir:

1. Fork este repositório
2. Crie uma branch para a feature ou correção (git checkout -b feat/nova-funcionalidade)
3. Faça commits claros e atômicos
4. Envie pull request com descrição das mudanças

Antes de submeter, verifique se:
- O código compila corretamente
- Não há erros de lint
- Documentação / comentários foram atualizados
