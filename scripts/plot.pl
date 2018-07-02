use strict;
use warnings;
use Chart::Gnuplot;
my ($server_url, $server_info, @server_list);  
my (@x, @x1, @x2, @x3, @y1, @y2, @y3, $i, $dataset1, $dataset2, $dataset3);
my ($task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$test_filename,$bytes,$loadtime,$status);
#@x =`cat /scripts/speedtest2/logs/webtest.log | grep hey | grep random1000 | awk -F',' '{print \$2}'`;
#@y =`cat /scripts/speedtest2/logs/webtest.log | grep hey | grep random1000 | awk -F',' '{print \$11}'`;


@server_list = (
        #id,name,location,url
        '1,Vodafone,Iceland,http://speedtest.c.is/speedtest/',
        '2,Vodafone,United Kingdom,http://speedtest.vodafone.co.uk/speedtest/',
        '3,hey,Faroe Islands,http://ferd.vodafone.fo/speedtest/',
#       '4,Faroese Telecom, Faroe Islands,http://ferd.vodafone.fo/speedtest/',
#       '5,Ragnar,http://89.238.176.12/speedtest/'
        ); 

foreach $server_info (@server_list) {
        ($server_id, $server_name, $server_location, $server_url) = split(',', $server_info);  

undef @x;
undef @x1;
undef @x2;
undef @x3;
undef @y1;
undef @y2;
undef @y3;
undef $i;
undef $dataset1;
undef $dataset2;
undef $dataset3;
my (@x, @x1, @x2, @x3, @y1, @y2, @y3, $i, $dataset1, $dataset2, $dataset3);


print "\n\n$server_name $server_location\n\n";

for $i (split '\n', `cat /scripts/speedtest2/logs/webtest.log | grep "$server_name" | grep "$server_location" | grep random1000`) {
    ($loadtime, $task_timestamp) = ("", "");
    ($task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$test_filename,$bytes,$loadtime,$status) = split(',', $i);
    push (@y1, $loadtime);
    push (@x1, $task_timestamp);
}
for $i (split '\n', `cat /scripts/speedtest2/logs/webtest.log | grep "$server_name" | grep "$server_location" | grep random2000`) {
    ($loadtime, $task_timestamp) = ("", "");
    ($task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$test_filename,$bytes,$loadtime,$status) = split(',', $i);
    push (@y2, $loadtime);
    push (@x2, $task_timestamp);
}
for $i (split '\n', `cat /scripts/speedtest2/logs/webtest.log | grep "$server_name" | grep "$server_location" | grep random3000`) {
    ($loadtime, $task_timestamp) = ("", "");
    ($task_id,$task_timestamp,$start_time,$end_time,$server_id,$server_name,$server_location,$test_name,$test_filename,$bytes,$loadtime,$status) = split(',', $i);
    push (@y3, $loadtime);
    push (@x3, $task_timestamp);
}


my $chart = Chart::Gnuplot->new(
    output => "/scripts/speedtest2/plots/$server_name-$server_location.png",
    title  => "Downloading from $server_name $server_location",
    xlabel => 'Date/Time',
    ylabel => 'Loadtime (Seconds)',
    timeaxis => "x",
    imagesize => "1.5, 0.8",
    grid => 'on',
    minorgrid => 'on',
    xtics => {
	labelfmt => '%H:%M:%S\n%m-%d',
	minor => 5,
	incr => 21600
	     }
);

$dataset1 = Chart::Gnuplot::DataSet->new(
    xdata => \@x1,
    ydata => \@y1,
    title => "Random1000x1000",
    style => "lines",
    timefmt => '%Y-%m-%d %H:%M:%S'	
);
$dataset2 = Chart::Gnuplot::DataSet->new(
    xdata => \@x2,
    ydata => \@y2,
    title => "Random2000x2000",
    style => "lines",
    timefmt => '%Y-%m-%d %H:%M:%S'	
);
$dataset3 = Chart::Gnuplot::DataSet->new(
    xdata => \@x3,
    ydata => \@y3,
    title => "Random3000x3000",
    style => "lines",
    timefmt => '%Y-%m-%d %H:%M:%S'	
);

$chart->plot2d($dataset1,$dataset2,$dataset3);


};
