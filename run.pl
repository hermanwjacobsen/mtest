use strict;
use warnings;
use Cwd;
use IPC::System::Simple qw(system capture);
use POSIX qw(strftime);
use File::CountLines qw(count_lines);
use threads;
use File::Spec;
use File::Basename;

my $dir = dirname(File::Spec->rel2abs(__FILE__));

my ($server_id, $server_name, $server_location, $server_url, @server_list, $server, $server_info);
my ($task_id, $task_timestamp);
my ($log_dir, $scripts_dir, $logfile, $logfile_copy, $lines, $filename);
my (@test_list, $test, $test_name, $test_filename);
my ($test_url, $pcap_dir, $firstThread, $secondThread);

print "$dir\n";

############### CONFIG #######################

$log_dir = "$dir/logs";
$scripts_dir = 'scripts';
$pcap_dir = 'pcap';
$interface = 'ens160';

@server_list = (
	#id,name,location,url
	'1,Vodafone,Iceland,http://speedtest.c.is/speedtest/',
	'2,Vodafone,United Kingdom,http://speedtest.vodafone.co.uk/speedtest/',
	'3,hey,Faroe Islands,http://ferd.vodafone.fo/speedtest/',
	'4,Faroese Telecom, Faroe Islands,http://ferd.vodafone.fo/speedtest/',
	);

@test_list = (
	#name,Filename
#	'random350x500,random350x350.jpg',
#	'random500x500,random500x500.jpg',
	'random1000x1000,random1000x1000.jpg',
#	'random1500x1500,random1500x1500.jpg',
	'random2000x2000,random2000x2000.jpg',
#	'random2500x2500,random2500x2500.jpg',
	'random3000x3000,random3000x3000.jpg',
#	'random3500x3500,random3500x3500.jpg',
#	'random4000x4000,random4000x4000.jpg'
	);

############# Script Start ##########################

chdir("$dir") or die "cannot change: $!\n";

if (! -e "$log_dir/tests.log") {
open(FH, '>', "$log_dir/tests.log") or die $!;
print FH "task_timestamp,$task_id\n";
close (FH);
};

if (! -e "$log_dir/webtest.log") {
open(FH, '>', "$log_dir/tests.log") or die $!;
print FH "task_id,task_timestamp,start_time,end_time,server_id,server_name,server_location,test_name,test_filename,bytes,loadtime,status\n";
close (FH);
};


$lines = count_lines("$log_dir/tests.log");
$task_id = $lines;
$task_timestamp = strftime "%Y-%m-%d %H:%M:00", localtime;

$filename = 'tests.log';
open(my $fh, '>>', "$log_dir/$filename") or die "Could not open file '$filename' $!";
print $fh "$task_timestamp\, $task_id\n";
close $fh;

sub tcpdump {
system("tcpdump -U -i $interface -w $pcap_dir/$task_id.pcap");
    return;
}

sub tests {
sleep (2);
foreach $server_info (@server_list) {
	($server_id, $server_name, $server_location, $server_url) = split(',', $server_info);	

	foreach $test (@test_list) {
	$test_url = "";
	($test_name, $test_filename) = split (',', $test);
	$test_url = "$server_url$test_filename";
#	print "$task_id, $task_timestamp, $server_id, $server_name, $server_location, $server_url, $test_name, $test_filename\n\n";
	@ARGV = ($task_id, $task_timestamp, $server_id, $server_name, $server_location, $test_url, $test_name, $test_filename, $log_dir);	
	system($^X, "$scripts_dir/webtest.pl", @ARGV);
#	print "$test_url\n";
	};
};
#print "test done\n";
sleep(5);
system("killall tcpdump");
return;
};

$firstThread = threads->create(\&tcpdump,1);
$secondThread = threads->create(\&tests,1);

$_->join() foreach ( $firstThread, $secondThread );
