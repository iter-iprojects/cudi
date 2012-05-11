CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "/database.yml"))["production"]

Backup::Model.new(:daily, 'Daily Backup') do

  database MySQL do |database|
    database.name               = CONFIG["database"]
    database.username           = CONFIG["username"]
    database.password           = CONFIG["password"]
    database.additional_options = ['--single-transaction', '--quick']
  end

  archive :system do |archive|
    archive.add File.join(File.dirname(__FILE__), "..", "..", "/shared/system")
  end

  archive :logs do |archive|
    archive.add File.join(File.dirname(__FILE__), "..", "..", "/shared/log")
  end

  compress_with Gzip do |compression|
    compression.best = true
  end

  store_with Dropbox do |db|
    db.email      = "mail@example.com"    db.password   = "[dropbox password]"
    db.api_key    = "[dropbox api key]"
    db.api_secret = "[dropbox api secret]"
    db.path       = "/Backups"
    db.keep       = 10
    db.timeout    = 300
  end

  notify_by Mail do |mail|
    mail.on_failure           = true
    mail.on_success           = false

    mail.from                 = "mail@example.com"
    mail.to                   = "mail@example.com"
    mail.address              = "smtp.example.com"
    mail.port                 = 25
    mail.domain               = "example.com"
    mail.user_name            = "mail@example.com"
    mail.password             = "secret"
    mail.authentication       = "login"
    mail.enable_starttls_auto = false
  end

end
