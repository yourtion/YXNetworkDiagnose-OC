Pod::Spec.new do |s|

  s.name         = "NetworkDiagnose"
  s.version      = "0.1.2"
  s.summary      = "Network Diagnose framework for iOS and OSX"

  s.description  = <<-DESC
                    Network Diagnose framework, include: 
                      - Ping
                      - TCPPing
                      - NSLookup
                      - TraceRoute
                      - HTTP
                      - NetworkInfo
                  DESC

  s.homepage     = "https://github.com/yourtion/YXNetworkDiagnose-OC"
  s.license      = "MIT"
  s.author       = { "Yourtion" => "yourtion@gmail.com" }
  s.source       = { :git => "https://github.com/yourtion/YXNetworkDiagnose-OC.git", :tag => s.version  }
  s.source_files = "YXNetworkDiagnose"
  
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  
  s.libraries   = "resolv"
  s.frameworks  = "Foundation"
  s.requires_arc = true

end
