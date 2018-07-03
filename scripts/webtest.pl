use strict;
use warnings;

use POSIX qw(strftime);
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use Time::HiRes 'time','sleep';
use WWW::Mechanize::Timed;


my ($ARGV);
my ($ua, $request, $response);
my ($start, $end, $loadtime, $start_time, $end_time);
my ($task_id, $task_timestamp, $server_id, $server_name, $server_location, $server_url, $logfile, $logfile_copy, $test_name, $test_filename, $status, $logdir, $logfile1, $logfile2);
my ($content, $bytes);

my ($client_request_connect_time, $client_request_transmit_time, $client_response_server_time, $client_response_receive_time, $client_total_time, $client_elapsed_time, $test_mode, $test_id);

$task_id = $ARGV[0];
$task_timestamp = $ARGV[1];
$server_id = $ARGV[2];
$server_name = $ARGV[3];
$server_location = $ARGV[4];
$server_url = $ARGV[5];
$test_name = $ARGV[6];
$test_filename = $ARGV[7];
$logdir = $ARGV[8];
$test_mode = $ARGV[9];
$test_id = $ARGV[10];

#$logdir = '/scripts/speedtest2/logs';


$logfile1 = "$logdir/webtest_summary.log";
$logfile2 = "$logdir/webtest_timed.log";


print "$task_id, $task_timestamp, $server_id, $server_name, $server_location, $server_url, $test_name, $test_filename\n";

$ua =  WWW::Mechanize::Timed->new();

$start = time(  );
$response = $ua->get($server_url);
$end = time(  );

$start_time = strftime("%Y-%m-%d %H:%M:%S", localtime($start));
$end_time = strftime("%Y-%m-%d %H:%M:%S", localtime($end));


$client_request_connect_time = $ua->client_request_connect_time;
$client_request_transmit_time = $ua->client_request_transmit_time;
$client_response_server_time = $ua->client_response_server_time;
$client_response_receive_time = $ua->client_response_receive_time;
$client_total_time = $ua->client_total_time;
$client_elapsed_time = $ua->client_elapsed_time;



if ($response->is_error( )) {
        ($loadtime, $bytes, $status) = ('N/A', '0', 'ERROR');
        open(FH, '>>', "$logfile") or die "Could not open file '$logfile' $!";
        print FH "$test_id,$task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$test_filename,$bytes,$loadtime,$test_mode,$status\n";
        close (FH);

} else {


	$loadtime = $end - $start;
	$loadtime = sprintf("%0.2f", $loadtime);

	$content = $response->content( );
	$bytes = length $content;

	$status = "OK";

        open(FH, '>>', "$logfile1") or die "Could not open file '$logfile' $!";
        print FH "$test_id,$task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$test_filename,$bytes,$loadtime,$test_mode,$status\n";
        close (FH);

	open(FH, '>>', "$logfile2") or die "Could not open file '$logfile' $!";
        print FH "$test_id,$task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$server_url,$test_mode,$client_request_connect_time,$client_request_transmit_time,$client_response_server_time,$client_response_receive_time,$client_total_time,$client_elapsed_time\n";
	close (FH);



print "$loadtime\n";

};
