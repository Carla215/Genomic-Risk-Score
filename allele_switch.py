### Carla Smith 13/07/20
### Script to switch effect allele and beta sign (+/-) for pro/anti-inflammatory traits to build genetic risk score for inflammation
### Usage: $ python allele_switch.py <input file PREFIX> <pro/anti>

# import modules
import pandas as pd
import sys
import re

# prevent truncation of table in output file
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 200)

# set global variables for command-line arguments
inputfile = sys.argv[1] + ".vcf"
role = sys.argv[2]

# define summary statistics class and call extract function
class sumstats:
    def __init__(self, file):
        self.file = file
        self.chrom = []
        self.pos = []
        self.rsid = []
        self.ref_allele = []
        self.alt_allele = []
        self.form = []
        self.effect_size = []
        self.error = []
        self.pval = []
        self.freq = []
        self.extract(self.file) # call extract function
        self.switch() # call switch function
        self.write() # call function to write to outfile

   
        
    #extract information from different columns in infile    
    def extract(self, file):        
        with open(file) as infile:
            for line in infile:

                if not line.startswith('#'): # ignore commented-out text at beginning of file
                	#if "ES:SE:LP:AF:ID" not in line: # need this for _sun files, need to figure out workaround
                        #	pass
                	#else:
                    
		                # assign columns different names based on info they contain
		                line = line.strip()
		                header = line.split() # split lines into each column

		                try: 
		                    self.chrom.append(header[0]) # chromosome
		                    self.pos.append(header[1]) # position
		                    self.rsid.append(header[2]) # id of SNP
		                    self.ref_allele.append(header[3]) # effect allele
		                    self.alt_allele.append(header[4]) # non-effect allele
	    
		                    effect = header[9] # usually in format ES:SE:LP:AF:ID need to break these up

		                    # sort format out based on information contained in file
		                    self.form = header[8].split(':')

		                    # get effect size (beta)
		                    if "ES" in header[8]:
		                    	i = self.form.index("ES")
		                    	self.effect_size.append(effect.split(':')[i])

		                    # get standard error of beta
		                    if "SE" in header[8]:
		                    	i = self.form.index("SE")
		                    	self.error.append(effect.split(':')[i])

		                    # get -log10 p-value of beta and convert to p-value using exponential in numpy
		                    if "LP" in header[8]:
		                    	i = self.form.index("LP")
		                    	self.pval.append(10**(-float(effect.split(':')[i])))
		                    
		                    # get frequency of alt allele
		                    if "AF" in header[8]:
		                    	i = self.form.index("AF")
		                    	self.freq.append(effect.split(':')[i])

		                except IndexError: # need to prevent this as we are working on line n+1
		                    pass

        

    def switch(self): # switch sign of beta coefficient and swap effect/non-effect alleles where needed
            
            if role == "anti": # anti-inflammatory traits
                for i, x in enumerate(self.effect_size):
                    if float(x) > 0 and float(x) != 0: # if effect size is positive, make it negative
                        self.effect_size[i] = -float(x)
                        # switch ref and alt allele when effect size is positive
                        ref = self.ref_allele[i]
                        alt = self.alt_allele[i]
                        self.alt_allele[i] = ref
                        self.ref_allele[i] = alt
                        # calculate frequency of 'new' alt (effect) allele (if allele frequencies given)
                        if len(self.freq) > 0:
                        	freq = 1 - float(self.freq[i])
                        	self.freq[i] = freq
                    
            if role == "pro": # pro-inflammatory traits
                for i, x in enumerate(self.effect_size):
                    if float(x) < 0 and float(x) != 0: # if effect size is negative, make it positive
                        self.effect_size[i] = abs(float(x))
                        # switch ref and alt allele when effect size is negative
                        ref = self.ref_allele[i]
                        alt = self.alt_allele[i]
                        self.alt_allele[i] = ref
                        self.ref_allele[i] = alt
                        # calculate frequency of 'new' alt (effect) allele
                        if len(self.freq) > 0:
                        	freq = 1 - float(self.freq[i])
                        	self.freq[i] = freq
                    

    def write(self):
        # open an outfile to write to, with edited content
        outfile = open(sys.argv[1] + "_switched.vcf","w")
        #put data into a dataframe
        data = (self.chrom, self.pos, self.rsid, self.ref_allele, self.alt_allele, self.freq, self.effect_size, self.error, self.pval)
        df = pd.DataFrame(data) # put data into pandas dataframe
        df = df.T # transpose dataframe
        df.columns = ["chromosome", "position", "rsid", "A1", "A2", "MAF", "beta", "se", "p"] 
        outfile.write(str(df)) # write to outfile
        
           
    
# call the functions using input summary statistics file
sumstats(inputfile)
