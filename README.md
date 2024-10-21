# Flake do Nix para Configuração do macOS

Este repositório contém um flake do Nix para configurar um sistema macOS. Ele utiliza nix-darwin e homebrew para gerenciar pacotes e configurações do sistema.

## Pré-requisitos

1. Nix instalado (versão 2.4 ou superior)
2. Flakes habilitados na sua configuração do Nix

## Instalação

1. Clone este repositório:

2. Navegue até o diretório do repositório:

   ```
   cd nome-do-repositorio
   ```

3. Execute o comando para construir e aplicar a configuração:

   ```
   darwin-rebuild switch --flake .#macbook
   ```

## Estrutura do Flake

O flake está estruturado da seguinte forma:

- `flake.nix`: O arquivo principal que define as entradas e saídas do flake.
- `configuration.nix`: Contém as configurações específicas do sistema.

## Personalizações

### Pacotes do Sistema

Os pacotes do sistema são gerenciados através do `environment.systemPackages` no arquivo `flake.nix`. Para adicionar ou remover pacotes, edite esta seção.

### Aplicativos Homebrew

Os aplicativos Homebrew são gerenciados na seção `homebrew` do arquivo `flake.nix`. Você pode adicionar ou remover brews, casks e aplicativos da Mac App Store aqui.

### Preferências do Sistema

As preferências do sistema macOS são configuradas na seção `system.defaults` do arquivo `flake.nix`. Você pode personalizar várias configurações do sistema aqui.

## Atualizando a Configuração

Para atualizar sua configuração após fazer alterações:

1. Edite o arquivo `flake.nix` conforme necessário.
2. Execute novamente:

   ```
   darwin-rebuild switch --flake .#macbook
   ```

## Solução de Problemas

Se encontrar problemas durante a instalação ou atualização, verifique:

- Se o Nix está instalado corretamente e os flakes estão habilitados.
- Se todas as dependências estão disponíveis e atualizadas.
- Os logs de erro para identificar problemas específicos.

Para mais informações sobre nix-darwin e flakes, consulte a documentação oficial do Nix e nix-darwin.
