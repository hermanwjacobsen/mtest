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
my (@test_list, $test, $test_name, $test_filename, $logfile1, $logfile2);
my ($test_url, $pcap_dir, $firstThread, $secondThread, $interface, $test_mode, $test_id);


print "$dir\n";

############### CONFIG #######################

$log_dir = "$dir/logs";
$scripts_dir = 'scripts';
$pcap_dir = 'pcap';
$interface = 'ens160';

@server_list = (
	#id,name,location,url
	'1,Vodafone,Iceland,http://speedtest.c.is/speedtest/,1',
	'2,Vodafone,United Kingdom,http://speedtest.vodafone.co.uk/speedtest/,1',
	'3,hey,Faroe Islands,http://ferd.vodafone.fo/speedtest/,1',
	'4,Faroese Telecom,Faroe Islands,http://ferd.vodafone.fo/speedtest/,1',
	'5,Portal.fo,Unknown,http://www.portal.fo,2',
	'6,in.fo,Unknown,http://www.in.fo,2',
	'7,vodafone.is,Unknown,http://www.vodafone.is,2',
	'8,vp.fo,Unknown,http://www.vp.fo,2'
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
	'random4000x4000,random4000x4000.jpg'
	);

############# Script Start ##########################

chdir("$dir") or die "cannot change: $!\n";

if (! -e "$log_dir/tests.log") {
open(FH, '>', "$log_dir/tests.log") or die $!;
print FH "task_timestamp,$task_id\n";
close (FH);
};

if (! -e "$log_dir/webtest_summary.log") {
open(FH, '>', "$log_dir/webtest_summary.log") or die $!;
print FH "test_id,task_id,task_timestamp,start_time,end_time,server_id,server_name,server_location,test_name,test_filename,bytes,loadtime,status\n";
close (FH);
};

if (! -e "$log_dir/webtest_timed.log") {
open(FH, '>', "$log_dir/webtest_timed.log") or die $!;
print FH "test_id,task_id,task_timestamp,start_time,end_time,server_id,server_name,server_location,test_name,test_filename,bytes,loadtime,status\n";
close (FH);
};


$task_id = count_lines("$log_dir/tests.log");
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
	($server_id, $server_name, $server_location, $server_url, $test_mode) = split(',', $server_info);	

	foreach $test (@test_list) {
	$test_url = "";
	($test_name, $test_filename) = split (',', $test);
	if ($test_mode == 1) { 
		$test_url = "$server_url$test_filename";
	} 
	if ($test_mode == 2) { 
		$test_url = "$server_url";
		$test_filename = "Website";
		$test_name = "Website";
	} 
	$test_id = count_lines("$log_dir/webtest_summary.log");

	@ARGV = ($task_id, $task_timestamp, $server_id, $server_name, $server_location, $test_url, $test_name, $test_filename, $log_dir, $test_mode, $test_id);	
	system($^X, "$scripts_dir/webtest.pl", @ARGV);
	print "$test_url\n";
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
