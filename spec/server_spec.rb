require "chefspec"

describe "ngircd::server" do
  before do
    @chef_run = ::ChefSpec::ChefRunner.new.converge "ngircd::server"
  end

  it "installs ngircd" do
    @chef_run.should upgrade_package "ngircd"
  end

  it "starts service" do
    @chef_run.should start_service "ngircd"
  end

  it "enables service" do
    @chef_run.should set_service_to_start_on_boot "ngircd"
  end

  describe "ngircd.conf" do
    before { @file = "/etc/ngircd/ngircd.conf" }

    it "has proper owner" do
      @chef_run.template(@file).should be_owned_by("irc", "irc")
    end

    it "has proper modes" do
      m = @chef_run.template(@file).mode

      sprintf("%o", m).should == "600"
    end

    it "has name" do
      @chef_run.should create_file_with_content @file,
        "Name = irc.example.com"
    end

    it "has server password" do
      chef_run = ::ChefSpec::ChefRunner.new do |n|
        n.set['ngircd'] = {}
        n.set['ngircd']['server_password'] = "secrektz"
      end.converge "ngircd::server"

      chef_run.should create_file_with_content @file,
        "Password = secrektz"
    end

    it "doesn't have server password" do
      @chef_run.should create_file_with_content @file,
        "Password = "
    end

    it "has admin name" do
      @chef_run.should create_file_with_content @file,
        "AdminInfo1 = Description"
    end

    it "has admin location" do
      @chef_run.should create_file_with_content @file,
        "AdminInfo2 = Location"
    end

    it "has admin email" do
      @chef_run.should create_file_with_content @file,
        "AdminEMail = admin@irc.server"
    end

    it "has listen address" do
      @chef_run.should create_file_with_content @file,
        "Listen = 0.0.0.0"
    end

    describe "with ssl" do
      it "has listen port" do
        @chef_run.should create_file_with_content @file,
          "SSLPorts = 6697"
      end

      it "has listen ports" do
        chef_run = ::ChefSpec::ChefRunner.new do |n|
          n.set['ngircd'] = {}
          n.set['ngircd']['use_ssl'] = true
          n.set['ngircd']['ssl_ports'] = [ "6697", "443" ]
        end.converge "ngircd::server"

        chef_run.should create_file_with_content @file,
          "Ports = 6697,443"
      end

      it "has ssl key file" do
        @chef_run.should create_file_with_content @file,
          "SSLKeyFile = /etc/ssl/certs/irc.pem"
      end

      it "has ssl cert file" do
        @chef_run.should create_file_with_content @file,
          "SSLCertFile = /etc/ssl/certs/irc.pem"
      end

      #TODO(retr0h): Added self-signed cert ability to openssl cookbook.
      it "creates cert file" do
      end
    end

    describe "without ssl" do
      before do
        @chef_run = ::ChefSpec::ChefRunner.new do |n|
          n.set['ngircd'] = {}
          n.set['ngircd']['use_ssl'] = false
        end.converge "ngircd::server"
      end

      it "has listen port" do
        @chef_run.should create_file_with_content @file,
          "Ports = 6667"
      end

      it "has listen ports" do
        chef_run = ::ChefSpec::ChefRunner.new do |n|
          n.set['ngircd'] = {}
          n.set['ngircd']['use_ssl'] = false
          n.set['ngircd']['non_ssl_ports'] = [ "6667", "6668", "6669" ]
        end.converge "ngircd::server"

        chef_run.should create_file_with_content @file,
          "Ports = 6667,6668,6669"
      end
    end

    it "has motd file" do
      @chef_run.should create_file_with_content @file,
        "MotdFile = /etc/ngircd/ngircd.motd"
    end

    it "has pid file" do
      @chef_run.should create_file_with_content @file,
        "PidFile = /var/run/ngircd/ngircd.pid"
    end

    it "has ping timeout" do
      @chef_run.should create_file_with_content @file,
        "PingTimeout = 120"
    end

    it "has pong timeout" do
      @chef_run.should create_file_with_content @file,
        "PongTimeout = 20"
    end

    it "has connect retry" do
      @chef_run.should create_file_with_content @file,
        "ConnectRetry = 60"
    end

    it "has oper can use mode" do
      @chef_run.should create_file_with_content @file,
        "OperCanUseMode = yes"
    end

    it "has max connections" do
      @chef_run.should create_file_with_content @file,
        "MaxConnections = 500"
    end

    it "has max connections ip" do
      @chef_run.should create_file_with_content @file,
        "MaxConnectionsIP = 10"
    end

    it "has max join" do
      @chef_run.should create_file_with_content @file,
        "MaxJoins = 10"
    end

    it "restarts ngircd" do
      resource = [ "ngircd", "service", "delayed" ]

      @chef_run.template(@file).notifies(*resource).should be_true
    end
  end

  describe "ngircd.motd" do
    before do
      @chef_run = ::ChefSpec::ChefRunner.new do |n|
        n.set['ngircd'] = {}
        n.set['ngircd']['motd_text'] = "motd text"
      end.converge "ngircd::server"
      @file = "/etc/ngircd/ngircd.motd"
    end

    it "has proper owner" do
      @chef_run.template(@file).should be_owned_by("irc", "irc")
    end

    it "has proper modes" do
      m = @chef_run.template(@file).mode

      sprintf("%o", m).should == "644"
    end

    it "has motd data" do
      @chef_run.should create_file_with_content @file, "motd text"
    end

    it "doesn't have motd data" do
      chef_run = ::ChefSpec::ChefRunner.new.converge "ngircd::server"
      chef_run.should_not create_file @file
    end

    it "restarts ngircd" do
      resource = [ "ngircd", "service", "delayed" ]

      @chef_run.template(@file).notifies(*resource).should be_true
    end
  end
end
