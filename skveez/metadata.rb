name              "skveez"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and maintains skveez"
version           "1.1.4"

%w{ ubuntu }.each do |os|
  supports os
end

depends "git"
depends "java"
depends "php"
depends "nginx"
depends "zsh"

recipe "skveez", "Installs skveez"
