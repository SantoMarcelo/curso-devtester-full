# Before / After ????

# Before do
#   puts 'tudo aqui começa antes de cada cenário'
# end

# After do
#   puts 'tudo aqui termina após cada cenário'
# end

require_relative 'helpers'

World(Helpers)

Before do
  @contato_page = ContatoPage.new
  @acesso_page = AcessoPage.new

  @api_uri = $env_file[$env_type]['api']
end

After('@logout') do
  click_button 'Sair'
  page.has_css?('form[id=login]')
end

After('@insert_contato') do
  res = DAO.new.busca_por_celular(@novo_contato[:celular])

  expect(res[:nome]).to eql @novo_contato[:nome]
  expect(res[:email]).to eql @novo_contato[:email]
  expect(res[:celular]).to eql @novo_contato[:celular]
  expect(res[:tipo]).to eql @novo_contato[:tipo]
end

After do |scenario|
  nome = scenario.name.gsub(/[^A-Za-z0-9 ]/, '')
  nome = nome.tr(' ', '_').downcase!
  screenshot = "log/screenshots/#{nome}.png"
  page.save_screenshot(screenshot)
  embed(screenshot, 'image/png', 'Veja a evidência :)')
end
