
dir$ = "C:\Users\Gil\Desktop"
dir1$ = dir$ + "\alignments"
wavfile$ = "C:\Users\Gil\Desktop\wav.scp"
### get file locations of each wav file
Read Table from whitespace-separated file... 'wavfile$'
Rename... wavfiles
nRows = Get number of rows
Sort rows... utt_id
Create Strings as file list... list_txt 'dir1$'/*.txt
nFiles = Get number of strings
j=1
for i from 1 to nFiles
	select Table wavfiles
	uttid$ = Get column label... 1
	uttloc$ = Get column label... 2
	ids$ = Get value... j 'uttid$'
	locs$ = Get value... j 'uttloc$'
	# get each value per row of a column
	sound = Read from file: locs$
	dur1 = Get total duration
	textGrid = To TextGrid: "phones", ""
	#pause 'txtname$'
	select Strings list_txt
	filename$ = Get string... i
	txtname$ = filename$ - ".txt"

	Read Table from whitespace-separated file... 'dir1$'/'txtname$'.txt
	Rename... times
	nrows = Get number of rows
	for k from 1 to nrows
		select Table times
		file_utt_col$ = Get column label... 1
		file_col$ = Get column label... 2
		start_col$ = Get column label... 5
		dur_col$ = Get column label... 6
		phone_col$ = Get column label... 7
		if k < nrows
			startnextutt = Get value... k+1 'start_col$'
		else
			startnextutt = 0
		endif
		file_utt$ = Get value... k 'file_utt_col$'
		file_name$ = Get value... k 'file_col$'
		start = Get value... k 'start_col$'
		phone$ = Get value... k 'phone_col$'
		dur = Get value... k 'dur_col$'
		end =  start + dur
		select Table wavfiles
		if ids$ = file_utt$
			selectObject: textGrid
			int = Get interval at time... 1 start
			if start > 0 & startnextutt = 0
				Insert boundary... 1 start
				Set interval text... 1 int+1 'phone$'
				#Insert boundary... 1 end
			elsif start = 0
				Set interval text... 1 int 'phone$'
			elsif start > 0
				Insert boundary... 1 start
				Set interval text... 1 int+1 'phone$'
			endif 
		endif
		if  file_utt$ <> ids$ or k =nrows
			dir2$ = dir$+ "/" + "textgrids"
			createDirectory: dir2$
			dir3$ = dir2$ + "/" + file_name$
			createDirectory: dir3$ 
			grid$ = ids$ + ".TextGrid"
			outpath$ =  dir3$ + "/" + grid$
			selectObject: textGrid
			Save as text file: outpath$
			removeObject: textGrid
			j = j+1
			select Table wavfiles
			ids$ = Get value... j 'uttid$'
		 	locs$ = Get value... j 'uttloc$'
			Read from file: locs$
			dur1 = Get total duration
			#writeInfo: outpath$, tab$, j,  newline$ 
			textGrid = To TextGrid: "phones", ""
		endif
	endfor
endfor
