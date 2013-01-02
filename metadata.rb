name             "ngircd"
maintainer       "John Dewey"
maintainer_email "john@dewey.ws"
license          "Apache 2.0"
description      "Installs/Configures ngircd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe           "ngircd::server", "Installs/Configures ngircd"

supports         "ubuntu", ">= 12.04"
