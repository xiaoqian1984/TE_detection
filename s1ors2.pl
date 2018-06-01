#!/usr/bin/perl
open IN1, "<$ARGV[0]";  #kap.novel.10
my $file = $ARGV[1];  #kap.novel.11
my $title = `head -n1 $file`;
open IN2, "<$file";  
chomp $title;
my @head = split /\s+/, $title;
my $element = $head[0];

my %p0, %p1, %p2, %num, %theta;
my %ml;
my %array_1, %array_2;
$array_1[0] = $head[0];
$array_2[0][0] = $title;

my $total1 = 50, $total2 = 100, $total3 = 100;
my $step1 = 0.02, $step2 = 0.02, $step3 = 0.02;
my $bottom_1 = 1.0, $bottom_2 = 1.0;
my $q0, $s1, $s2;
my $f = 0.02;
my $best_q0, $best_s1, $best_s2;

while (my $line = <IN1>){
    chomp $line;
	my @z = split /\s+/, $line;
	$num{$z[0]} = $z[4];
	$p0{$z[0]} = $z[5];
	$p1{$z[0]} = $z[6];
	$p2{$z[0]} = $z[7];
	$theta{$z[0]} = $z[8];
}

my $num_file1 = 0; # 统计一共多少TE
my $num_file2 = 0;  #统计每个TE 一共包含多少个个体
while (my $line = <IN2>) {
    chomp $line;
	my @z = split /\s+/,$line;
	my $name = $z[0];
	#print $element;
	#print $name;
	if($name =~ $element){
	    $num_file2++;
	    $array_2[$num_file1][$num_file2] = $line;	
	}
	if($name !~ $element){
	    $num_file2 = 0;
		$element = $z[0];
		$num_file1++;
		$array_2[$num_file1][$num_file2] = $line;  
        $array_1[$num_file1] = $z[0];		
	}
}
close (IN1);
close (IN2);

print "start\n";
#for(my $i=0;$i<scalar(@array_2);$i++){
#print "array_1=$array_1[$i]\n";
#for(my $j=0;$j<scalar(@{$array_2[$i]});$j++){
#    print "$i\t$j\tarray_2=$array_2[$i][$j]\n";
#}}
print "end\n";

for(my $value1=0;$value1<scalar(@array_2);$value1++){
    $ml{$array_1[$value1]} = 0;
	my $temp1 = 1.0 - $theta{$array_1[$value1]};
	my $temp2 = $theta{$array_1[$value1]};
    my $maximum = -20000;	
	
	for (my $i=1; $i< $total1; $i++){ #q
	$q0 = $step1 * $i;
	for (my $j=0; $j< $total2; $j++){ #s1
	$s1 = $step2 * $j - $bottom_1;
	for (my $k=0; $k< $total3; $k++){ #s2
	$s2 = $step3 * $k - $bottom_2;
	#my $abs_s1 = abs($s1);
	#my $abs_s2 = abs($s2);
	
	if(($s1>=0&&$s2>=0)||($s1<=0&&$s2<=0)){   #ensure s1 has the same direction with s2
	$weight = 1.0 - 2.0*$q0*(1-$q0)*(1-$f)*$s1 - ($q0*$q0 + $f*$q*(1-$q0))*$s2;
	$p0_result = ((1-$q0)*(1-$q0)+$f*$q*(1-$q0))/$weight;
	$p1_result = 2.0*$q0*(1-$q0)*(1-$f)*(1-$s1)/$weight;
	$p2_result = ($q0*$q0+$f*$q*(1-$q0))*(1-$s2)/$weight;
    my $likelihood = 0;	
	
	for(my $value2=0;$value2<scalar(@{$array_2[$value1]});$value2++){
	    my $line = $array_2[$value1][$value2]; 
		chomp $line;
		my @z = split /\s+/,$line;
		#my $name = $z[0];
	    #my $type = $z[3];
	    #my $n_insert = $z[4];
	    #my $n_no = $z[5];
		if($z[3] =~/noinsert/){
			$pi_result = $p0_result + $p1_result*(($temp1)**$z[5]);
	    }
	    if($z[3] =~/homozygous/){
			$pi_result = $p2_result + $p1_result*(($temp2)**$z[4]);
	    }
	    if($z[3] =~/heterozygous/){
	        $pi_result =  $p1_result;
	    }
	    #print "$p0_result\t$p1_result\t$pi_result\n";
		if($pi_result>0){
	        $likelihood = $likelihood + log($pi_result);	    
		}
    }
	if($likelihood > $maximum){
		$maximum = $likelihood; 
		$best_q0 = $q0;
		$best_s1 = $s1;
		$best_s2 = $s2;
		print "$array_1[$value1]\t$best_q0\t$best_s1\t$best_s2\t$maximum\n";
	}
	}
    }
    }
	}
	$ml{$array_1[$value1]} = $maximum;
    print "result\t$array_1[$value1]\t$best_q0\t$best_s1\t$best_s2\t$ml{$array_1[$value1]}\n";
}
