module ArMailer

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:ar_mailer => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :ar_mailer
  #  recipe :ar_mailer
  def ar_mailer(hash = {})

    package hash.delete(:gem) || 'ar_mailer',
      :ensure => :installed,
      :provider => :gem

    options = {
      configuration[:application] => {
        'chdir' => "#{configuration[:deploy_to]}/current",
        'environment' => rails_env
      }.merge!(hash.delete(configuration[:application]) || {})
    }.merge(hash)

    file '/etc/ar_sendmail.conf', 
      :content => options.to_yaml,
      :mode => '644'

    file '/etc/init.d/ar_sendmail', 
      :content => template(File.join(File.dirname(__FILE__), '..', 'templates', 'ar_sendmail'), binding), 
      :mode => '744'

    service 'ar_sendmail', 
      :require => file('/etc/init.d/ar_sendmail'), 
      :enable => true, 
      :ensure => :running
  end
  
end