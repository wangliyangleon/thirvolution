OmniAuth.config.logger = Rails.logger

# TODO: hide the keys ;)
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '572658144253-fjusjqc6r8s60i1d6fjof2m82vj456ru.apps.googleusercontent.com', 'PnN1kgtYdea8S-nyvbzRqnWg', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
