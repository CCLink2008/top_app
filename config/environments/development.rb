Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

config.middleware.delete 'Rack::Cache'   # 整页缓存，用不上
config.middleware.delete 'Rack::Lock'    # 多线程加锁，多进程模式下无意义
# config.middleware.delete 'Rack::Runtime' # 记录X-Runtime（方便客户端查看执行时间）
 config.middleware.delete 'ActionDispatch::RequestId' # 记录X-Request-Id（方便查看请求在群集中的哪台执行）
# config.middleware.delete 'ActionDispatch::RemoteIp'  # IP SpoofAttack
# config.middleware.delete 'ActionDispatch::Callbacks' # 在请求前后设置callback
# config.middleware.delete 'ActionDispatch::Head'      # 如果是HEAD请求，按照GET请求执行，但是不返回body
config.middleware.delete 'Rack::ConditionalGet'      # HTTP客户端缓存才会使用
config.middleware.delete 'Rack::ETag'    # HTTP客户端缓存才会使用
config.middleware.delete 'ActionDispatch::BestStandardsSupport' # 设置X-UA-Compatible, 在nginx上设置

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  host = 'localhost' #
  config.action_mailer.default_url_options = { host: host }
  ActionMailer::Base.smtp_settings = {
                :address => 'smtp.mailgun.org',
                :port => '25',
                :authentication => :plain,
                :user_name => "postmaster@sandbox9658303adb794cfda6fbad81cf94d952.mailgun.org",
                :password => "bfe9657961970b286b0d9e61280bf7f7",
                :domain => 'mailgun.org',
                :enable_starttls_auto => true
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
