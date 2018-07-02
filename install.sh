mkdir logs pcap

apt-get install perl build-essential git tcpdump tshark --assume-yes

cpan -f install Tree::DAG_Node Test::Warn WWW::RobotRules HTTP::Cookies Net::FTP Net::HTTP Digest::base Digest::MD5 HTTP::Negotiate File::Listing LWP::UserAgent HTML::Form HTTP::Daemon Test \
Text::Wrap Pod::Escapes Pod::Simple Pod::Man ExtUtils::MakeMaker HTTP::Server::Simple Time::Local HTTP::Date MIME::Base64 URI Encode Encode::Locale LWP::MediaTypes Compress::Raw::Bzip2 \
Compress::Raw::Zlib IO::Uncompress::Inflate HTTP::Status ExtUtils::ParseXS Module::CoreList Module::Load Params::Check Module::Load::Conditional Locale::Maketext::Simple \
IPC::Cmd ExtUtils::CBuilder Perl::OSType IO::Dir Version::Requirements Exporter CPAN::Meta::YAML JSON::PP Parse::CPAN::Meta CPAN::Meta Scalar::Util File::Spec \
File::Temp version Module::Metadata Module::Build HTML::Tagset XSLoader HTML::Parser Sub::Uplevel Test::Exception HTML::TreeBuilder Test::Harness Test::More Pod::Usage WWW::Mechanize

cpan -f install WWW::Mechanize::Timed


