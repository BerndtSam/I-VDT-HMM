import math
#sample_frequencies = [10, 20, 30, 60, 100, 200, 300, 600]
start_sample_rate = 1000;
sample_frequencies = [10, 20, 30, 50, 60, 100, 200, 300, 500, 600, 1000];

mainFile = 'Subsamples/s_0';

lineIndex = 0;

for input_file in range(1,11):
	if input_file < 10:
		writeFile = mainFile + '0' + str(input_file) + '_'
	else:
		writeFile = mainFile + str(input_file)+ '_'

	for sample_frequency in sample_frequencies:
		sample_rate = math.floor(start_sample_rate / sample_frequency)
		writeFileName = writeFile + str(sample_frequency) + '.txt'

		with open('s_007.txt', 'r') as eye_record_file:
			with open(writeFileName, 'w') as write_eye_record_file:
				lineIndex = 0;
				writeIndex = 0;
				for line in eye_record_file:
					# First line
					if lineIndex == 0:
						write_eye_record_file.write(line);
						lineIndex += 1;
						continue

					line = line.split()
					#print(line)
					try:
						if float(line[0]) % sample_rate == 0:
							line[0] = writeIndex;
							line[1] = writeIndex;
							writeIndex += 1;
							writeLine = '	'
							for item in line:
								writeLine += str(item) + '\t'
							writeLine = writeLine.strip()
							writeLine += '\n'
							write_eye_record_file.write(writeLine);
						lineIndex += 1;
					except:
						print(line)

