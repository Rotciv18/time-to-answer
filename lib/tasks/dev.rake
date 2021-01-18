namespace :dev do

  DEFAULT_PASSWORD = '123456'

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do

    if Rails.env.development?
      
      show_spinner("Dropping DB...") do
        %x(rails db:drop:_unsafe)
      end

      show_spinner("Creating DB...") do
        %x(rails db:create)
      end

      show_spinner("Executing migrations...") do
        %x(rails db:migrate)
      end

      show_spinner("Cadastrando admin padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando usuário padrão...") { %x(rails dev:add_default_user) }

    else
      puts "You're not in development environment"
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private
    def show_spinner(starting_msg, ending_msg = "Done.")
      spinner = TTY::Spinner.new("[:spinner] #{starting_msg }")
      spinner.auto_spin
      yield
      spinner.success("(#{ending_msg})")
    end

end
