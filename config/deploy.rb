require "rvm/capistrano"
require "bundler/capistrano"


server "10.12.0.17", :web, :app, :db, primary: true

set :application, "meu_app" # Nome da app
set :user, "fabsoft" # usuario do SERVIDOR
set :deploy_to, "/home/#{user}/apps/#{application}" #Local no servidor onde vai ficar o projeto
set :use_sudo, false # Não executar os Comandos com 'sudo' no inicio

set :scm, "git" # Tipo: git, bitcucket...
set :repository, "https://github.com/felipegithub/meu_app.git" #URL do repositorio
set :branch, "master" # Ramo(se você tem um versionamento de seu projeto no repositorio)

set :rvm_ruby_string, :local # use o mesmo ruby usado no ambiente de desenvolvimento
set :rvm_autolibs_flag, "read-only"  # propriedade do rvm de instalar certas dependencias como OpenSSL por exemplo

set :rails_env, "production" # ambiente definido para deploy

#Parametros de conexão via ssh:
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"

#Definição das 'Tarefas para Deploy:'
namespace :deploy do
 
	#Cria-se tarefas, como se fossem metodos que vão ser executados conforme o deploy ocorre
  task :setup_inicial_nginx, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx_app.conf /etc/nginx/sites-enabled/#{application}"
    sudo "service nginx restart"
    puts "Criou o Link do arquivo de configuração do ngingx"
  end
 
  task :start_server, roles: :app do
    run "cd #{current_path}; rails s -e production"
	end

  after "deploy:setup", "deploy:setup_inicial_nginx"
  after "deploy:cold", "deploy:start_server"
  after "deploy", "deploy:start_server" 

end

namespace :diga do
  task :ola_mundo, roles: :app do
    puts "Ola mundo"
	end
end




