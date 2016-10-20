namespace :test do
  desc "Raise an error"
  task :error do
    raise "ERRA"
  end

  task :interrupt do
    raise Interrupt
  end
end
