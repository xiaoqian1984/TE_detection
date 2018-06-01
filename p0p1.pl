#!/usr/bin/perl
open IN1, "<$ARGV[0]";  #kap.novel.10
my $file = $ARGV[1];  #kap.novel.12
my $title = `head -n1 $file`;
open IN2, "<$file";  
chomp $title;
my @head = split /\s+/, $title;
my $element = $head[0];

my %theta;
my %ml;
my @array_1, @array_type, @array_fir, @array_sec;
$array_1[0] = $head[0];
$array_type[0][0] = $head[3];
$array_fir[0][0] = $head[4];
$array_sec[0][0] = $head[5];

my $total1 = 100, $total2 = 100 ;
my $step1 = 0.01, $step2 = 0.01;
my $p0, $p1, $p2, $q;
my $f = 0.0;
my $best_p0, $best_p1, $best_p2;
my $length_2 ;
while (my $line = <IN1>){
    chomp $line;
	my @z = split /\s+/, $line;
	$theta{$z[0]} = $z[8];
}
#print "start\n";
my $num_file1 = 0; # 统计一共多少TE
my $num_file2 = 0;  #统计每个TE 一共包含多少个个体
while (my $line = <IN2>) {
    chomp $line;
	my @z = split /\s+/,$line;
	my $name = $z[0];
	if($name =~ $element){
	    $num_file2++;
	    $array_type[$num_file1][$num_file2] = $z[3];
		$array_fir[$num_file1][$num_file2] = $z[4];
		$array_sec[$num_file1][$num_file2] = $z[5];
	}
	if($name !~ $element){
	    $num_file2 = 0;
		$element = $z[0];
		$num_file1++;
	    $array_type[$num_file1][$num_file2] = $z[3];
		$array_fir[$num_file1][$num_file2] = $z[4];
		$array_sec[$num_file1][$num_file2] = $z[5]; 
        $array_1[$num_file1] = $z[0];		
	}
}
close (IN1);
close (IN2);
#print "end\n";

$length_1 = scalar(@array_type);
for(my $value1=0;$value1<$length_1;$value1++){
    $ml{$array_1[$value1]} = 0;
	my $temp1 = 1.0 - $theta{$array_1[$value1]};
	my $temp2 = $theta{$array_1[$value1]};
    my $maximum = -20000;	
	
	for (my $i=1; $i< $total1; $i++){ #p0
	$p0 = $step1 * $i;
	for (my $j=0; $j<$total2; $j++){ #p1
	$p1 = $step2 * $j;
	if($p1<=1-$p0){
	$p2 = 1 - $p0 - $p1;	
	
    my $likelihood = 0;	
	$length_2 = scalar(@{$array_type[$value1]});
	#print "$length_2 +++ \n";
	for(my $value2=0;$value2<$length_2;$value2++){
		$temp_type = $array_type[$value1][$value2];
		if($temp_type =~/noinsert/){
			$pi_result = $p0 + $p1*(($temp1)**$array_sec[$value1][$value2]);
			
	    }
	    if($temp_type =~/homozygous/){
			$pi_result = $p2 + $p1*(($temp2)**$array_fir[$value1][$value2]);
	    }
	    if($temp_type =~/heterozygous/){
	        $pi_result =  $p1 #- $p1*(($temp1)**$array_sec[$value1][$value2]) - $p1*(($temp2)**$array_fir[$value1][$value2]);
	    }
	    #print "$p0_result\t$p1_result\t$pi_result\n";
		if($pi_result<=0){
		    $pi_result = 0.00001;
		}
		$likelihood = $likelihood + log($pi_result);	 
    }
	#$q = 0.5*$p1 + $p2;
	#print "$array_1[$value1]\t$p0\t$p1\t$p2\t$q\t$likelihood\n";
	if($likelihood > $maximum){
		$maximum = $likelihood; 
		$best_p0 = $p0;
		$best_p1 = $p1;
		$best_p2 = $p2;
		$q = 0.5*$best_p1 + $best_p2;
		#print "$array_1[$value1]\t$best_p0\t$best_p1\t$best_p2\t$q\t$maximum\n";
	}
	}
    }
	}
	$ml{$array_1[$value1]} = $maximum;
	$q = 0.5*$best_p1 + $best_p2;
    print "result\t$array_1[$value1]\t$best_p0\t$best_p1\t$best_p2\t$q\t$ml{$array_1[$value1]}\t$length_2\n";
}
