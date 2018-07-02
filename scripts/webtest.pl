use strict;
use warnings;

use POSIX qw(strftime);
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use Time::HiRes 'time','sleep';

my ($ARGV);
my ($ua, $request, $response);
my ($start, $end, $loadtime, $start_time, $end_time);
my ($task_id, $task_timestamp, $server_id, $server_name, $server_location, $server_url, $logfile, $logfile_copy, $test_name, $test_filename, $status, $logdir);
my ($content, $bytes);


$task_id = $ARGV[0];
$task_timestamp = $ARGV[1];
$server_id = $ARGV[2];
$server_name = $ARGV[3];
$server_location = $ARGV[4];
$server_url = $ARGV[5];
$test_name = $ARGV[6];
$test_filename = $ARGV[7];
$logdir = $ARGV[8];

#$logdir = '/scripts/speedtest2/logs';


$logfile = "$logdir/webtest.log";


print "$task_id, $task_timestamp, $server_id, $server_name, $server_location, $server_url, $test_name, $test_filename\n";
#print "$server_url\n\n";

$ua = LWP::UserAgent->new;
$request = new HTTP::Request('GET', "$server_url");

$start = time(  );
$response = $ua->request($request);
$end = time(  );

$start_time = strftime("%Y-%m-%d %H:%M:%S", localtime($start));
$end_time = strftime("%Y-%m-%d %H:%M:%S", localtime($end));


if ($response->is_error( )) {
        ($loadtime, $bytes, $status) = ('N/A', '0', 'ERROR');
        open(FH, '>>', "$logfile") or die "Could not open file '$logfile' $!";
        print FH "$task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$test_filename,$bytes,$loadtime,$status\n";
        close (FH);

} else {


	$loadtime = $end - $start;
	$loadtime = sprintf("%0.2f", $loadtime);

	$content = $response->content( );
	$bytes = length $content;

	$status = "OK";

        open(FH, '>>', "$logfile") or die "Could not open file '$logfile' $!";
        print FH "$task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$test_filename,$bytes,$loadtime,$status\n";
        close (FH);



print "$loadtime\n";

};
