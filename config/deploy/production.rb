set :server_name, 'server-iq'

set :ssh_options, {
  forward_agent: true,
  auth_methods: ["publickey"],
  keys: ["#{Dir.home}/infinite-quasar.pem"]
}


server 'ec2-18-230-194-10.sa-east-1.compute.amazonaws.com', port: 22, user: 'ubuntu', roles: %w{web app db}, primary: true
set :branch, "master"
set :rails_env, :production
set :env, "production"
set :application, 'desafio-agenda'
set :deploy_to, '/home/ubuntu/desafio-agenda'

set :stage, :production
