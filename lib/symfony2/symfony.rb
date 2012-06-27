namespace :symfony do
  desc "Runs custom symfony command"
  task :default do
    prompt_with_default(:task_arguments, "cache:clear")

    stream "cd #{latest_release} && #{php_bin} #{symfony_console} #{task_arguments} --env=#{symfony_env_prod}"
  end

  namespace :assets do
    desc "Installs bundle's assets"
    task :install do
      puts "--> Installing bundle's assets".green

      run "cd #{latest_release} && #{php_bin} #{symfony_console} assets:install #{web_path} --env=#{symfony_env_prod}"
    end
  end

  namespace :assetic do
    desc "Dumps all assets to the filesystem"
    task :dump do
      puts "--> Dumping all assets to the filesystem".green

      run "cd #{latest_release} && #{php_bin} #{symfony_console} assetic:dump --env=#{symfony_env_prod} --no-debug"
    end
  end

  namespace :vendors do
    desc "Runs the bin/vendors script to install the vendors (fast if already installed)"
    task :install do
      puts "--> Installing vendors".green

      run "cd #{latest_release} && #{php_bin} #{symfony_vendors} install"
    end

    desc "Runs the bin/vendors script to reinstall the vendors"
    task :reinstall do
      puts "--> Reinstalling vendors".green

      run "cd #{latest_release} && #{php_bin} #{symfony_vendors} install --reinstall"
    end

    desc "Runs the bin/vendors script to upgrade the vendors"
    task :upgrade do
      puts "--> Upgrading vendors".green

      run "cd #{latest_release} && #{php_bin} #{symfony_vendors} update"
    end
  end

  namespace :bootstrap do
    desc "Runs the bin/build_bootstrap script"
    task :build do
      puts "--> Building bootstrap file".green

      run "cd #{latest_release} && test -f #{build_bootstrap} && #{php_bin} #{build_bootstrap} || echo '#{build_bootstrap} not found, skipped'"
    end
  end

  namespace :composer do
    desc "Gets composer and installs it"
    task :get do
        puts "--> Downloading Composer".green

        run "cd #{latest_release} && curl -s http://getcomposer.org/installer | #{php_bin}"
    end

    desc "Runs composer to install vendors from composer.lock file"
    task :install do
      if !File.exist?("#{latest_release}/composer.phar")
        symfony.composer.get
      end

      puts "--> Installing Composer dependencies".green

      run "cd #{latest_release} && #{php_bin} composer.phar install -v"
    end

    desc "Runs composer to update vendors, and composer.lock file"
    task :update do
      if !File.exist?("#{latest_release}/composer.phar")
        symfony.composer.get
      end

      puts "--> Updating Composer dependencies".green

      run "cd #{latest_release} && #{php_bin} composer.phar update -v"
    end
  end

  namespace :cache do
    desc "Clears cache"
    task :clear do
      puts "--> Clearing cache".green

      run "cd #{latest_release} && #{php_bin} #{symfony_console} cache:clear --env=#{symfony_env_prod}"
      run "chmod -R g+w #{latest_release}/#{cache_path}"
    end

    desc "Warms up an empty cache"
    task :warmup do
      puts "--> Warming up cache".green

      run "cd #{latest_release} && #{php_bin} #{symfony_console} cache:warmup --env=#{symfony_env_prod}"
      run "chmod -R g+w #{latest_release}/#{cache_path}"
    end
  end
end
