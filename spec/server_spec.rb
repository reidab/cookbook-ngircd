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
        "Name = irc.example.net"
    end

    it "has admin name" do
      @chef_run.should create_file_with_content @file,
        "AdminInfo1 = Debian User"
    end

    it "has admin location" do
      @chef_run.should create_file_with_content @file,
        "AdminInfo2 = Debian City"
    end

    it "has admin email" do
      @chef_run.should create_file_with_content @file,
        "AdminEMail = irc@irc.example.com"
    end

    it "has listen address" do
      @chef_run.should create_file_with_content @file,
        "Listen = 0.0.0.0"
    end

    it "has motd file" do
      chef_run = ::ChefSpec::ChefRunner.new do |n|
        n.set['ngircd'] = {}
        n.set['ngircd']['motd_text'] = "motd text"
      end.converge "ngircd::server"

      chef_run.should create_file_with_content @file,
        "MotdFile = /etc/ngircd/ngircd.motd"
    end

    it "doesn't have motd file" do
      @chef_run.should_not create_file_with_content @file,
        "MotdFile = "
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
      @chef_run.should_not create_file_with_content @file,
        " Password = "
    end

    it "has pid file" do
      @chef_run.should create_file_with_content @file,
        "PidFile = /var/run/ngircd/ngircd.pid"
    end

    describe "with ssl" do
      it "has listen port" do
        @chef_run.should create_file_with_content @file,
          "Ports = 6697"
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
          "KeyFile = /etc/ngircd/irc.pem"
      end

      it "has ssl cert file" do
        @chef_run.should create_file_with_content @file,
          "CertFile = /etc/ngircd/irc.pem"
      end

      #TODO(retr0h): Added self-signed cert ability to openssl cookbook.
      it "creates cert file" do
        @chef_run.should execute_command <<-EOF.gsub(/^\s{10}/, "")
          umask 077
          openssl genrsa 2048 > irc.key
          openssl req -subj /C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=irc.example.net/emailAddress=irc@irc.example.com -new -x509 -nodes -sha1 -days 3650 -key irc.key > irc.crt
          cat irc.key irc.crt > irc.pem
        EOF
      end

      it "doesn't create cert file when exists" do
        pending "Determine how to handle guards"
      end

      it "executes in the proper cwd" do
        @chef_run.execute("create self-signed cert").cwd.should == "/etc/ngircd"
      end

      it "executes as the proper user" do
        @chef_run.execute("create self-signed cert").user.should == "irc"
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

      it "doesn't create cert file" do
        @chef_run.execute("create self-signed cert").should be_nil
      end
    end

    it "has server gid" do
      @chef_run.should create_file_with_content @file,
        "ServerGID = irc"
    end

    it "has server uid" do
      @chef_run.should create_file_with_content @file,
        "ServerUID = irc"
    end

    describe "limits" do
      it "has connect retry" do
        @chef_run.should create_file_with_content @file,
          "ConnectRetry = 60"
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

      it "has max nick length" do
        @chef_run.should create_file_with_content @file,
          "MaxNickLength = 9"
      end

      it "has ping timeout" do
        @chef_run.should create_file_with_content @file,
          "PingTimeout = 120"
      end

      it "has pong timeout" do
        @chef_run.should create_file_with_content @file,
          "PongTimeout = 20"
      end
    end

    describe "options" do
      it "has allow remote oper" do
        @chef_run.should create_file_with_content @file,
          "AllowRemoteOper = no"
      end

      it "has cloak host" do
        @chef_run.should create_file_with_content @file,
          "CloakHost = irc.example.net"
      end

      it "has cloak user to nick" do
        @chef_run.should create_file_with_content @file,
          "CloakUserToNick = yes"
      end

      it "has connect ipv6" do
        @chef_run.should create_file_with_content @file,
          "ConnectIPv6 = yes"
      end

      it "has connect ipv4" do
        @chef_run.should create_file_with_content @file,
          "ConnectIPv4 = yes"
      end

      it "has dns" do
        @chef_run.should create_file_with_content @file,
          "DNS = yes"
      end

      it "has ident" do
        @chef_run.should create_file_with_content @file,
          "Ident = no"
      end

      it "has more privacy" do
        @chef_run.should create_file_with_content @file,
          "MorePrivacy = no"
      end

      it "has notice auth" do
        @chef_run.should create_file_with_content @file,
          "NoticeAuth = no"
      end

      it "has oper can use mode" do
        @chef_run.should create_file_with_content @file,
          "OperCanUseMode = yes"
      end

      it "has oper server mode" do
        @chef_run.should create_file_with_content @file,
          "OperServerMode = no"
      end

      it "has pam" do
        @chef_run.should create_file_with_content @file,
          "PAM = no"
      end

      it "has predef channels only" do
        @chef_run.should create_file_with_content @file,
          "PredefChannelsOnly = no"
      end

      it "has require auth ping" do
        @chef_run.should create_file_with_content @file,
          "RequireAuthPing = no"
      end

      it "has scrub ctcp" do
        @chef_run.should create_file_with_content @file,
          "ScrubCTCP = no"
      end

      it "has syslog facility" do
        @chef_run.should create_file_with_content @file,
          "SyslogFacility = local1"
      end
    end

    it "has channels" do
      chef_run = ::ChefSpec::ChefRunner.new do |n|
        n.set['ngircd'] = {}
        n.set['ngircd']['channels'] = [{
          "name" => "channel1",
          "topic" => "topic1",
          "modes" => "modes1",
          "key" => "key1"
        }]
      end.converge "ngircd::server"
      chef_run.should create_file_with_content @file,
        "[Channel]"
      chef_run.should create_file_with_content @file,
        "Name = channel1"
      chef_run.should create_file_with_content @file,
        "Topic = topic1"
      chef_run.should create_file_with_content @file,
        "Modes = modes1"
      chef_run.should create_file_with_content @file,
        "Key = key1"
    end

    it "doesn't have channels" do
      @chef_run.should_not create_file_with_content @file,
        "[Channel]"
    end

    it "has operators" do
      chef_run = ::ChefSpec::ChefRunner.new do |n|
        n.set['ngircd'] = {}
        n.set['ngircd']['operators'] = [{
          "name" => "oper1",
          "password" => "pass1"
        }]
      end.converge "ngircd::server"
      chef_run.should create_file_with_content @file,
        "[Operator]"
      chef_run.should create_file_with_content @file,
        "Name = oper1"
      chef_run.should create_file_with_content @file,
        "Password = pass1"
    end

    it "doesn't have operators" do
      @chef_run.should_not create_file_with_content @file,
        "[Operator]"
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
