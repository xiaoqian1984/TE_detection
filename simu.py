#!usr/bin/python

import os
import sys
import re
import random

theta = 0.1
coverage = 5
clone = 50
f = 0.02

q0_list = [0.1, 0.2, 0.5, 0.9]
s1_list = [-1.0, -0.8, -0.5, -0.2, -0.1, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
s2_list = [-1.0, -0.8, -0.5, -0.2, -0.1, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]

f_11 = open('simu_1.txt','w')
f_12 = open('simu_2.txt','w') 
		
site = 0
for q in q0_list:
    for s1 in s1_list:
        for s2 in s2_list:
            f_11.write('site_' + str(site) + "\t" + str(q) + "\t" + str(s1) + "\t" + str(s2) + "\n")
	    w = 1.0 - 2.0 * q * (1.0 - q) * (1.0 - f) * s1 -(q * q + f * q * (1.0 - q)) * s2
            p0 = ((1.0 - q) * (1.0 - q) + f * q * (1.0 - q)) / w
            p1 = 2.0 * q * (1.0 - q) * (1.0 - f) * (1 - s1) / w 
            p2 = (q * q + f * q * (1.0 - q)) * (1 - s2) / w 
            
            num_clone = random.gauss(clone,20)
	    if num_clone <= 100:
	    	num_clone = random.gauss(clone,20)
            my_clone = 0			
	    while my_clone < num_clone:
		num_freq = random.random()
                if num_freq <= p0:
                    type_site = 'noinsert'
	        elif num_freq <= (p0 + p1):
                    type_site = 'heterozygous'
                else:
		    type_site = 'homozygous'
				
	        num_cov = random.gauss(coverage, 5)
	        num_theta = random.gauss(theta, 0.1)
		while num_cov <=0:
			num_cov = random.gauss(coverage,5)
	        while (num_theta>=1.0 or num_theta<=0.0):
		    num_theta = random.gauss(theta, 0.1)	    
	        read_1 = int(num_cov * theta)
	        read_2 = int(num_cov - int(read_1)) 	
					
	        f_12.write('site_' + str(site) + "\t" + 'clone_' + str(my_clone) + "\t" + '123456' + "\t" + str(type_site) + "\t" + str(read_1) + "\t" + str(read_2) + "\n")
		#print site'\t'my_count'\t'type'\t'read_1'\t'read_2	
	        my_clone += 1 
	    print "site_%d,%f,%f,%f" % (site,p0,p1,p2)			
	    site += 1		
	    		
					
					
